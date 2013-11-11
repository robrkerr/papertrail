'use strict'

app = angular.module 'papertrailApp'

app.controller "PointsController", ($scope, $stateParams, Restangular) ->
	Restangular.setRequestSuffix(".json")
	Restangular.all('contexts').getList().then (data) ->
		$scope.contexts = data
	$scope.document = Restangular.one('documents',$stateParams.document_id)
	$scope.document.get().then (data) ->
		$scope.document_title = data.title.text
		$scope.title_point = $scope.document.one('points',data.title.id)
		$scope.title_point.get().then (data) ->
			$scope.title_point.children = data.children
			$scope.title_point.all_possible_children = data.all_possible_children
			$scope.title_point.new_child = undefined
		$scope.push_title = () ->
			$scope.title_point.text = $scope.document_title
			$scope.title_point.put()

app.directive "pointlist", ($compile) ->
  restrict: "E"
  template: """
  	<ul>
			<li class="editable_point">
				Main points:
				<ul style="margin: 10px">
					<li ng-repeat="subpoint in rootpoint.children">
						<button ng-click="remove_subpoint(rootpoint,subpoint)">x</button>
						Point {{subpoint.document_position}}:
						({{subpoint.context}}) {{subpoint.text}}
					</li>
					<li>
						Add link to point: <select ng-change="add_subpoint(rootpoint)" ng-model="rootpoint.new_child" ng-options="sub as sub.document_position for sub in rootpoint.all_possible_children"></select>
					</li>
				</ul>
			</li>
			<li class="editable_point" ng-repeat="point in points">
				<input class="checkbox" type="checkbox" name="point_check" ng-model="point.open"></input>
				<button ng-click="remove_point(point)">x</button>
				Point {{point.document_position}}: 
				<select ng-change="push_point_context(point)" ng-model="point.context_id" ng-options="c.id as c.description for c in contexts"></select>
				Used in {{point.instances}} place(s), Has {{point.children.length}} child(ren)
				<textarea style="margin: 10px; display: block" ng-blur="push_point_text(point)" type="text" ng-model="point.text"></textarea>
				<div ng-if="point.open">
					Subpoints:
					<ul style="margin: 10px">
						<li ng-repeat="subpoint in point.children">
							<button ng-click="remove_subpoint(point,subpoint)">x</button>
							Point {{subpoint.document_position}}:
							({{subpoint.context}}) {{subpoint.text}}
						</li>
						<li>
							Add link to point: <select ng-change="add_subpoint(point)" ng-model="point.new_child" ng-options="sub as sub.document_position for sub in point.all_possible_children"></select>
						</li>
					</ul>
				</div>
			</li>
			<li class="editable_point">
				<button ng-click="create_point()">New point</button>
			</li>
		</ul>
  """
  controller: ($scope, $stateParams, Restangular) ->
		  Restangular.setRequestSuffix(".json")
				Restangular.all('contexts').getList().then (data) ->
					$scope.contexts = data
				$scope.document = Restangular.one('documents',$stateParams.document_id)
				$scope.document.get().then (data) ->
					$scope.rootpoint = $scope.document.one('points',data.title.id)
					$scope.update_root_point = () ->
						$scope.rootpoint.get().then (data) ->
							$scope.rootpoint.children = data.children
							$scope.rootpoint.all_possible_children = data.all_possible_children
					$scope.load_points = () ->
						$scope.document.all('points').getList().then (data) ->
							$scope.points = data
							$scope.update_root_point()
					$scope.load_points()
					$scope.push_point_text = (point) ->
						updated_point = $scope.document.one('points',point.id)
						updated_point.text = point.text
						updated_point.put().then (data) ->
							$scope.load_points()
					$scope.push_point_context = (point) ->
						updated_point = $scope.document.one('points',point.id)
						updated_point.context_id = point.context_id
						updated_point.put().then (data) ->
							$scope.load_points()
					$scope.create_point = () ->
						$scope.document.all('points').post().then (data) ->
							$scope.load_points()
					$scope.remove_point = (point) ->
			  	  $scope.document.one('points',point.id).remove().then (data) ->
			  	  	$scope.load_points()
			  	$scope.add_subpoint = (point) ->
			  		$scope.document.one('points',point.id).all('subpointlinks').post({subpoint_id: point.new_child.id}).then (data) ->
							$scope.load_points()
					$scope.remove_subpoint = (point,subpoint) ->
			  		$scope.document.one('points',point.id).one('subpointlinks',subpoint.subpointlink_id).remove().then (data) ->
							$scope.load_points()
  compile: (tElement, tAttr) ->
    contents = tElement.contents().remove()
    compiledContents = undefined
    (scope, iElement, iAttr) ->
      compiledContents = $compile(contents)  unless compiledContents
      compiledContents scope, (clone, scope) ->
        iElement.append clone
