class MemberLevelsController < ApplicationController
  before_action :set_member, only: %i[index table_data]
  before_action :set_level_type, only: %i[index table_data]

  # GET members/1/levels/:level_type or members/:id/levels/:level_type.json
  def index
  end

  # GET members/1/levels/:level_type/table_data
  def table_data
    @dashboard = MemberDashboard.new(member: @member, level_type: @level_type)
    @dashboard_data = @dashboard.data(date_scope: params[:date_scope])
    turbo_stream
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.find(params.expect(:member_id))
    end

    def set_level_type
      @level_type = params.expect(:level_type)
    end
end
