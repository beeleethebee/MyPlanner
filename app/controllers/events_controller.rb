class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]

  # GET /events or /events.json
  def index
    @events = Event.all.includes(:room, :user)
    # Jbuilder.encode do |json|
    #   json.array! @events do |event|
    #     json.extract! event, :id, :title, :room_id, :user_id, :color
    #     json.room do ||
    #   end
    # end
    @start_date = params[:start_date]&.to_date || Date.today
  end

  # GET /events/1 or /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
    if params[:start_date]
      @event.start_time = params[:start_date].to_datetime + DateTime.now.hour.hour
      @event.end_time = @event.start_time + 1.hour
    end
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    if params[:id].blank?
      @event = Event.new(**event_params, user: current_user)
    else
      @event = Event.find(params[:id])
      @event.assign_attributes(event_params)
    end


    respond_to do |format|
      if @event.save!
        format.html { redirect_to events_path, notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update

    respond_to do |format|
      if @event.update!(event_params)
        format.html { redirect_to events_path, notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.permit(:start_time, :end_time, :title, :room_id, :color)
    end
end
