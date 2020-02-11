class CreateDrinksTable < ActiveRecord::Migration[5.2]
    def change
        create_table :drinks do |t|
            t.string :type_of_coffee
            t.string :milk
            t.string :flavor
            t.integer :make_time
        end
    end
end