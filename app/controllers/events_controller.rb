class EventsController < ApplicationController
  def index
    @events = Event.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  def show
  	@event = Events.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end
end
