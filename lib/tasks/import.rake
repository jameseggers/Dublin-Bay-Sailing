namespace :import do

  desc "Import data from the csv files"

  task import_buoys: :environment do
    buoy_file = File.open('csv/buoys.csv')

    buoy_file.each_line do |line|
      data = line.split(',')
      Buoy.create({latitude: data[0], longitude: data[1], name: data[2], symbol: data[3].strip!})
    end
  end
end
