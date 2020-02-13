require "tty-prompt"

class Customer < ActiveRecord::Base
    has_many :orders
    has_many :drinks, through: :orders
    
    def see_the_options
        Drink.list_the_options
    end

    def learn_about_coffee
        puts "#{Drink.learn_about_coffee}"
    end

    def order_drink(coffee, milk=nil, flavor=nil)
        order = Drink.create(type_of_coffee:coffee, milk: milk, flavor: flavor)
        Order.create(customer_id: self.id, drink_id: order.id)
        puts Rainbow("I've got a #{order.type_of_coffee} for #{self.name}.").purple.underline
    end

    def cancel_order
        order = self.find_my_orders
        order.destroy
    end

    def self.begin_visit
        prompt = TTY::Prompt.new
        puts "Welcome to Joe's Cafe."
        name = prompt.ask("What's your name?")
        Customer.create(name: name)
        customer = Customer.find_by(name: name)
        response = prompt.yes?("#{name}, would you like something to drink?")
        if response
            Customer.prompt_order(customer)
        else
            customer.goodbye
        end
    end

    def self.prompt_order(customer)
        prompt = TTY::Prompt.new
        a = prompt.yes?("Do you know what you'd like?")
        if a 
            customer.make_drink
        else
            customer.see_the_options
            b = prompt.yes?("Can I get you anything?")
            if b 
                customer.make_drink
            else
                customer.goodbye
            end
        end
    end

    def make_drink
        prompt = TTY::Prompt.new
        selection = prompt.select("Choose your coffee:", Drink.coffees)
        drink = Drink.create(type_of_coffee: selection)
        drink.id
        if selection == "Espresso" || selection == "Drip Coffee"
            bean_offering = prompt.yes?("#{self.name}, would you like to hear about our beans?")
            if bean_offering
                self.learn_about_coffee
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
        puts "Order number #{order.id} is ready! Enjoy your #{drink.milk} #{drink.flavor} #{drink.type_of_coffee}."
    end

    
    def goodbye
        puts "Thanks for coming, #{self.name}! Have a good day."
    end

end