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
          lat: -30.0
          lng: 150.0
        zoom: 8
    scope.map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions)
    scope.markers = []
)

sailingApp.controller('MainSailingController', ($scope, Course) ->
  $scope.add_course_marks = ->
    Course.get(
      course_id: 3
    ,
      (resp) ->
        console.log(resp)
    )
    myLatlng = new google.maps.LatLng(-30.0,150.0);
    marker = new google.maps.Marker(
      position: myLatlng,
      map: $scope.map,
      title: "lol"
    )
)
