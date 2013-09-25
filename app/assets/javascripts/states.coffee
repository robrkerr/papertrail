app = angular.module 'papertrailApp'

app.config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise '/'

  $stateProvider
    .state 'home',
      url: '/'
      templateUrl: 'views/home.html'
      controller: 'HomeController'
    .state 'document',
      url: '/:document_id'
      templateUrl: 'views/document.html'
      controller: 'DocumentController'
    .state 'points',
      url: '/:document_id/points'
      templateUrl: 'views/points.html'
      controller: 'PointsController'

    
