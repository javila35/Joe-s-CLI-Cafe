require "tty-prompt"

class Customer < ActiveRecord::Base
    has_many :orders
    has_many :drinks, through: :orders
    
    def see_the_options
        Drink.list_the_options
    end

    def learn_about_coffee
        str = "Hello, #{self.name}. " + "#{Drink.learn_about_coffee}"
        puts str
    end

    def order_drink(coffee, milk=nil, flavor=nil)
        order = Drink.create(type_of_coffee:coffee, milk: milk, flavor: flavor)
        Order.create(customer_id: self.id, drink_id: order.id)
        puts Rainbow("I've got a #{order.type_of_coffee} for #{self.name}.").purple.underline
    end

    def find_my_orders
        order = Order.find_by(customer_id: self.id)
    end

    def cancel_order
        order = self.find_my_orders
        order.destroy
    end

    def make_drink
        customer = Customer.find(self.id)
        prompt = TTY::Prompt.new
        selection = prompt.select("Choose your coffee:", Drink.coffees)
        drink = Drink.create(type_of_coffee: selection)
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
        order = Order.create(customer_id: self.id, drink_id: drink.id)
        puts "Order number #{order.id} is ready! Enjoy your #{drink.milk} #{drink.flavor} #{drink.type_of_coffee}."
    end

    def self.begin_visit
        customer = Customer.create()
        prompt = TTY::Prompt.new
        puts "Welcome to Joe's Cafe."
        name = prompt.ask("What's your name?")
        customer.name = name
        response = prompt.yes?("#{name}, would you like something to drink?")
        if response
            a = prompt.yes?("Do you know what you'd like?")
            if a 
                customer.make_drink()
            else
                customer.see_the_options
            end
        else
            "Thanks for coming, have a good day."
        end
        # binding.pry
    end

    
end