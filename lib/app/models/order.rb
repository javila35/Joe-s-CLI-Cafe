class Order < ActiveRecord::Base
    belongs_to :customer
    belongs_to :drink
    
    def info
        puts Rainbow("#{self.customer.name} ordered a #{self.drink.type_of_coffee}.").green
    end
end