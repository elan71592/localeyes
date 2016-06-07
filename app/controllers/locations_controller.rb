class LocationsController < ApplicationController
  def index
    @trip = Trip.find_by( id: params[ :trip_id ] )
    @locations = @trip.locations
  end

  def new
    @trip = Trip.find_by( id: params[ :trip_id ] )

    if !user_signed_in?
      redirect_to root_path
    end
  end

  def create
    @location = Location.create( location_params )
    @trip = Trip.find_by( id: params[ :trip_id ])
    @trip.locations.push( @location )

    if request.xhr?
      render '_location_card', layout: false, locals: { location: @location, trip: @trip }
    end
  end

  def update
    @location = Location.find_by( id: params[ :id ] )
    @location.update_attributes( update_params )
    @trip = Trip.find_by( id: params[ :trip_id ] )

    if request.xhr?
      render '_location_card_success', layout: false, locals: { location: @location, trip: @trip }
    end
  end

  def destroy
    @location = Location.find_by(id: params[:id])
    @location.destroy

    if request.xhr?
      render '_destroy', layout: false
    end
  end

  private

    def location_params
      params.require( :place ).permit( :name, :address, :phone_number, :website_url, :latitude, :longitude )
    end

    def update_params
      params.require( :location ).permit( :personal_note, :duration )
    end
end
