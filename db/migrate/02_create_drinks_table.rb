class CreateDrinksTable < ActiveRecord::Migration
    def change
        create_table :drinks do |t|
            t.string :type_of_coffee
            t.string :milk
            t.string :flavor
            t.datetime :make_time
        end
    end
end