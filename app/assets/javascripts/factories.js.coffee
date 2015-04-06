sailingAppFactories = angular.module('sailingAppFactories', ['ngResource']);

sailingAppFactories.factory('Course', ['$resource', ($resource) ->
  return $resource('courses.json', {}, {})
])

sailingAppFactories.factory('constants', [() ->
    constants =
      dun_laoghaire: new google.maps.LatLng(53.32249966680044, -6.13918810268558)
      starts: [
        id: 0
        name: "Hut Start"
      ,
        id: 1
        name: "Committee Boat Start"
      ]
])

sailingAppFactories.factory('prefs', [()->
  prefs =
    selected_course: 0
    selected_start: 0
    selected_listing: 0
])
