class PlacesDataController < ApplicationController
  def get_place_data
    category = params[:category]
    case category
    when "dangerzone"
    place_data =  PlaceDatum.group("crime_weight").order("crime_weight desc")
    places = place_data.limit(5).each_with_index.map{|p,i|{:name => p.place_name,:lat => p.lat,:lng => p.long,:weight => p.crime_weight ,:rank => i+1}}
    render :json => {:success => true,:data => places}
    when "healthzone"
    place_data =  PlaceDatum.group("health_weight").order("health_weight desc").all
    places = place_data.limit(5).each_with_index.map{|p,i|{:name => p.place_name,:lat => p.lat,:lng => p.long,:weight => p.health_weight, :rank => i+1}}
    render :json => {:success => true,:data => places}
    when "entertainmentzone"
    place_data =  PlaceDatum.group("entertainment_weight").order("entertainment_weight desc").all
    places = place_data.limit(5).each_with_index.map{|p,i|{:name => p.place_name,:lat => p.lat,:lng => p.long,:weight => p.entertainment_weight,:rank => i+1}}
    render :json => {:success => true,:data => places}
    else
    render :json => {:success => false,:data => "No data found"}
    end
  end
end
