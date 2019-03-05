# *********************************************************************
# COMMANDE LANCEMMENT DES TACHES DEPUIS TERMINAL:
# rake updates_morningstar:categories_update
# *********************************************************************
require 'csv'
require 'open-uri'

namespace :import_eos do
  desc "TODO"
# IMPORT REVUES DE FONDS DEPUIS CSV -------------------------------------------
# -----------------------------------------------------------------------------
  task import_reviews_csv: :environment do
    puts 'Create reviews and add shares to share_catalog EOS Allocations'
    puts '*' *30
    # Timer ---------------------------------------------
    t1 = Time.now

    eos = Company.where(name: "EOS Allocations").first
    filepath = 'db/eos-reviews.csv'
    csv_options = { col_sep: ';', quote_char: '"', force_quotes: true,
                    headers: :first_row, header_converters: :symbol }

    CSV.foreach(filepath, csv_options) do |row|
      share = Share.where(isin: row[:isin]).first

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
  end
end
