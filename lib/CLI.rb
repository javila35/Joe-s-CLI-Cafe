class CommandLineInterface
    
    #method called when user runs 'rake run'
    def self.welcome
        puts "Welcome to Joe's Cafe"
        CommandLineInterface.begin_visit
    end

    def self.begin_visit
        prompt = TTY::Prompt.new
        customer = Customer.new
        name = prompt.ask("What's your name?")
        customer.name = name 
        customer.save
        Order.prompt_order(customer)
    end

    def self.goodbye(customer)
        prompt = TTY::Prompt.new
        confirm = prompt.yes?("Can we get you anything else?")
        if confirm
            Order.prompt_order(customer)
        else
            puts Rainbow("Thanks for coming, #{customer.name}! Have a good day.").green
        end
    end
end