require_relative '../config/environment.rb'
require 'pry'

# Seed data for Customers.
dinasours = ["Aidan","Chris","Clarion","David","Diana","Jazz","Johnny","Joe","Kailana","Kevin","Lief","Matt","Kim","Soundarya","Zeb","Gabriel","Hal","Jack"]

dinasours.each do |person|
    value = rand(2) == 1 ? true :false
    Customer.create(name: person, patient?: value)
end

10.times do
    Drink.create(milk: Drink.milks.sample, type_of_coffee: Drink.coffees.sample, flavor: Drink.flavors.sample)
end