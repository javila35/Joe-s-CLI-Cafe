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
end