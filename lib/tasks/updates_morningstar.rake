# *********************************************************************
# COMMANDE LANCEMMENT DES TACHES DEPUIS TERMINAL:
# rake updates_morningstar:categories_update
# *********************************************************************
require 'csv'
require 'activerecord-import'
require 'open-uri'
require 'nokogiri'

namespace :updates_morningstar do
  desc "TODO"
  task categories_update: :environment do
    # IMPORT DES CATEGORIES -------------------------------------------------------
    # -----------------------------------------------------------------------------
    Category.destroy_all

    puts 'Create Categories'
    puts '*' * 30
    # Timer ---------------------------------------------
    t1 = Time.now
    # *****************************************************************
    valid_categories = []

    file = open("http://edw.morningstar.com/GetDictionaryXML.aspx?ClientId=EOS&DicType=TYPECODE&Id=Morningstar%20Category&Search=")

    document = Nokogiri::XML(file)

    document.root.children.each do |category|
      def_fr = category.xpath('Definition_French').text

      category = Category.new(
                              typecodeid: category.xpath('TypeCodeId').text,
                              typecodegroup: category.xpath('TypeCodeGroup').text,
                              typecode: category.xpath('TypeCode').text,
                              definitionfrench: def_fr,
                              definition: category.xpath('Definition').text
                            )

      valid_categories << category
    end

    Category.import valid_categories
    # Timer ---------------------------------------------
    t2 = Time.now
    delta = t2 - t1

    puts "#{Category.count} categories created in #{delta} minutes"
  end

# FETCH FUND MONTHLY PERFORMANCES IN MORNINGSTAR WAREHOUSE ---------------------
# ------------------------------------------------------------------------------
  task monthly_fund_performance_morningstar: :environment do
    file = open("http://edw.morningstar.com/DataOutput.aspx?Package=EDW&ClientId=EOS&Id=F000000DUW&IDTYpe=FundShareClassId&Content=1471&Currencies=BAS")
    document = Nokogiri::XML(file)

    fund_monthly_total_return = {
                                  ytd: document.xpath("/FundShareClass/ClassPerformance/Performance/TrailingPerformance[@Type='1000']/TrailingReturn/Return[@Type='1']/ReturnDetail[@TimePeriod='M0']/Value").text.to_f,
                                  M12: document.xpath("/FundShareClass/ClassPerformance/Performance/TrailingPerformance[@Type='1000']/TrailingReturn/Return[@Type='1']/ReturnDetail[@TimePeriod='M12']/Value").text.to_f,
                                  M1: document.xpath("/FundShareClass/ClassPerformance/Performance/TrailingPerformance[@Type='1000']/TrailingReturn/Return[@Type='1']/ReturnDetail[@TimePeriod='M1']/Value").text.to_f,
                                  M2: document.xpath("/FundShareClass/ClassPerformance/Performance/TrailingPerformance[@Type='1000']/TrailingReturn/Return[@Type='1']/ReturnDetail[@TimePeriod='M2']/Value").text.to_f,
                                  M3: document.xpath("/FundShareClass/ClassPerformance/Performance/TrailingPerformance[@Type='1000']/TrailingReturn/Return[@Type='1']/ReturnDetail[@TimePeriod='M3']/Value").text.to_f,
                                  M6: document.xpath("/FundShareClass/ClassPerformance/Performance/TrailingPerformance[@Type='1000']/TrailingReturn/Return[@Type='1']/ReturnDetail[@TimePeriod='M6']/Value").text.to_f
                                }

    puts "Vérification hash des monthly performance : "
    puts fund_monthly_total_return
    puts "/**********************************************"
  end
end

# UPDATE DE LA DATE DE FIN DE TRIMESTRE ET FIN DE MOIS -------------------------
# DANS LA TABLE "periodicities" ------------------------------------------------

namespace :update_periodicity do
  desc "TODO"
  task period_end: :environment do
    puts '*' * 30
    puts 'Create periodicities entries'
# Dates Trimestrielle ----------------------------------------------------------
    Periodicity.where(name: "Trimestrielle").first.update(period_begin: Date.today.beginning_of_quarter)
    puts "Date début de trimestre : #{Date.today.beginning_of_quarter}"
    Periodicity.where(name: "Trimestrielle").first.update(period_end: Date.today.end_of_quarter)
    puts "Date fin de trimestre : #{Date.today.end_of_quarter}"
# Dates Mensuelle --------------------------------------------------------------
    Periodicity.where(name: "Mensuelle").first.update(period_begin: Date.today.beginning_of_month)
    puts "Date début de mois : #{Date.today.beginning_of_month}"
    Periodicity.where(name: "Mensuelle").first.update(period_end: Date.today.end_of_month)
    puts "Date fin de mois : #{Date.today.end_of_month}"
  end
end
