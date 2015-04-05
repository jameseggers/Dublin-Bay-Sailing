sailingAppFactories = angular.module('sailingAppFactories', ['ngResource']);

sailingAppFactories.factory('Course', ['$resource', ($resource) ->
  return $resource('courses.json', {}, {})
])

sailingAppFactories.factory('constants', [() ->
    constants =
      dun_laoghaire: new google.maps.LatLng(53.32249966680044, -6.13918810268558)
])
