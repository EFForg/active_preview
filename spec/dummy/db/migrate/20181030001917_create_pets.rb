class CreatePets < ActiveRecord::Migration[5.1]
  def change
    create_table :pets do |t|
      t.string :name
      t.belongs_to :person

      t.timestamps
    end
  end
end
