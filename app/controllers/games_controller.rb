require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @letters = params[:letters].split
    @word = params[:word].upcase
    @message = "Congrats! #{@word} is a valid english word."
    unless grid_include?(@letters, @word)
      @message = "Sorry but #{@word} cant be buil out of #{params[:letters]}."
      return
    end

    @message = "Sorry but #{@word} is not an english word." unless word_exists?(@word)
  end

  private

  def grid_include?(letters, word)
    word.each_char do |letter|
      if letters.include?(letter.upcase)
        letters.delete_at(letters.index(letter.upcase))
      else
        return false
      end
    end
    true
  end

  def word_exists?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    user_serialized = open(url).read
    attempt_details = JSON.parse(user_serialized)
    attempt_details['found']
  end
end
