class Drink < ActiveRecord::Base
    has_many :orders
    has_many :customers, through: :orders
    
    @@milks = ["Soy Milk", "Almond Milk", "Oat Milk", "Whole Milk", "2% Milk", "Nonfat", "Half & Half"]
    @@coffees = ["Espresso", "Drip Coffee", "Latte", "Macchiato", "Tea", "Cold Brew", "Chai Tea"]
    @@flavors = ["Vanilla", "Chocolate", "Cinnamon", "Lavender"]

    def self.list_the_options
        str = ""
        @@coffees.each do |coffee| 
            if coffee == @@coffees[-1]
                str += "and #{coffee}.\n"
            elsif coffee == @@coffees[0]
                str += "Your coffee options are: #{coffee}, "
            else
                str += "#{coffee}, "
            end
        end
        @@milks.each do |milk| 
                if milk == @@milks[-1]
                    str += "and #{milk}.\n"
                elsif milk == @@milks[0]
                    str += "Your milk options are: #{milk}, "
                else
                    str += "#{milk}, "
                end
            end
        flavor_options = @@flavors.each do |flavors| 
            if flavors == @@flavors[-1]
                str += "and #{flavors}."
            elsif flavors == @@flavors[0]
                str += "Your flavor options are: #{flavors}, "
            else
                str += "#{flavors}, "
            end
        end
        puts str
    end

    def self.list_milk_options
        str = " "
        @@milks.each do |milk| 
            if milk == @@milks[-1]
                str += "and #{milk}."
            else
                str += "#{milk}, "
            end
        end
        p "Your milk options are: #{str}"
    end

    def self.list_coffee_options
        str = " "
        @@coffees.each do |coffee| 
            if coffee == @@coffees[-1]
                str += "and #{coffee}."
            else
                str += "#{coffee}, "
            end
        end
        p "Your coffee options are: #{str}"
    end

    def self.list_flavor_options
        str = " "
        flavor_options = @@flavors.each do |flavors| 
            if flavors == @@flavors[-1]
                str += "and #{flavors}."
            else
                str += "#{flavors}, "
            end
        end
        p "Your flavor options are: #{str}"
    end

    def change_milk(option)
        self[:milk] = (@@milks.select{|milk| milk == option}).first
    end

    def change_coffee(option)
        self[:type_of_coffee] = (@@coffees.select{|coffee| coffee == option}).first
    end

    def change_flavor(option)
        self[:flavor] = (@@flavors.select{|flavor| flavor == option})
    end
end