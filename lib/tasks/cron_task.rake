namespace :cron_task do
  desc "getting crime data from gdelt"
  task :gdelt => :environment do
  PlaceDatum.all.each do |gdelt|
  gdelt.crime_weight=0
  require 'big_query'
  opts = {}
  opts['client_id']     = '892836517851-sf9d9n3imr9g0fjfimeai586tus0he89.apps.googleusercontent.com'
  opts['service_email'] = '892836517851-sf9d9n3imr9g0fjfimeai586tus0he89@developer.gserviceaccount.com'
  opts['key']           = '/home/satyaki/gdelt-343ecbcf84cc.p12'
  opts['project_id']    = 'alert-result-110206'
  opts['dataset']       = 'gdelt-bq:gdeltv2.gkg'
  bq = BigQuery::Client.new(opts)
  limit=3
  q1=bq.query("SELECT Counts FROM [gdelt-bq:gdeltv2.gkg] WHERE  Counts CONTAINS '#{gdelt.place_name}' AND date < #{DateTime.now.strftime("%Y%m%d%H%M%S")}  AND date > #{(DateTime.now-7.days).strftime("%Y%m%d%H%M%S")} order by date desc limit 10")
  crime=String.new
  c_place=String.new
  place_name=String.new

  x=0
  if q1["rows"]
  while q1["rows"][x] do
  place=q1["rows"][x]["f"][0]["v"]
  x+=1
  #extracts entity
  def extract (place,i)
  res=' '
  j=0
  while (place[i]!=';' && place[i]!='#' && place[i]) do
  res[j]=place[i]
  i+=1
  j+=1
  end
  return res
  end
  #extract places
  i=0
  while place[i] do
  counter=0
  while (place[i-1]!=';' && place[i]) do
  if counter != 0
  while (place[i]!='#' && place[i]!=';' && place[i]) do
  i+=1
  end
  end
  counter+=1
  if counter==1
  crime=extract place,i-1
  elsif counter==4
  c_place=extract place,i+1
  elsif counter==5
  place_name=extract place,i+1
  elsif counter==8
  lat=extract place,i+1
  elsif counter==9
  lon=extract place,i+1
  end
  if ((place_name.include? gdelt.place_name) && (crime=="AFFECT" || crime=="KILL" || crime=="ARREST" || crime=="KIDNAP" || crime=="WOUND" || 
  crime=="SEIZE" || crime=="SOC_GENERALCRIME" || crime=="TERROR" || crime=="TORTURE" || crime=="SOC_TRAFFICACCIDENT"))
  gdelt.crime_weight +=c_place.to_i
  gdelt.save
  place_name=""
  end

  i+=1
  end

  i+=1
  end
  end  
  end   
  end
  end
  desc "getting entertainment data from google near by API"
  task :get_entertainment_data => :environment do
  client = GooglePlaces::Client.new("AIzaSyDdkxBvfYcMr8tOz6-BUmZUHni3X5z4Zu8")
  PlaceDatum.all.each do |pd|
  unless  pd.lat.blank? || pd.long.blank?
  initial_hash = {:bar => 0,:amusement_park =>0,:shopping_mall => 0,:zoo => 0}
  final_hash = initial_hash.inject({}) { |mod_hash, (k, v)| mod_hash[k] = client.spots(pd.lat,pd.long,:types =>k,:radius => 500).count; mod_hash }
  weight_factor = 1
  pd.update(entertainment_weight: weight_factor * final_hash.map { |k,v| v }.sum)
  end
  end
  end
  
  desc "getting Data from google places API"
  task :get_health_data => :environment do
   @client = GooglePlaces::Client.new("AIzaSyCpt-oYsPxrYyCk_8pJ4QFWw2JUkpYvjRw")
   PlaceDatum.all.each do |p|
   # hospital_points = 5
   # gym_points = 3 
   # dentist_points = 2
   # physiotherapist_points = 1
   hospital_count = @client.spots(p.lat,p.long, :radius => 500,:types=>'hospital').count
   gym_count = @client.spots(p.lat,p.long, :radius => 500,:types=>'gym').count
   dentist_count = @client.spots(p.lat,p.long, :radius => 500,:types=>'dentist').count
   physiotherapist_count = @client.spots(p.lat,p.long, :radius => 500,:types=>'physiotherapist').count
   weightage = (hospital_count+gym_count+dentist_count+physiotherapist_count)
   p.update(:health_weight=>weightage)
   end
  end
end 