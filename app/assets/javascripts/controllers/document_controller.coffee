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
		$scope.push_title = () ->
			$scope.title_point.text = $scope.document_title
			$scope.title_point.put()

app.directive "pointtree", ($compile) ->
  restrict: "A"
  scope:
    rootpoint: "=pointtree"
  template: """
		<li ng-repeat="point in rootpoint.children">
			<input type="radio" name="children_of_point{{rootpoint.id}}" ng-model="rootpoint.active_child" value="{{point.id}}" ng-click="retrieve_subpoints(point)"/>
			<button ng-click="remove_point(point,rootpoint)">x</button>
			<select ng-blur="push_point_context(point)" ng-model="point.context_id" ng-options="c.id as c.description for c in contexts">
			<input ng-blur="push_point_text(point)" type="text" ng-model="point.text"/>
			<div ng-if="rootpoint.active_child == point.id">
				<ul pointtree="point"></ul>
			</div>
		</li>
		<li>
			<button ng-click="create_point(rootpoint)">New point</button>
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
  compile: (tElement, tAttr) ->
    contents = tElement.contents().remove()
    compiledContents = undefined
    (scope, iElement, iAttr) ->
      compiledContents = $compile(contents)  unless compiledContents
      compiledContents scope, (clone, scope) ->
        iElement.append clone
