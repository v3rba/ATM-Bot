require 'yaml'

class ATM
	attr_accessor :name

	def initialize ( name )
		@name = name
	end

	def login
		puts 'Please Enter Your Account Number:'
		account_number = gets.strip.to_i
		puts 'Enter Your Password:'
		account_password = gets.strip
		@config = YAML.load_file('config.yml')
		@found_account = @config['accounts'].select { |db_number| db_number == account_number }.to_h
		abort "ERROR: ACCOUNT NUMBER AND PASSWORD DON'T MATCH" if @found_account.empty?
		correct_password = true if @found_account.values[0]['password'] == account_password
		abort "ERROR: ACCOUNT NUMBER AND PASSWORD DON'T MATCH" unless correct_password
		puts "Hello, #{@found_account.values[0]['name']}\n" if correct_password
		menu
	end

	def menu
		puts "\nPlease Choose From the Following Options:\n1. Display Balance\n2. Withdraw\n3. Log Out\n"
		input = gets.chomp
		case input.to_i
		when 1
			balance_checking
		when 2
			withdraw_savings
		when 3
			exit_screen
		else
			puts "Error Invalid option please try again"
			menu
		end
	end

	def exit_screen
		puts "Returning card.."
		puts "#{@found_account.values[0]['name']}, Thank You For Using Our ATM. Good-Bye!"
		exit
	end

	private

	def withdraw_savings
		puts "Your current balance is ₴#{@found_account.values[0]['balance']}, Enter Amount You Wish to Withdraw: "
		input = gets.chomp.to_i
		if input > @found_account.values[0]['balance'].to_i
			puts "ERROR: INSUFFICIENT FUNDS!! PLEASE ENTER A DIFFERENT AMOUNT: "
			withdraw_savings
		else
			@found_account.values[0]['balance'] -= input
			File.open("config.yml", 'w') { |f| YAML.dump(@config, f) }
			puts "Your New Balance is ₴#{@found_account.values[0]['balance']}"
			menu
		end
	end

	def balance_checking 
		puts "Your balance is ₴#{@found_account.values[0]['balance']}"
		menu
	end
end


account = ATM.new('')
account.login



