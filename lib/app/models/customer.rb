require "tty-prompt"

class Customer < ActiveRecord::Base
    has_many :orders
    has_many :drinks, through: :orders

#when rake run is typed into terminal this method is called and begins an interactive ordering process.
    def self.begin_visit
        prompt = TTY::Prompt.new
        puts "Welcome to Joe's Cafe!"
        name = prompt.ask("What's your name?")
        Customer.create(name: name)
        customer = Customer.find_by(name: name)
        response = prompt.yes?("#{name}, would you like something to drink?")
        if response
            customer.prompt_order
        else
            customer.goodbye
        end
    end

    def prompt_order
        prompt = TTY::Prompt.new
        a = prompt.yes?("Do you know what you'd like?")
        if a 
            self.make_drink
        else
            Drink.list_the_options
            b = prompt.yes?("Can I get you anything?")
            if b 
                self.make_drink
            else
                self.goodbye
            end
        end
    end

    def make_drink
        prompt = TTY::Prompt.new(symbols: {marker: '→'})
        selection = prompt.select("Choose your coffee:", Drink.coffees)
        drink = Drink.create(type_of_coffee: selection)
        drink.id
        if selection == "Espresso" || selection == "Drip Coffee"
            bean_offering = prompt.yes?("#{self.name}, would you like to hear about our beans?")
            if bean_offering
                Drink.learn_about_coffee
            end
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
        self.confirm_order(drink)
    end

    def confirm_order(drink)
        prompt = TTY::Prompt.new
        change_drink = prompt.yes?("Would you like to change any of your choices?")
        if change_drink
            edit = prompt.select("Sure, what would you like to change?") do |menu|
                menu.help 'Wow this person is really needy...'
                menu.choice 'Coffee', 0
                menu.choice 'Milk', 1
                menu.choice 'Flavor', 2
                menu.choice 'Nevermind', echo: false
            end
            if edit == 0
                coffee = prompt.ask("What would you like?")
                drink.change_coffee(coffee)
            elsif edit == 1
                milk = prompt.ask("What would you like?")
                drink.change_milk(milk)
            elsif edit == 2
                flavor = prompt.ask("What would you like?")
                drink.change_flavor(flavor)
            end
        end
        if drink.milk == nil && drink.flavor == nil
            confirm = prompt.yes?("I have a #{drink.type_of_coffee}. Is that right?")
        elsif drink.milk == nil && drink.flavor
            confirm = prompt.yes?("I have a #{drink.flavor} #{drink.type_of_coffee}. Is that right?")
        elsif drink.flavor == nil && drink.milk
            confirm = prompt.yes?("I have a #{drink.type_of_coffee} with #{drink.milk}. Is that right?")
        else
            confirm = prompt.yes?("I have a #{drink.flavor} #{drink.type_of_coffee} with #{drink.milk}. Is that right?")
        end
        if confirm
            self.confirmed_order(drink)
        else
            remake = prompt.yes?("Alright, will you let us try to get it right?")
            if remake
                Drink.destroy(drink.id)
                self.make_drink
            else
                Drink.destroy(drink.id)
                self.goodbye
            end
        end
    end
    
    def confirmed_order(drink)
        order = Order.create(customer_id: self.id, drink_id: drink.id)
        str = "Order number #{order.id} is ready! Enjoy your "
        if drink.milk
            str += "#{drink.milk} "
        end
        if drink.flavor
            str += "#{drink.flavor} "
        end
        str += "#{drink.type_of_coffee}."
        puts str
    end

    def goodbye
        puts "Thanks for coming, #{self.name}! Have a good day."
    end

end