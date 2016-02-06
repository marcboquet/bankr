require 'bundler'
Bundler.setup
require 'pry'
require 'bankr'
require 'pp'
require 'yaml'

puts 'LaCaixa Scraper Live Test'
if !ENV['LOGIN'] || !ENV['PASSWORD']
  puts "ENV['LOGIN'] or ENV['PASSWORD'] not supplied."
else
  scraper = Bankr::Client.new('la_caixa', login: ENV['LOGIN'], password: ENV['PASSWORD'])
  account_number = ENV['ACCOUNT_NUMBER']

  if !account_number
    accounts = scraper.list_accounts
    puts "ENV['ACCOUNT_NUMBER'] not supplied. Found these accounts:"
    puts accounts
  else
    puts 'Fetching movements for the last week...'
    movements = scraper.movements_until(account_number, 1.week.ago)

    puts "Fetched #{movements.size} movements."
    puts movements.inspect
    puts movements.reject(&:nil?).map(&:to_hash)
  end
end
