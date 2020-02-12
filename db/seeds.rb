require_relative '../config/environment.rb'

# Seed data for Customers.
dinasours = ["Aidan","Chris","Clarion","David","Diana","Jazz","Johnny","Joe","Kailana","Kevin","Lief","Matt","Kim","Soundarya","Zeb","Gabriel","Hal","Jack"]

dinasours.each do |person|
    Customer.create(name: person)
end

10.times do
    Drink.create(milk: Drink.milks.sample, type_of_coffee: Drink.coffees.sample, flavor: Drink.flavors.sample)
end

10.times do
    c_id = Customer.all.sample.id
    d_id = Drink.all.sample.id
    Order.create(customer_id: c_id, drink_id: d_id)
end