'use strict'

app = angular.module 'papertrailApp'

app.directive "mathjaxBind", ->
  restrict: "A"
  controller: ($scope, $element, $attrs) -> 
  	$scope.$watch $attrs.mathjaxBind, (value) ->
      $element.text (if value is `undefined` then "" else value)
      MathJax.Hub.Queue ["Typeset", MathJax.Hub, $element[0]]

app.directive "pointHeader", ->
  restrict: "A"
  scope:
  	point: "=pointHeader"
  controller: ($scope, $element, $attrs) ->
  	$scope.pluralize = (number, singular, plural) ->
				"#{number} " + (if number == 1 then singular else plural)
  template: """
  		{{point.context}}
  		(Appears in {{pluralize(point.instances,"place","places")}},
  		Has {{pluralize(point.children.length,"child","children")}})
  	"""

app.controller "DocumentController", ($scope, $window, $stateParams, Restangular) ->
	Restangular.setRequestSuffix(".json")
	Restangular.all('contexts').getList().then (data) ->
		$scope.contexts = data
	$scope.document = Restangular.one('documents',$stateParams.document_id)
	$scope.num_panels = 2
	$scope.parent_shift = 1;
	$scope.panel_width = ($window.innerWidth*0.985)/$scope.num_panels
	$window.onresize = () ->
    $scope.panel_width = ($window.innerWidth*0.985)/$scope.num_panels
    $scope.$apply()
	$scope.document.get().then (data) ->
		$scope.document_title = data.title.text
		$scope.title_point = $scope.document.one('points',data.title.id)
		$scope.title_point.get().then (data) ->
			$scope.title_point.children = data.children
		$scope.panel_points = [$scope.title_point]
		$scope.retrieve_subpoints = (ind) ->
			point = $scope.panel_points[ind]
			$scope.document.one('points',point.id).get().then (data) ->
				point.children = data.children
				point.parents = data.parents
				point.instances = data.instances
				point.context = data.context
				$scope.set_children_class(point,"")
				$scope.set_parents_class(point,"deactivated")
				angular.forEach point.parents, (value) ->
					if value.id == $scope.panel_points[ind-1].id
						value.class = "activated"
		$scope.activate = (point,panel) ->
			if ($scope.panel_points.length == panel)
				$scope.panel_points.push(point)
			else
				$scope.panel_points = $scope.panel_points.slice(0,panel+1)
				$scope.panel_points[panel] = point
			$scope.retrieve_subpoints(panel)
			parent = $scope.panel_points[$scope.panel_points.length-2]
			$scope.set_children_class(parent,"deactivated")
			point.class = "activated"
		$scope.select_as_parent = (point,ind) ->
			if point.instances > 0
				$scope.panel_points[$scope.panel_points.length-1-ind] = point
				$scope.document.one('points',point.id).get().then (data) ->
					if data.parents.length > 0
						$scope.select_as_parent(data.parents[0],ind+1)
					else
						$scope.activate_new_branch($scope.panel_points.length-ind)
		$scope.activate_new_branch = (ind) ->
			if ind < $scope.panel_points.length
				$scope.document.one('points',$scope.panel_points[ind-1].id).get().then (data) ->
					$scope.panel_points[ind-1].children = data.children
					$scope.panel_points[ind-1].parents = data.parents
					$scope.panel_points[ind-1].instances = data.instances
					$scope.panel_points[ind-1].context = data.context
					$scope.set_children_class($scope.panel_points[ind-1],"deactivated")
					$scope.set_parents_class($scope.panel_points[ind-1],"deactivated")
					angular.forEach $scope.panel_points[ind-1].children, (value) ->
						if value.id == $scope.panel_points[ind].id
							value.class = "activated"
							$scope.panel_points[ind] = value
					angular.forEach $scope.panel_points[ind-1].parents, (value) ->
						if value.id == $scope.panel_points[ind-2].id
							value.class = "activated"
					$scope.activate_new_branch(ind+1)
			else if ind == $scope.panel_points.length
				$scope.document.one('points',$scope.panel_points[ind-1].id).get().then (data) ->
					$scope.panel_points[ind-1].children = data.children
					$scope.panel_points[ind-1].parents = data.parents
					$scope.panel_points[ind-1].instances = data.instances
					$scope.panel_points[ind-1].context = data.context
					angular.forEach $scope.panel_points[ind-1].parents, (value) ->
						if value.id == $scope.panel_points[ind-2].id
							value.class = "activated"
		$scope.jump_back = () ->
			if $scope.panel_points.length > 1
				$scope.panel_points[$scope.panel_points.length-1].class = ""
				$scope.panel_points = $scope.panel_points.slice(0,$scope.panel_points.length-1)
				parent = $scope.panel_points[$scope.panel_points.length-1]
				$scope.set_children_class(parent,"")
				if $scope.panel_points.length <= 2
					$scope.parent_shift = 1
		$scope.see_parents = () ->
			if $scope.parent_shift == 1
				$scope.parent_shift = 0
		$scope.see_children = () ->
			if $scope.parent_shift == 0
				$scope.parent_shift = 1
		$scope.add_comment = () ->
			$scope.document.all('points').post({comment: $scope.panel_points[$scope.panel_points.length-1].new_comment}).then (data) ->
				$scope.panel_points[$scope.panel_points.length-1].new_comment = ""
				$scope.document.one('points',$scope.panel_points[$scope.panel_points.length-1].id).all('subpointlinks').post({subpoint_id: data.id}).then (data) ->
						$scope.retrieve_subpoints($scope.panel_points.length-1)
		$scope.set_children_class = (point,class_str) ->
			point.children = point.children.map (c) ->
					c.class = class_str
					c
		$scope.set_parents_class = (point,class_str) ->
			point.parents = point.parents.map (p) ->
					p.class = class_str
					p
