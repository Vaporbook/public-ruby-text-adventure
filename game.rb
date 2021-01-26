require 'nokogiri'
require 'pry'
require_relative './lib/core'

selected_game = render_loadmenu

load_game(selected_game)
