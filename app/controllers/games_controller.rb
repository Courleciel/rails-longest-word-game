require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = []
    voyels = ["A", "E", "I", "O", "U"].sample(4)
    consonants = ["P", "B", "T", "D", "K", "G", "M","N", "L", "R", "F", "V", "S", "Z", "H", "W"].sample(6)
    @letters = @letters.push(voyels).push(consonants).flatten.shuffle
  end

  def score
    @letters = params[:letters].gsub(' ', '')

    if params[:answer].chars.map { |letter| @letters.include?(letter) }.all?(true)
      url = "https://wagon-dictionary.herokuapp.com/#{params[:answer]}"
      url_serialized = URI.open(url).read
      words = JSON.parse(url_serialized)

      if words['found'] == false
        @answer = "Sorry but #{params[:answer]} does not seem to be a valid English Word..."
        @score = 0
      elsif words['found'] == true
        @answer = "Congratulations! #{params[:answer]} is a valid English word"
        @score = params[:answer].size
      end

    else
      @answer = "Sorry but #{params[:answer]} can't be built out of #{params[:letters].gsub(' ', ', ')}"
    end
    session[:score].nil? ? session[:score] = @score : session[:score] += @score
    @session_score = session[:score]
  end
end
