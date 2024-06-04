# frozen_string_literal: true

class SearchController < ApplicationController
  def index
    return if params[:search].blank?

    @headlines = Headline.includes(:member).search_by_content(params[:search]).limit(50)
  end
end
