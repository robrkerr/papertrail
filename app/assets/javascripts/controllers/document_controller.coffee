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
			$scope.title_point.children = data.children.map (c) ->
				c.depth = 1
				c
			$scope.title_point.all_possible_children = data.all_possible_children
			$scope.title_point.new_child = undefined
			$scope.title_point.depth = 0
		$scope.push_title = () ->
			$scope.title_point.text = $scope.document_title
			$scope.title_point.put()

app.directive "pointtree", ($compile) ->
  restrict: "A"
  scope:
    rootpoint: "=pointtree"
  template: """
		<li ng-repeat="point in rootpoint.children">
			<input type="radio" name="level_{{rootpoint.depth}}" ng-model="rootpoint.active_child" value="{{point.subpointlink_position}}" ng-click="retrieve_subpoints(point)"/>
			({{point.context}}) {{point.text}}
			<div ng-if="rootpoint.active_child == point.subpointlink_position">
				<ul pointtree="point"></ul>
			</div>
		</li>
  """
  controller: ($scope, $stateParams, Restangular) ->
	  	Restangular.setRequestSuffix(".json")
				Restangular.all('contexts').getList().then (data) ->
					$scope.contexts = data
				$scope.document = Restangular.one('documents',$stateParams.document_id)
				$scope.retrieve_subpoints = (point) ->
					point.active_child = undefined
					$scope.document.one('points',point.id).get().then (data) ->
						point.children = data.children.map (c) ->
							c.depth = point.depth + 1
							c
						console.log(point.children)
						console.log(point.depth)
						console.log(point.depth + 1)
						point.context_id = data.context_id
						point.all_possible_children = data.all_possible_children
						point.new_child = undefined
  compile: (tElement, tAttr) ->
    contents = tElement.contents().remove()
    compiledContents = undefined
    (scope, iElement, iAttr) ->
      compiledContents = $compile(contents)  unless compiledContents
      compiledContents scope, (clone, scope) ->
        iElement.append clone
