#coding: utf-8
class PlacesController < ApplicationController
  before_filter :find_place, only: [:show, :more]

  def show
    if params[:reserve_date].present? and params[:reserve_date].length > 1
      @date = params[:reserve_date]
    else
      @date = Date.today.strftime('%d/%m/%Y')
    end
    if params[:reserve_time].present? and params[:reserve_time].length > 1
      time = Time.parse(params[:reserve_time])
    else
      time = Time.now
    end
    minutes = %w(00 30)[time.min / 30]
    @time = {:h => time.hour.to_s, :m => minutes}
    @location = @place.lat_lng
    @special_offers =  @place.day_discounts.special
  end

  def index
  end

  def set_location
    session[:city] = params[:location_slug]
    if (city = City.find_by_slug(session[:city])) && current_user
      current_user.update_attribute(:city, city)
    end
    redirect_to  :back
  end

  def more
    reviews = @place.reviews.paginate(:page => params[:page])
    render :json => reviews.map(&:for_mustache)
  end

  private

  def find_place
    @place = Place.find params[:id]
  end


end
