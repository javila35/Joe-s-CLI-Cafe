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
        self.milk = option
        self.save
    end

    def change_coffee(option)
        self[:type_of_coffee] = option
        self.save
    end

    def change_flavor(option)
        self.flavor = option
        self.save
    end

#methods so customers can learn about the coffee options
    def self.learn_about_coffee
        prompt = TTY::Prompt.new
        str = "Today's bean offering is #{Faker::Coffee.blend_name}. The beans are from #{Faker::Coffee.origin} with notes like #{Faker::Coffee.notes}."
        bean_offering = prompt.yes?("Would you like to hear about our beans?")
        if bean_offering
            puts str
        end
    end

    def self.make_drink(customer, order)
        prompt = TTY::Prompt.new
        drink = Drink.new
        selection = prompt.select("Choose your coffee:", Drink.coffees)
        drink.type_of_coffee = selection
        if selection == "Espresso" || selection == "Drip Coffee"
            Drink.learn_about_coffee
        end
        if selection == "Latte" || selection == "Macchiato"
            milk = prompt.select("What type of milk would you like?", Drink.milks)
            drink.milk = milk
        else
            milk_response = prompt.yes?("Would you like milk?")
            if milk_response
                milk = prompt.select("What type of milk would you like?", Drink.milks)
                drink.milk = milk
            end
        end
        flavor_response = prompt.yes?("Would you like to add a flavor?")
        if flavor_response
            flavor = prompt.select("Which flavor?", Drink.flavors)
            drink.flavor = flavor
        end
        drink.save
        order.drink_id = drink.id
        order.save
        drink.confirm_drink(customer)
    end

    def change_drink(customer)
        prompt = TTY::Prompt.new
        edit = prompt.select("Sure, what would you like to change?") do |menu|
            menu.choice 'Coffee', 0
            menu.choice 'Milk', 1
            menu.choice 'Flavor', 2
            menu.choice 'Everything', 3
            menu.choice 'Nevermind'
        end
        if edit == 0
            coffee = prompt.ask("What would you like?")
            self.change_coffee(coffee)
        elsif edit == 1
            milk = prompt.ask("What would you like?")
            self.change_milk(milk)
        elsif edit == 2
            flavor = prompt.ask("What would you like?")
            self.change_flavor(flavor)
        elsif edit == 3
            #find and destroy order, and drink... Restart.
            order = Order.find_by(customer_id == customer.id && drink_id == self.id)
            puts Rainbow("You're #{drink.type_of_coffee} was cancelled.").red
            Order.destroy(order.id)
            Drink.destroy(drink.id)
            Order.prompt_order(customer)
        end
            self.confirm_drink(customer)
    end

    def confirm_drink(customer)
        prompt = TTY::Prompt.new
        if self.milk == nil && self.flavor == nil
            confirm = prompt.yes?("I have a #{self.type_of_coffee}. Is that right?")
        elsif self.milk == nil && self.flavor
            confirm = prompt.yes?("I have a #{self.flavor} #{self.type_of_coffee}. Is that right?")
        elsif self.flavor == nil && self.milk
            confirm = prompt.yes?("I have a #{self.type_of_coffee} with #{self.milk}. Is that right?")
        else
            confirm = prompt.yes?("I have a #{self.flavor} #{self.type_of_coffee} with #{self.milk}. Is that right?")
        end
        if confirm
            # binding.pry
            order = Order.find_by(drink_id: self.id, customer_id: customer.id)
            ##confirmed order needs to be finished then I think I'm done??
            order.confirmed_order
        else
            self.change_drink(customer)
        end
    end
end