//(function(app) {
//  debugger;
//  app.factory("Bookmark", function($resource) {
//    return $resource("/bookmarks/:id", {id:"@id"});
//  });
//
//})(
//  angular.module("app_base", ["ngResource"])
//);
var myAppModule = angular.module('app_base', []);

myAppModule.controller('TextController',
  function($scope) {
  var someText = {};
  someText.message = 'You have started your journey.';
  $scope.someText = someText;
});
