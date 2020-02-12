class CreateOrdersTable < ActiveRecord::Migration[5.2]
    def change
        create_join_table :customers, :drinks, table_name: :orders do |t|
            
        end
    end
end