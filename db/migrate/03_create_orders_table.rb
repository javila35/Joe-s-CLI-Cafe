class CreateOrdersTable < ActiveRecord::Migration[5.2]
    def change
        create_table :orders do |t|
            t.integer :customer_id
            t.integer :drink_id
        end
    end
end