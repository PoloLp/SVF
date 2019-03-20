# *********************************************************************
# COMMANDE LANCEMMENT DES TACHES DEPUIS TERMINAL:
# rake update_periodicity:period_end
# *********************************************************************

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

namespace :create_periodicity do
  desc "TODO"
  task period_end: :environment do
    puts '*' * 30
    puts 'Create periodicities entries'
# Dates Trimestrielle ----------------------------------------------------------
    x = Periodicity.create(name: "Trimestrielle", period_begin: Date.today.beginning_of_quarter)
    puts "Date début de trimestre : #{Date.today.beginning_of_quarter}"
    x.update(name: "Trimestrielle", period_end: Date.today.end_of_quarter)
    puts "Date fin de trimestre : #{Date.today.end_of_quarter}"
# Dates Mensuelle --------------------------------------------------------------
    y = Periodicity.create(name: "Mensuelle", period_begin: Date.today.beginning_of_month)
    puts "Date début de mois : #{Date.today.beginning_of_month}"
    y.update(name: "Mensuelle", period_end: Date.today.end_of_month)
    puts "Date fin de mois : #{Date.today.end_of_month}"
  end
end
