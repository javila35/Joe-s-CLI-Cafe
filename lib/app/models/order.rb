class Order < ActiveRecord::Base
    belongs_to :customer
    belongs_to :drink
    
    def info
        puts Rainbow("#{self.customer.name} ordered a #{self.drink.type_of_coffee}.").green
    end

    def self.prompt_order(customer)
        prompt = TTY::Prompt.new
        see_menu = prompt.yes?("Would you like to see the menu?")
        if see_menu 
            Drink.list_the_options
        end
        response = prompt.yes?("#{customer.name}, would you like something to drink?")
        if response
            new_order = Order.new
            new_order.customer_id = customer.id 
            new_order.save
            Drink.make_drink(customer, new_order)
        else
            CommandLineInterface.goodbye(customer)
        end
    end

    def confirmed_order(drink)
        Order.create(customer_id: self.id, drink_id: drink.id)
        order = Order.find_by(drink_id: drink.id)
        puts Rainbow("Order ##{order.id} for #{order.customer.name} is ready! A #{drink.type_of_coffee}.").green
        CommandLineInterface.goodbye(customer)
    end
end