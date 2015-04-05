sailingApp = angular.module('sailingApp', ["sailingAppFactories", "ui.bootstrap", "sailingAppDirectives", "sailingAppControllers", "ngRoute"])

sailingApp.config( ($routeProvider, $locationProvider) ->
  $routeProvider.when('/',
    templateUrl: 'templates/menu.html'
    controller: 'MenuController'
  ).when('/map',
    templateUrl: 'templates/map.html'
    controller: 'MainSailingController'
  )
)
