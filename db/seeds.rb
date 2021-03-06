# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

require 'csv'
require 'activerecord-import'
require 'open-uri'
require 'nokogiri'


Category.destroy_all
Currency.destroy_all
Share.destroy_all
Preconisation.destroy_all

User.destroy_all
Company.destroy_all
Periodicity.destroy_all
UserCompany.destroy_all

# Create admin polo
User.create(email:"polo@gmail.com", password:"123456", password_confirmation:"123456", admin:true)
Company.create(name:"EOS Allocations")
UserCompany.create(user_id: User.last.id, company_id: Company.last.id)
# Create user Pierre
User.create(email:"pierre@gmail.com", password:"123456", password_confirmation:"123456", admin:false)
UserCompany.create(user_id: User.last.id, company_id: Company.last.id)


# Timer ---------------------------------------------
t1 = Time.now

# IMPORT DES SHARES -----------------------------------------------------------
# -----------------------------------------------------------------------------
puts 'Create shares'
puts '*' *30

i= 0

valid_shares = []

filepath = 'db/MASTER fr.csv'
csv_options = { col_sep: ';', quote_char: '"', force_quotes: true,
                headers: :first_row, header_converters: :symbol }

CSV.foreach(filepath, csv_options) do |row|
  shares = Share.new(isin: row[:isin],
                     secid: row[:secid],
                     performanceid: row[:performanceid],
                     fundid: row[:fundid],
                     securityname: row[:securityname],
                     companyname: row[:companyname],
                     fundname: row[:fundname],
                     legalstructure: row[:legalstructure],
                     shareclasslegalname: row[:shareclasslegalname],
                     ucits: row[:ucits],
                     morningstarcategoryid: row[:morningstarcategoryid],
                     isbasecurrency: row[:isbasecurrency],
                     isprimaryshareclass: row[:isprimaryshareclass],
                     currencyspecificisin: row[:currencyspecificisin],
                     currencyid: row[:currencyid],
                     masterportfolioid: row[:masterportfolioid],
                     legalstructureid: row[:legalstructureid],
                     fr_pea: row[:fr_pea],
                     portfoliodate: row[:portfoliodate]
                    )

  valid_shares << shares

  i += 1
  # puts "#{i} | #{Share.last.isin}"

  if (i % 10000) == 0 then
    Share.import valid_shares
    puts "#{i/10000} milliers de shares crées"
    valid_shares = []
  end
end

if valid_shares.count > 0 then
  Share.import valid_shares
end

# Timer ---------------------------------------------
t2 = Time.now
delta = t2 - t1


puts '*' *30
puts "#{Share.count} shares created in #{delta/60} minutes"
puts '*' *30

# IMPORT DES CATEGORIES -------------------------------------------------------
# -----------------------------------------------------------------------------
puts 'Create Categories'
puts '*' *30
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

# *****************************************************************
# IMPORT CURRENCIES
# à faire avec le chemin http !!! -----------------------------
# http://edw.morningstar.com/GetDictionaryXML.aspx?ClientId=EOS&DicType=TYPECODE&Id=Currency&Search=
# *****************************************************************
puts '*' *30
puts 'Create currencies'

valid_currencies = []

file = File.open('db/currencies.xml')
document = Nokogiri::XML(file)

document.root.children.each do |currency|

    currency = Currency.new(
      typecodeid: (currency.xpath('TypeCodeId').text).to_i,
      typecodegroup: currency.xpath('TypeCodeGroup').text,
      typecode: currency.xpath('TypeCode').text,
      definition: currency.xpath('Definition').text,
      definition_french: currency.xpath('Definition_French').text
    )

  valid_currencies << currency

end

Currency.import valid_currencies


puts '*' *30
puts 'Create preconisations entries'


Preconisation.create(name:'Vendre', value:0)
Preconisation.create(name:'Alléger', value:1)
Preconisation.create(name:'Neutre', value:2)
Preconisation.create(name:'Conserver', value:3)
Preconisation.create(name:'Acheter', value:4)

puts '*' *30
puts 'Create periodicities entries'

Periodicity.create(period_end: Date.today.end_of_quarter, name:"Trimestrielle")
puts "Date de fin de trimestre : #{Date.today.end_of_quarter}"
Periodicity.create(period_end: Date.today.end_of_month, name:"Mensuelle")
puts "Date de fin de mois : #{Date.today.end_of_month}"

# IMPORT COMMENTAIRES VIA CSV -------------------------------------------------
# -----------------------------------------------------------------------------
  puts '*' *30
  puts 'Create reviews and add shares to share_catalog EOS Allocations'
  # Timer ---------------------------------------------
  t1 = Time.now

  eos = Company.where(name: "EOS Allocations").first
  filepath = 'db/eos-reviews.csv'
  csv_options = { col_sep: ';', quote_char: '"', force_quotes: true,
                  headers: :first_row, header_converters: :symbol }

  CSV.foreach(filepath, csv_options) do |row|
    share = Share.where(isin: row[:isin]).first
          # p row[:structure]
    if !share.nil?
      review = Review.create(share: share,
                             investment_strategy: row[:structure],
                             current_strategy: row[:actualite],
                             preconisation_id: rand(5).to_i)

      ShareCatalog.create(share: share, company: eos, status: true)
      puts "#{share.securityname} ajouté à la liste #{eos.name}"
    end
  end

  # Timer ---------------------------------------------
  t2 = Time.now
  delta = t2 - t1

  puts "#{ShareCatalog.count} fonds ajoutés à la liste #{eos.name} in #{delta} minutes"
  puts '*' *30



# IMPORT CATEGORIES par fichier xml
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
