class Customer < ActiveRecord::Base
    has_many :orders
    has_many :drinks, through: :orders
    
    def see_the_options
        Drink.list_the_options
    end

    def order_drink(coffee, milk=nil, flavor=nil)
        order = Drink.create(type_of_coffee:coffee, milk: milk, flavor: flavor)
        puts "I've got a #{order.type_of_coffee} for #{self.name}."
    end

    def Customer.order_drink
        puts "Hi, welcome to Joe's Cafe. What can I get you?"
        drink = gets.chomp
        puts "Great would you like any milk with your #{drink}."

        # Drink.create(type_of_coffee: coffee, milk: milk, flavor: flavor)
    end
end