'use strict'

app = angular.module 'papertrailApp'

app.controller "ImageDemoController", ($scope, $window, $stateParams, Restangular) ->
	$scope.path = []
	Restangular.setRequestSuffix(".json")
	$scope.document = Restangular.one('documents',$stateParams.document_id)
	$scope.document.get().then (data) ->
		$scope.root_point = $scope.document.one('points',data.title.id)
		$scope.root_point.get().then (data) ->
			$scope.root_point.children = data.children
	$scope.activate = (index) ->
		if $scope.active_point().children[index].children.length > 0
			$scope.path.push(index)
			point = $scope.find_active_point($scope.root_point,$scope.path)
			point_record = $scope.document.one('points',point.id)
			point_record.get().then (data) ->
				point.children = data.children
	$scope.step_back = () ->
		$scope.path.pop()
	$scope.active_point = () ->
		$scope.find_active_point($scope.root_point,$scope.path)	
	$scope.find_active_point = (root_point,path) ->
		if path.length > 0
			$scope.find_active_point(root_point.children[path[0]],path[1..path.length-1])
		else
			root_point
	$scope.color_class = (point) ->
		if point.children && point.children.length > 0
			"with_children"
		else
			"without_children"