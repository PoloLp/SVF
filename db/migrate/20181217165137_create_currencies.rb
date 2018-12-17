class CreateCurrencies < ActiveRecord::Migration[5.2]
  def change
    create_table :currencies do |t|
      t.bigint :typecodeid
      t.string :typecodegroup
      t.string :typecode
      t.string :definition
      t.string :definition_french
      t.string :definition_spanish
      t.string :definition_chinese

      t.timestamps
    end
  end
end
