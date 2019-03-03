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
end

    # IMPORT CATEGORIES
    # à faire avec le chemin http !!! -----------------------------
    # http://edw.morningstar.com/GetDictionaryXML.aspx?ClientId=EOS&DicType=TYPECODE&Id=Morningstar%20Category&Search=
    # *****************************************************************
    # valid_categories = []
    # file = File.open('db/categories.xml')
    # document = Nokogiri::XML(file)

    # document.root.children.each do |category|
    #   def_fr = category.xpath('Definition_French').text
    #   if !def_fr.empty?
    #     category = Category.new(
    #                             typecodeid: category.xpath('TypeCodeId').text,
    #                             typecodegroup: category.xpath('TypeCodeGroup').text,
    #                             typecode: category.xpath('TypeCode').text,
    #                             definitionfrench: def_fr,
    #                             definition: category.xpath('Definition').text
    #     )
    #   valid_categories << category
    #   end
    # end

    # Category.import valid_categories
