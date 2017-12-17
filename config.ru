require 'dotenv/load'
require './app'
Tariff.load
run Sinatra::Application
