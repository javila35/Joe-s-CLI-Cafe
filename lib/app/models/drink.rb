class Drink < ActiveRecord::Base
    has_many :orders
    has_many :customers, through: :orders
    
    @@milks = ["Soy Milk", "Almond Milk", "Oat Milk", "Whole Milk", "2% Milk", "Nonfat", "Half & Half"]

    def change_milk(option)
        self[:milk] = (@@milks.select{|milk| milk == option}).first
    end
end