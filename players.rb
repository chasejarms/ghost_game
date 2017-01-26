require "byebug"

class Player
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def get_move(_, _)
    puts "#{@name}, enter your letter:"
    print "> "
    gets.chomp
  end
end

class Computer < Player

  def initialize
    @name = "J0RY"
  end

  def get_move(fragment, current_dictionary)
    good_options = find_options(fragment, current_dictionary)
    p "The good options are: #{good_options}"
    good_options.min_by {|_, letter| letter }[0]
    # comment the next line in after you're finished with testing
    # good_options.to_a.sample[0]
  end

  private

  def find_options(current_fragment, current_dictionary)
    eliminated_words = current_dictionary.reject { |word| word.length == current_fragment.length + 1}
    if eliminated_words.empty?
      current_dictionary.each {|word| return {word[-1]=> 1 } }
    else
      optional_letters(eliminated_words, current_fragment)
    end
  end

  def optional_letters(eliminated_words, current_fragment)
    optional_letters = Hash.new(0)
    eliminated_words.each do |word|
      next_char = word[current_fragment.length]
      optional_letters[next_char] += 1
    end
    optional_letters
  end

end
