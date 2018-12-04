class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.bigint :typecodeid
      t.string :typecodegroup
      t.string :typecode
      t.string :definitionfrench
      t.string :definition

      t.timestamps
    end
  end
end
