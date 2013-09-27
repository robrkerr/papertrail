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
		$scope.title_point.get().then (data) ->
			$scope.title_point.children = data.children
		$scope.panel_points = [$scope.title_point]
		$scope.push_title = () ->
			$scope.title_point.text = $scope.document_title
			$scope.title_point.put()
		$scope.retrieve_subpoints = (point) ->
			$scope.document.one('points',point.id).get().then (data) ->
				point.children = data.children.map (c) ->
					c.class = ""
					c
				point.context = data.context
		$scope.panel_point = (panel) ->
			if $scope.panel_points.length <= 3
			  $scope.panel_points[panel-1]
			else $scope.panel_points[$scope.panel_points.length-4+panel]
		$scope.activate = (point,panel) ->
			if point.class == "activated"
				$scope.jump_back()
			else
				if ($scope.panel_points.length == panel) || (panel == 3)
					$scope.panel_points.push(point)
				else if $scope.panel_points.length <= 3
					if $scope.panel_points.length == (panel+1)
				  	$scope.panel_points[panel] = point
					else
						$scope.panel_points = $scope.panel_points.slice(0,panel+1)
						$scope.panel_points[panel] = point
				else
					$scope.panel_points = $scope.panel_points.slice(0,$scope.panel_points.length-2+panel)
					$scope.panel_points[$scope.panel_points.length-1] = point
				$scope.retrieve_subpoints(point)
				parent = $scope.panel_points[$scope.panel_points.length-2]
				parent.children = parent.children.map (c) ->
					c.class = "deactivated"
					c
				point.class = "activated"
		$scope.jump_back = () ->
			if $scope.panel_points.length > 1
				$scope.panel_points[$scope.panel_points.length-1].class = ""
				$scope.panel_points = $scope.panel_points.slice(0,$scope.panel_points.length-1)
				parent = $scope.panel_points[$scope.panel_points.length-1]
				parent.children = parent.children.map (c) ->
					c.class = ""
					c

