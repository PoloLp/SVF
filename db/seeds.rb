# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

require 'csv'
require 'activerecord-import'
require 'open-uri'
require 'nokogiri'
require 'pry-byebug'

puts 'Create shares'
p '*' *30

# Timer ---------------------------------------------
t1 = Time.now

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
    puts "#{i/10000} milliers de shares crées"
  end
end

Share.import valid_shares

# Timer ---------------------------------------------
t2 = Time.now
delta = t2 - t1

p '*' *30
puts "#{Share.count} shares created in #{delta/60} minutes"
p '*' *30
puts 'Create Categories'
p '*' *30

# Timer ---------------------------------------------
t1 = Time.now

valid_categories = []

# *****************************************************************
# à faire avec le chemin http !!! -----------------------------
# *****************************************************************
file = File.open('db/categories.xml')
document = Nokogiri::XML(file)

document.root.children.each do |category|

  def_fr = category.xpath('Definition_French').text

  if !def_fr.empty?
    category = Category.new(
                            typecodeid: category.xpath('TypeCodeId').text,
                            typecodegroup: category.xpath('TypeCodeGroup').text,
                            typecode: category.xpath('TypeCode').text,
                            definitionfrench: def_fr,
                            definition: category.xpath('Definition').text
    )
  valid_categories << category
  end

end

Category.import valid_categories

# Timer ---------------------------------------------
t2 = Time.now
delta = t2 - t1

puts "#{Category.count} categories created in #{delta} minutes"
