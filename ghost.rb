require "byebug"
require "set"
require "./players.rb"

class Game

  def initialize(*players)
    dict_words = File.readlines("./dictionary.txt").map(&:chomp)
    @players = players
    @starting_dictionary = Set.new(dict_words)
    @options_dictionary = Set.new(dict_words)
    @fragment = ""
  end

  def play
    keep_playing until game_over?
    output_round_winner
  end

  private

  attr_reader :dictionary

  def keep_playing
    show_fragment
    entire_move
    rotate_players
  end

  def entire_move
    begin
      move = @players.first.get_move(@fragment, @options_dictionary)
      if valid_move?(move)
        update_fragment(move)
        update_options_dictionary
      else
        raise ArgumentError
      end
    rescue ArgumentError
      puts "Oops, that seems to be an invalid move. Try another letter."
      puts ""
      retry
    end
  end

  def rotate_players
    @players.rotate!
  end

  def valid_move?(str)
    moves = @options_dictionary.select { |val| val.start_with?(@fragment + str) }
    moves.count > 0
  end

  def update_fragment(move)
    @fragment += move
  end

  def update_options_dictionary
    @options_dictionary = @options_dictionary.select { |word| word.start_with?(@fragment) }
  end

  def game_over?
    @options_dictionary.include?(@fragment)
  end

  def show_fragment
    if @fragment != ""
      puts ""
      puts "The current fragment is: #{@fragment}."
      puts ""
    end
  end

  def output_round_winner
    puts ""
    puts "Congrats #{@players.first.name}, you won the game!"
  end


end

if $PROGRAM_NAME == __FILE__
  puts "What's your name?"
  print "> "
  name = gets.chomp
  puts ""
  game = Game.new(Player.new(name), Computer.new)
  game.play
end
