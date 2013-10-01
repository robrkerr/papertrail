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
	$scope.set_panels = (width) ->
		if width > 1300
			$scope.panels = [1,2,3]
		else if width > 800
			$scope.panels = [1,2]
		else
			$scope.panels = [1]
	$scope.set_panels($window.innerWidth)
	$window.onresize = () ->
    $scope.set_panels($window.innerWidth)
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
		$scope.panel_point = (panel) ->
			if $scope.panel_points.length <= $scope.panels.length
			  $scope.panel_points[panel-1]
			else $scope.panel_points[$scope.panel_points.length-$scope.panels.length-1+panel]
		$scope.activate = (point,panel) ->
			if point.class == "activated"
				$scope.jump_back()
			else
				if ($scope.panel_points.length == panel) || (panel == $scope.panels.length)
					$scope.panel_points.push(point)
				else if $scope.panel_points.length <= $scope.panels.length
					if $scope.panel_points.length == (panel+1)
				  	$scope.panel_points[panel] = point
					else
						$scope.panel_points = $scope.panel_points.slice(0,panel+1)
						$scope.panel_points[panel] = point
				else
					$scope.panel_points = $scope.panel_points.slice(0,$scope.panel_points.length-$scope.panels.length+1+panel)
					$scope.panel_points[$scope.panel_points.length-1] = point
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


			