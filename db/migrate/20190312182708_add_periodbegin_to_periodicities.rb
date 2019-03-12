class AddPeriodbeginToPeriodicities < ActiveRecord::Migration[5.2]
  def change
    add_column :periodicities, :period_begin, :date
  end
end
