class CreateOrdersTable < ActiveRecord::Migration
    def change
        create_join_table :customers, :drinks, table_name: :orders do |t|
            t.index :customer_id
            t.index :drink_id
        end
    end
end