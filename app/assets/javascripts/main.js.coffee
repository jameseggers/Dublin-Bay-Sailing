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

sailingApp.controller('MainSailingController', ($scope, Course, constants, $interval) ->

  $scope.updateBoatLocation = ->
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition( (position) ->
          currentPosition = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)

          $scope.boat_marker.setPosition(currentPosition)

          if $scope.paths[$scope.nextMarkerIndex]
            distanceToNextMark = getDistanceFromLatLonInKm(
              currentPosition.lat(),
              currentPosition.lng(),
              $scope.markers[$scope.nextMarkerIndex].getPosition().lat(),
              $scope.markers[$scope.nextMarkerIndex].getPosition().lng()
            )

            if distanceToNextMark < 0.1
              $scope.paths[$scope.nextMarkerIndex-1].setOptions(
                strokeColor: "#000000"
              )

              $scope.paths[$scope.nextMarkerIndex].setOptions(
                strokeColor: "#FFFFFF"
              )

              $scope.nextMarkerIndex += 1
      )

  $scope.addBoat = ->
    $scope.boat_marker = new google.maps.Marker(
      position: constants.dun_laoghaire
      map: $scope.map
      title: "Your Boat"
    )

    $interval($scope.updateBoatLocation, 3000)

  $scope.addMarksAndLine = ->
    $scope.clearMap()

    marks = $scope.listings[$scope.selectedCourse][0].buoy_listing.split(' ')

    line_symbol =
      path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW

    for mark, i in marks
      split = mark.split('')
      buoy_symbol = split[0]
      rounding_direction = split[1]
      buoy = $scope.buoys[buoy_symbol]

      latlng = new google.maps.LatLng(buoy.latitude, buoy.longitude*-1);

      icon =
        scaledSize: new google.maps.Size(30, 30)
        url: '/assets/buoy-e7aa992abe5b63febf15632545f69b3c.png'

      marker = new google.maps.Marker(
        position: latlng
        map: $scope.map
        title: buoy.name
        icon: icon
      )

      $scope.markers.push marker

      next_buoy = $scope.buoys[marks[i+1].split('')[0]]
      next_latlng = new google.maps.LatLng(next_buoy.latitude, next_buoy.longitude*-1);

      if i is 0 then color = "#FFFFFF" else color = "#000000"

      path = new google.maps.Polyline(
        path: [latlng, next_latlng]
        geodisc: true
        strokeColor: color
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

      # set next mark index
      $scope.nextMarkerIndex = 1

  $scope.clearMap = ->
    for marker, i in $scope.markers
      marker.setMap(null)

    for path in $scope.paths
      path.setMap(null)

    $scope.markers = []

  getDistanceFromLatLonInKm = (lat1, lon1, lat2, lon2) ->
    R = 6371
    # Radius of the earth in km
    dLat = deg2rad(lat2 - lat1)
    # deg2rad below
    dLon = deg2rad(lon2 - lon1)
    a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * Math.sin(dLon / 2) * Math.sin(dLon / 2)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    d = R * c
    # Distance in km
    d

  deg2rad = (deg) ->
    deg * Math.PI / 180

)
