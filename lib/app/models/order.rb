class Order < ActiveRecord::Base
    belongs_to :customer
    belongs_to :drink
    
    def info
        str = "#{Rainbow(self.customer.name).blue} " + "ordered a" + " #{Rainbow(self.drink.type_of_coffee).brown.bright}."
        puts str
    end
end