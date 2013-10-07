'use strict'

app = angular.module 'papertrailApp'

app.directive "mathjaxBind", ->
  restrict: "A"
  controller: ($scope, $element, $attrs) -> 
  	$scope.$watch $attrs.mathjaxBind, (value) ->
      $element.text (if value is `undefined` then "" else value)
      MathJax.Hub.Queue ["Typeset", MathJax.Hub, $element[0]]

app.controller "DocumentController", ($scope, $window, $stateParams, Restangular) ->
	Restangular.setRequestSuffix(".json")
	Restangular.all('contexts').getList().then (data) ->
		$scope.contexts = data
	$scope.document = Restangular.one('documents',$stateParams.document_id)
	$scope.num_panels = 2
	$scope.panel_width = ($window.innerWidth-20)/$scope.num_panels
	$window.onresize = () ->
    $scope.panel_width = ($window.innerWidth-20)/$scope.num_panels
    $scope.$apply()
	$scope.document.get().then (data) ->
		$scope.document_title = data.title.text
		$scope.title_point = $scope.document.one('points',data.title.id)
		$scope.title_point.get().then (data) ->
			$scope.title_point.children = data.children
		$scope.panel_points = [$scope.title_point]
		$scope.retrieve_subpoints = (point) ->
			$scope.document.one('points',point.id).get().then (data) ->
				point.children = data.children
				$scope.set_children_class(point,"")
				point.context = data.context
		$scope.activate = (point,panel) ->
			if ($scope.panel_points.length == panel)
				$scope.panel_points.push(point)
			else
				$scope.panel_points = $scope.panel_points.slice(0,panel+1)
				$scope.panel_points[panel] = point
			$scope.retrieve_subpoints(point)
			parent = $scope.panel_points[$scope.panel_points.length-2]
			$scope.set_children_class(parent,"deactivated")
			point.class = "activated"
		$scope.jump_back = () ->
			if $scope.panel_points.length > 1
				$scope.panel_points[$scope.panel_points.length-1].class = ""
				$scope.panel_points = $scope.panel_points.slice(0,$scope.panel_points.length-1)
				parent = $scope.panel_points[$scope.panel_points.length-1]
				$scope.set_children_class(parent,"")
		$scope.add_comment = () ->
			$scope.document.all('points').post({comment: $scope.panel_points[$scope.panel_points.length-1].new_comment}).then (data) ->
				$scope.panel_points[$scope.panel_points.length-1].new_comment = ""
				$scope.document.one('points',$scope.panel_points[$scope.panel_points.length-1].id).all('subpointlinks').post({subpoint_id: data.id}).then (data) ->
						$scope.retrieve_subpoints($scope.panel_points[$scope.panel_points.length-1])
		$scope.set_children_class = (point,class_str) ->
			point.children = point.children.map (c) ->
					c.class = class_str
					c


			