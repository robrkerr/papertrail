'use strict'

app = angular.module 'papertrailApp'

app.controller "DocumentController", ($scope, $stateParams, Restangular) ->
	Restangular.setRequestSuffix(".json")
	$scope.document = Restangular.one('documents',$stateParams.document_id)
	$scope.document.get().then (data) ->
		$scope.document_title = data.title.text
		$scope.title_point = $scope.document.one('points',data.title.id)
		$scope.$watch 'document_title', () ->
			$scope.title_point.text = $scope.document_title
			$scope.title_point.put()
		$scope.retrieve_subpoints = (point) ->
			$scope.document.one('points',point.id).get().then (data) ->
				point.children = data.children
				console.log(point.children)
				# angular.forEach point.children, (child) ->
				# 	$scope.$watch 'child.text', () ->
				# 		console.log('yolo')
				# 		child_record = $scope.document.one('points',child.id)
				# 		child_record.text = child.text
				# 		child_record.put().then (data) ->
				# 			console.log('hello')
		$scope.create_point = (parent_point) ->
			$scope.document.all('points').post({parent_id: parent_point.id}).then (data) ->
				$scope.retrieve_subpoints(parent_point)
		$scope.remove_point = (point,parent) ->
  	  $scope.document.one('points',point.id).remove().then (data) ->
  	  	$scope.retrieve_subpoints(parent) 
		$scope.retrieve_subpoints($scope.title_point)

