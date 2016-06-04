class TripsController < ApplicationController

def index
  @trips = Trip.all
  @sorted_trips = sort_by_favorites(@trips)
end

def new
  @trip = Trip.new
end

def create
  @trip = Trip.new(trip_params)
  tags = params[:trip][:tags].split(", ")
  if @trip.save
    tags.each do |tag|
      new_tag = Tag.find_or_create_by(name: tag)
      @trip.tags << new_tag
    end
    if @trip.tags.length < 1
      @errors = ["Trip must have at least one tag.", "Please add one tag to continue."]
      render 'new'
    else
      redirect_to new_trip_location_path(@trip)
    end
  else
    @errors = ["Trip name cannot be blank.", "Please add a name to continue."]
    render 'new'
  end
  # respond_to do |format|
  #     if @trip.save
  #       format.html { redirect_to @trip, notice: 'Trip was successfully created.' }
  #       format.json { render :show, status: :created, location: @trip }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @trip.errors, status: :unprocessable_entity }
  #     end
  #   end
end

def show
  @trip = Trip.find_by(id: params[:id])
end

private
  def trip_params
    params.require(:trip).permit( :name )
  end
end
