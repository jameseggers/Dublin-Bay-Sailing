namespace :import do

  desc "Import data from the csv files"

  task import_buoys: :environment do
    buoy_file = File.open('csv/buoys.csv')

    buoy_file.each_line do |line|
      data = line.split(',')
      Buoy.create({latitude: data[0], longitude: data[1], name: data[2], symbol: data[3].strip!})
    end
  end

  task import_listings: :environment do
    listings_file = File.open('csv/listings.csv')
    course_id = -1

    listings_file.each_line do |line|
      if line.start_with? "#"
        course_id += 1
      else
        data = line.split(',')
        Listing.create({buoy_listing: data[1].strip!, course_id: course_id})
      end
    end
  end
end
