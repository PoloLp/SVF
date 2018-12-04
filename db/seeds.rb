# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

require 'csv'
require 'activerecord-import'
require 'open-uri'
require 'nokogiri'


require 'pry-byebug'
# puts 'Create shares'
# p '*' *30
# Timer ---------------------------------------------
t1 = Time.now

# i= 0

# 1valid_shares = []

# filepath = 'db/MASTER fr.csv'
# csv_options = { col_sep: ';', quote_char: '"', force_quotes: true,
#                 headers: :first_row, header_converters: :symbol }

# CSV.foreach(filepath, csv_options) do |row|
#   shares = Share.new(isin: row[:isin]
#                       )

#   valid_shares << shares

#   # shares.save
#   i += 1
#   # puts "#{i} | #{Share.last.isin}"

#   if (i % 10000) == 0 then
#   puts "#{i/10000} milliers de shares crées"
#   end
# end

# Share.import valid_shares

# Timer ---------------------------------------------
t2 = Time.now
delta = t2 - t1

# p '*' *30
# puts "#{Share.count} shares created in #{delta/60} minutes"

# à faire avec le chemin http !!!

p '*' *30
puts 'Create Categories'
p '*' *30

file = File.open('db/categories.xml')
document = Nokogiri::XML(file)
# byebug
document.root.children.each do |category|
  type_code_id = category.xpath('TypeCode').text
  def_fr = category.xpath('Definition_French').text
  def_en = category.xpath('Definition').text
  p "#{type_code_id} | nom fr : #{def_fr} | nom en : #{def_en}"
end



      # t.bigint :typecodeid
      # t.string :typecodegroup
      # t.string :typecode
      # t.string :definitionfrench
      # t.string :definition
