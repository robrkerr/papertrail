'use strict'

app = angular.module 'papertrailApp'

app.controller "DocumentController", ($scope, $stateParams, Restangular) ->
	Restangular.setRequestSuffix(".json")
	Restangular.all('contexts').getList().then (data) ->
		$scope.contexts = data
	$scope.document = Restangular.one('documents',$stateParams.document_id)
	$scope.document.get().then (data) ->
		$scope.document_title = data.title.text
		$scope.title_point = $scope.document.one('points',data.title.id)
		$scope.push_title = () ->
			$scope.title_point.text = $scope.document_title
			$scope.title_point.put()
		$scope.retrieve_subpoints = (point) ->
			point.active_child = undefined
			$scope.document.one('points',point.id).get().then (data) ->
				point.children = data.children
				point.context_id = data.context_id
		$scope.push_point_text = (point) ->
			updated_point = $scope.document.one('points',point.id)
			updated_point.text = point.text
			updated_point.put()
		$scope.push_point_context = (point) ->
			updated_point = $scope.document.one('points',point.id)
			updated_point.context_id = point.context_id
			updated_point.put()
		$scope.create_point = (parent_point) ->
			$scope.document.all('points').post({parent_id: parent_point.id}).then (data) ->
				$scope.retrieve_subpoints(parent_point)
		$scope.remove_point = (point,parent) ->
  	  $scope.document.one('points',point.id).remove().then (data) ->
  	  	$scope.retrieve_subpoints(parent) 
		$scope.retrieve_subpoints($scope.title_point)

