sailingApp = angular.module('sailingApp', ["ngResource"]);

sailingApp.factory('Course', ['$resource', ($resource) ->
  return $resource('courses.json', {}, {})
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
    scope.markers = []
    scope.buoys = JSON.parse(localStorage.getItem('buoys'))
    scope.courses = JSON.parse(localStorage.getItem('courses'))
    scope.listings = JSON.parse(localStorage.getItem('listings'))

    Course.get({}, (resp) ->
      buoys = {}
      for buoy in resp.buoys
        buoys[buoy.symbol] = buoy

      localStorage.setItem('buoys', JSON.stringify(buoys))
      localStorage.setItem('courses', JSON.stringify(resp.courses))
      localStorage.setItem('listings', JSON.stringify(resp.listings))
      scope.buoys = buoys
      scope.courses = resp.courses
      scope.listings = resp.listings
      console.log scope.courses
    )
)

sailingApp.controller('MainSailingController', ($scope, Course) ->
  $scope.addMarkers = ->
    $scope.clearMarkers()

    for mark in $scope.listings[$scope.selectedCourse][0].buoy_listing.split(' ')
      split = mark.split('')
      buoy_symbol = split[0]
      rounding_direction = split[1]
      buoy = $scope.buoys[buoy_symbol]

      latlng = new google.maps.LatLng(buoy.latitude, buoy.longitude*-1);
      marker = new google.maps.Marker(
        position: latlng,
        map: $scope.map,
        title: buoy.name
      )
      $scope.markers.push marker

  $scope.clearMarkers = ->
    for marker in $scope.markers
      marker.setMap(null)
    $scope.markers = []
)
