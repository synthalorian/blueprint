class PagesController < ApplicationController
  def home
    @featured = Blueprint.publicly.recent.limit(6)
    @count = Blueprint.publicly.count
  end

  def about
  end
end
