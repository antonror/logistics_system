class CreateSupplierStocks < ActiveRecord::Migration[6.0]
  def change
    create_table :supplier_stocks do |t|
      t.string :product_name
      t.string :supplier
      t.integer :in_stock
    end
  end
end
