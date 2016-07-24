class MainController < ApplicationController
  def index
    @indexWords = ['WHO', 'WHAT', 'WHEN', 'WHERE', 'WHY', 'HOW']
    @test = users
  end
end
