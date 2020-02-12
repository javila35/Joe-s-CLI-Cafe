require_relative '../config/environment.rb'
require 'pry'

# Seed data for Customers.
dinasours = ["Aidan","Chris","Clarion","David","Diana","Jazz","Johnny","Joe","Kailana","Kevin","Lief","Matt","Kim","Soundarya","Zeb","Gabriel","Hal","Jack"]

dinasours.each do |person|
    value = rand(2) == 1 ? true :false
    Customer.create(name: person, patient?: value)
end
 
# Seed data for Coffee.
milk = ["Soy Milk", "Almond Milk", "Oat Milk", "Whole Milk", "2% Milk", "Nonfat", "Half & Half"]
coffee = ["Espresso", "Drip Coffee", "Latte", "Macchiato", "Tea", "Cold Brew", "Chai"]
flavors = ["Vanilla", "Chocolate", "Cinnamon", "Lavender"]

10.times do
    Drink.create(milk: milk.sample, type_of_coffee: coffee.sample, flavor: flavors.sample)
end

# binding.pry
0