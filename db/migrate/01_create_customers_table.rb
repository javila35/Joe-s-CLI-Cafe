class CreateCustomersTable < ActiveRecord::Migration
    def change
        create_table :customers do |t|
            t.string :name
            t.string :preferred_drink
        end
    end
end