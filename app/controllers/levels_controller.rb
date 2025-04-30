class LevelsController < ApplicationController
  before_action :set_level, only: %i[ show destroy ]

  # GET /levels or /levels.json
  def index
    @levels = Level.all
  end

  # GET /levels/1 or /levels/1.json
  def show
  end

  # GET /levels/new
  def new
    @level = Level.new
  end

  # POST /levels or /levels.json
  def create
    @level = Level.new(level_params)

    respond_to do |format|
      if @level.save
        format.html { redirect_to @level, notice: "Level was successfully created." }
        format.json { render :show, status: :created, location: @level }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @level.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /levels/1 or /levels/1.json
  def destroy
    @level.destroy!

    respond_to do |format|
      format.html { redirect_to levels_path, status: :see_other, notice: "Level was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_level
      @level = Level.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def level_params
      params.expect(level: [ :member_id, :level_type, :value, :unit, :tested_at, :tz_offset ])
            .with_defaults({ level_type: "continuous_glucose_monitoring", unit: "mg/dL" })
    end
end
