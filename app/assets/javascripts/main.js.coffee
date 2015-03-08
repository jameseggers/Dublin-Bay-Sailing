sailingApp = angular.module('sailingApp', ["ngResource"]);

sailingApp.factory('Course', ['$resource', ($resource) ->
  return $resource('courses.json', {}, {})
])

sailingApp.directive('sailingMap', ->
  link: (scope) ->
    dun_laoghaire = new google.maps.LatLng(53.32249966680044, -6.13918810268558);
    mapOptions =
        center: dun_laoghaire
        zoom: 13
    scope.map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions)
    scope.markers = []
)

sailingApp.directive('sailingData', (Course) ->
  link: (scope) ->
    scope.markers = []

    Course.get({}, (resp) ->
      buoys = {}
      for buoy in resp.buoys
        buoys[buoy.symbol] = buoy

      scope.buoys = buoys
      scope.courses = resp.courses
      scope.listings = resp.listings
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
