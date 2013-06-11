class CreateSpreeSuppliers < ActiveRecord::Migration
  def change
    create_table :spree_suppliers do |t|
      t.string :name, :null => false
      t.string :email
      t.string :phone
      t.string :website

      t.timestamps
    end
  end
end
