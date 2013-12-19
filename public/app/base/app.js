//(function(app) {
//  debugger;
//  app.factory("Bookmark", function($resource) {
//    return $resource("/bookmarks/:id", {id:"@id"});
//  });
//
//  app.controller('TextController',
//    function($scope) {
//    var someText = {};
//    someText.message = 'You have started your journey.';
//    $scope.someText = someText;
//})(
//  angular.module("app_base", ["ngResource"])
//);

var myAppModule = angular.module('app_base', ['ngResource']);

myAppModule.factory("Bookmark", ['$resource',
  function($resource) {
    return $resource("/bookmarks/:id", {id:"@id"});
}]);
myAppModule.factory("bookmarks", function(Bookmark) {
  return Bookmark.query();
});
myAppModule.factory("saveBookmark", function(bookmarks, state) {
  return function(bookmark) {
    if (!bookmark.id) {
      bookmarks.push(bookmark);
    }
    bookmark.$save();
    state.clearForm();
  };
});
myAppModule.service("state", function(Bookmark) {
  this.formBookmark = {bookmark:new Bookmark()};
  this.clearForm = function() {
    this.formBookmark.bookmark = new Bookmark();
  };
});

myAppModule.controller("BookmarkFormController",
  function($scope, state, bookmarks, saveBookmark) {
    $scope.formBookmark = state.formBookmark;
    $scope.saveBookmark = saveBookmark;
    $scope.clearForm = state.clearForm;
});
myAppModule.controller('TextController',
  function($scope) {
  var someText = {};
  someText.message = 'You have started your journey.';
  $scope.someText = someText;
});
