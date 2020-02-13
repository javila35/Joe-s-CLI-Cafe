class Drink < ActiveRecord::Base
    has_many :orders
    has_many :customers, through: :orders

    @@milks = ["Soy Milk", "Almond Milk", "Oat Milk", "Whole Milk", "2% Milk", "Nonfat", "Half & Half"]
    @@coffees = ["Espresso", "Drip Coffee", "Latte", "Macchiato", "Tea", "Cold Brew", "Chai Tea"]
    @@flavors = ["Vanilla", "Chocolate", "Cinnamon", "Lavender"]

#making readers for arrays containing drink options.
    def self.milks
        @@milks
    end
    
    def self.coffees
        @@coffees
    end

    def self.flavors
        @@flavors
    end

#methods that make it so customers can see all the options, or specific options (milk, coffees, flavors)
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
        @@flavors.each do |flavors| 
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

#methods so customers can change their options.
    def change_milk(option)
        self[:milk] = option
    end

    def change_coffee(option)
        self[:type_of_coffee] = option
    end

    def change_flavor(option)
        self[:flavor] = option
    end

#methods so customers can learn about the coffee options
    def self.learn_about_coffee
        str = "Today's Drip Coffee is #{Faker::Coffee.blend_name}. The beans are from #{Faker::Coffee.origin} with notes like #{Faker::Coffee.notes}."
        puts str
    end
end