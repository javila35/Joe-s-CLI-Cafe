require_relative '../config/environment.rb'

dinasours = ["Aidan","Chris","Clarion","David","Diana","Jazz","Johnny","Joe","Kailana","Kevin","Lief","Matt","Kim","Soundarya","Zeb","Gabriel","Hal","Jack"]

dinasours.each do |person|
    value = rand(2) == 1 ? true :false
    Customer.create(name: person, patient?: value)
end