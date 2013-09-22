'use strict'

app = angular.module 'papertrailApp'

app.controller "DocumentController", ($scope, $stateParams, Restangular) ->
	Restangular.setRequestSuffix(".json")
	$scope.document = Restangular.one('documents',$stateParams.document_id)
	$scope.document.get().then (data) ->
		$scope.document_title = data.title.text
		$scope.title_point_id = data.title.id

	$scope.$watch 'document_title', () ->
		title_point = $scope.document.one('points',$scope.title_point_id)
		title_point.text = $scope.document_title
		title_point.put()