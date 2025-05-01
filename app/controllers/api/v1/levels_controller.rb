module Api
  module V1
    class LevelsController < ApplicationController
      def index
        levels = Level.where(member_id: member_id).from_date_range(start_date, end_date)
        render json: levels
      end

      private

      def member_id
        params.expect(:member_id)
      end

      def start_date
        DateTime.parse(params.expect(:start_date)).beginning_of_day
      end

      def end_date
        DateTime.parse(params.expect(:end_date)).end_of_day
      end
    end
  end
end
