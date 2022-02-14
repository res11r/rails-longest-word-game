require 'open-uri'

class GamesController < ApplicationController
  def new
    alphabet = 'acdefghijklmnopqrstuvwxyz'.chars
    @random_letters = []
    9.times do
      @random_letters << alphabet.sample
    end
  end

  def score
    @attempt = params[:attempt]
    @random_letters = params[:random_letters]
    file = URI.open("https://wagon-dictionary.herokuapp.com/#{@attempt}").read
    @file_parsed = JSON.parse(file)
    if @file_parsed["found"] == true
      @result = compare_with_grid(@attempt, @random_letters)
    else
      @result = "#{@attempt} is not a word"
    end
  end

  def compare_with_grid(attempt, random_letters)
    attempt.chars.each do |letter|
      if random_letters.include?(letter)
        random_letters.chars.delete_at(random_letters.chars.find_index(letter))
      else
        return "The word '#{attempt}' cannot be formed from the letters #{random_letters}"
      end
    end
    'you win'
  end
end
