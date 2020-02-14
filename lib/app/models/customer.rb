class Customer < ActiveRecord::Base
    attr_accessor :todays_drinks
    has_many :orders
    has_many :drinks, through: :orders

#CLI
    def self.welcome
        puts "Welcome to Joe's Cafe"
        Customer.begin_visit
    end
#Customer
    def self.begin_visit
        prompt = TTY::Prompt.new
        name = prompt.ask("What's your name?")
        Customer.create(name: name)
        customer = Customer.find_by(name: name)
        customer.prompt_order
    end
#Order
    def prompt_order
        prompt = TTY::Prompt.new
        response = prompt.yes?("#{name}, would you like something to drink?")
        if response
            self.begin_creation
        else
            self.goodbye
        end
    end
#Drink
    def begin_creation
        prompt = TTY::Prompt.new 
        a = prompt.yes?("Do you know what you'd like?")
        if a 
            self.make_drink
        else
            Drink.list_the_options
            b = prompt.yes?("Can I get you anything?")
            if b 
                self.make_drink
            else
                self.goodbye
            end
        end
    end
#Drink
    def make_drink
        prompt = TTY::Prompt.new(symbols: {marker: '→'})
        selection = prompt.select("Choose your coffee:", Drink.coffees)
        drink = Drink.create(type_of_coffee: selection)
        if selection == "Espresso" || selection == "Drip Coffee"
            Drink.learn_about_coffee
        end
        if selection == "Latte" || selection == "Macchiato"
            milk = prompt.select("What type of milk would you like?", Drink.milks)
            drink.milk = milk
        else
            milk_response = prompt.yes?("Would you like milk?")
            if milk_response
                milk = prompt.select("What type of milk would you like?", Drink.milks)
                drink.milk = milk
            end
        end
        flavor_response = prompt.yes?("Would you like to add a flavor?")
        if flavor_response
            flavor = prompt.select("Which flavor?", Drink.flavors)
            drink.flavor = flavor
        end
        self.confirm_drink(drink)
    end
#Drink
    def confirm_drink(drink)
        prompt = TTY::Prompt.new
        if drink.milk == nil && drink.flavor == nil
            confirm = prompt.yes?("I have a #{drink.type_of_coffee}. Is that right?")
        elsif drink.milk == nil && drink.flavor
            confirm = prompt.yes?("I have a #{drink.flavor} #{drink.type_of_coffee}. Is that right?")
        elsif drink.flavor == nil && drink.milk
            confirm = prompt.yes?("I have a #{drink.type_of_coffee} with #{drink.milk}. Is that right?")
        else
            confirm = prompt.yes?("I have a #{drink.flavor} #{drink.type_of_coffee} with #{drink.milk}. Is that right?")
        end
        if confirm
            self.confirmed_order(drink)
        else
            self.change_drink(drink)
        end
    end
#Drink
    def change_drink(drink)
        prompt = TTY::Prompt.new
        response = prompt.yes?("Would you like to change any of your choices?")
        if response
            self.update_drink(drink)
        else
            self.confirmed_order(drink)
        end
    end
#Drink
    def update_drink(drink)
        prompt = TTY::Prompt.new
        edit = prompt.select("Sure, what would you like to change?") do |menu|
            menu.help 'Wow this person is really needy...'
            menu.choice 'Coffee', 0
            menu.choice 'Milk', 1
            menu.choice 'Flavor', 2
            menu.choice 'Everything', 3
            menu.choice 'Nevermind', echo: false
        end
        if edit == 0
            coffee = prompt.ask("What would you like?")
            drink.change_coffee(coffee)
        elsif edit == 1
            milk = prompt.ask("What would you like?")
            drink.change_milk(milk)
        elsif edit ==3
            Drink.destroy(drink.id)
            puts Rainbow("You're #{drink.type_of_coffee} was cancelled.").red
            self.make_drink
        elsif edit == 2
            flavor = prompt.ask("What would you like?")
            drink.change_flavor(flavor)
        end
            self.confirm_drink(drink)
    end
#Order
    def confirmed_order(drink)
        Order.create(customer_id: self.id, drink_id: drink.id)
        order = Order.find_by(drink_id: drink.id)
        puts Rainbow("Order ##{order.id} for #{order.customer.name} is ready! A #{drink.type_of_coffee}.").green
        self.goodbye
    end
#CLI
    def goodbye
        prompt = TTY::Prompt.new
        confirm = prompt.yes?("Can we get you anything else?")
        if confirm
            self.prompt_order
        else
            puts Rainbow("Thanks for coming, #{self.name}! Have a good day.").green
        end
    end
end