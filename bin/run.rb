require_relative '../config/environment'

c1 = Customer.all.sample
d1 = Drink.all.sample
order = Order.all.sample

Customer.begin_visit