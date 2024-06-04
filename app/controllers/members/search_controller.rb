# frozen_string_literal: true

module Members
  class SearchController < ApplicationController
    before_action :set_member

    def index
      return if params[:search].blank?

      @headlines = Headline.includes(:member).search_by_content(params[:search])
                           .where.not(member_id: @member.id)
      @shortest_connections = {}
      @headlines.each do |headline|
        next if @shortest_connections[headline.member_id].present?

        @shortest_connections[headline.member_id] =
          @member.shortest_connection_to(headline.member).map(&:name).join(' -> ')
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.find(params[:member_id])
    end
  end
end
