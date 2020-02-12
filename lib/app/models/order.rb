class Order < ActiveRecord::Base
    belongs_to :customer
    belongs_to :drink
    
    def info
        puts "#{self.customer.name} ordered a #{self.drink.type_of_coffee}."
    end
end