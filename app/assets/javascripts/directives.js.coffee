sailingAppDirectives = angular.module('sailingAppDirectives', []);

sailingAppDirectives.directive('sailingMap', (constants) ->
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

sailingAppDirectives.directive('sailingData', (Course) ->
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
