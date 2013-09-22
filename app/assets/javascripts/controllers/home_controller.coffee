'use strict'

app = angular.module 'papertrailApp'

app.controller "HomeController", ($scope, Restangular) ->
	$scope.retrieve_documents = ->
    $scope.documents = Restangular.all('documents').getList()

	$scope.create_document = ->
    Restangular.all('documents').post({});
    $scope.retrieve_documents()

  $scope.remove_document = (document) ->
    Restangular.one('documents',document.id).remove()
    $scope.retrieve_documents() 

  Restangular.setRequestSuffix(".json")
	$scope.retrieve_documents()

