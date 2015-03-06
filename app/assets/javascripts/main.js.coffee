sailingApp = angular.module('sailingApp', ["ngResource"]);

sailingApp.factory('Course', ['$resource', ($resource) ->
  return $resource('courses/:course_id.json', {},
    query:
      method: 'GET',
      params:
        course_id: '@'
  )
])

sailingApp.directive('sailingMap', ->
  link: (scope) ->
    mapOptions =
        center:
          lat: 53.32249966680044
          lng: -6.13918810268558
        zoom: 13
    scope.map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions)
    scope.markers = []
)

sailingApp.directive('sailingData', (Course) ->
  link: (scope) ->
    scope.buoys = JSON.parse(localStorage.getItem('buoys'))
    scope.course = JSON.parse(localStorage.getItem('course'))
    scope.listings = JSON.parse(localStorage.getItem('listings'))

    Course.get(
      course_id: 3
    ,
      (resp) ->
        buoys = {}
        for buoy in resp.buoys
          buoys[buoy.symbol] = buoy

        localStorage.setItem('buoys', JSON.stringify(buoys))
        localStorage.setItem('course', JSON.stringify(resp.course))
        localStorage.setItem('listings', JSON.stringify(resp.listings))
        scope.buoys = buoys
        scope.course = resp.course
        scope.listings = resp.listings
    )
)

sailingApp.controller('MainSailingController', ($scope, Course) ->
  $scope.add_course_marks = ->
    for mark in $scope.listings[0].buoy_listing.split(' ')
      split = mark.split('')
      buoy_symbol = split[0]
      rounding_direction = split[1]
      buoy = $scope.buoys[buoy_symbol]

      latlng = new google.maps.LatLng(buoy.latitude, buoy.longitude*-1);
      marker = new google.maps.Marker(
        position: latlng,
        map: $scope.map,
        title: "lol"
      )
)
