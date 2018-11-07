class CreateRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :roles do |t|
      t.belongs_to :person

      t.timestamps
    end
  end
end
