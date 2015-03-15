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
        disableDefaultUI: true
        draggable: false
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
      scope.paths = []
    )
)

sailingApp.controller('MainSailingController', ($scope, Course) ->
  $scope.addMarkers = ->
    $scope.clearMap()
    colours = ['#009900', '#2E7D00', '#5D6100', '#8B4600', '#B92A00', '#D11C00', '#E80E00', '#FF0000']

    marks = $scope.listings[$scope.selectedCourse][0].buoy_listing.split(' ')

    for mark, i in marks
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

      next_buoy = $scope.buoys[marks[i+1].split('')[0]]
      next_latlng = new google.maps.LatLng(next_buoy.latitude, next_buoy.longitude*-1);

      path = new google.maps.Polyline(
        path: [latlng, next_latlng]
        geodisc: true
        strokeColor: colours[i]
        strokeOpacity: 1.0
        strokeWeight: 2
      )

      $scope.paths.push path
      path.setMap($scope.map)

  $scope.clearMap = ->
    for marker, i in $scope.markers
      marker.setMap(null)

    for path in $scope.paths
      path.setMap(null)

    $scope.markers = []
)
