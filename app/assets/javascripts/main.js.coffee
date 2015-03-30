sailingApp = angular.module('sailingApp', ["ngResource", "ui.bootstrap"]);

sailingApp.factory('Course', ['$resource', ($resource) ->
  return $resource('courses.json', {}, {})
])

sailingApp.factory('constants', [() ->
    constants =
      dun_laoghaire: new google.maps.LatLng(53.32249966680044, -6.13918810268558)
])

sailingApp.directive('sailingMap', (constants) ->
  link: (scope) ->
    mapOptions =
        center: constants.dun_laoghaire
        zoom: 13
        disableDefaultUI: true
        scrollwheel: true
        navigationControl: false
        mapTypeControl: false
        scaleControl: false
        draggable: false
        zoomControl: true
    scope.map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions)
    scope.markers = []
    scope.addBoat()
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

sailingApp.controller('MainSailingController', ($scope, Course, constants, $timeout) ->

  $scope.updateBoatLocation = ->
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition( (position) ->
          $scope.boat_marker.setPosition(new google.maps.LatLng(position.coords.latitude, position.coords.longitude))
      )

  $scope.addBoat = ->
    $scope.boat_marker = new google.maps.Marker(
      position: constants.dun_laoghaire
      map: $scope.map
      title: "Your Boat"
    )

    $timeout (->
      $scope.updateBoatLocation()
    ), 5000

  $scope.addMarksAndLine = ->
    $scope.clearMap()
    colours = ['#009900', '#2E7D00', '#5D6100', '#8B4600', '#B92A00', '#D11C00', '#E80E00', '#FF0000']

    marks = $scope.listings[$scope.selectedCourse][0].buoy_listing.split(' ')

    line_symbol =
      path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW

    for mark, i in marks
      split = mark.split('')
      buoy_symbol = split[0]
      rounding_direction = split[1]
      buoy = $scope.buoys[buoy_symbol]

      latlng = new google.maps.LatLng(buoy.latitude, buoy.longitude*-1);

      marker = new google.maps.Marker(
        position: latlng
        map: $scope.map
        title: buoy.name
        icon: '/assets/buoy-e7aa992abe5b63febf15632545f69b3c.png'
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
        icons: [
          icon: line_symbol
          offset: '100%'
        ]
        map: $scope.map
      )

      $scope.paths.push path
      path.setMap($scope.map)

  $scope.clearMap = ->
    for marker, i in $scope.markers
      marker.setMap(null)

    for path in $scope.paths
      path.setMap(null)

    $scope.markers = []

  $scope.getDistanceFromMarker = (lat1, long1, lat2, long2) ->
    R = 6371000
    # metres
    φ1 = lat1.toRadians()
    φ2 = lat2.toRadians()
    Δφ = (lat2 - lat1).toRadians()
    Δλ = (lon2 - lon1).toRadians()
    a = Math.sin(Δφ / 2) * Math.sin(Δφ / 2) + Math.cos(φ1) * Math.cos(φ2) * Math.sin(Δλ / 2) * Math.sin(Δλ / 2)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    R * c
)
