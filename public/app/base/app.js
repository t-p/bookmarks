var bookmarkModule = angular.module('app_base', ['ngResource']);

bookmarkModule.factory("Bookmark", function($resource) {
  return $resource("/bookmarks/:id", {id:"@id"})
});

bookmarkModule.factory("bookmarks", function(Bookmark) {
  return Bookmark.query();
});

bookmarkModule.factory("deleteBookmark", function(bookmarks) {
  return function(bookmark) {
    var index = bookmarks.indexOf(bookmark);
    bookmark.$delete();
    bookmarks.splice(index, 1);
  };
});

bookmarkModule.factory("editBookmark", function(state) {
  return function(bookmark) {
    state.formBookmark.bookmark = bookmark;
  };
});

bookmarkModule.factory("saveBookmark", function(bookmarks, state) {
  return function(bookmark) {
    if (!bookmark.id) {
      bookmarks.push(bookmark);
    }
    bookmark.$save();
    state.clearForm();
  };
});

bookmarkModule.service("state", function(Bookmark) {
  this.formBookmark = {bookmark:new Bookmark()};
  this.clearForm = function() {
    this.formBookmark.bookmark = new Bookmark();
  };
});

bookmarkModule.controller("BookmarkFormController", function($scope, state, bookmarks, saveBookmark) {
  $scope.formBookmark = state.formBookmark;
  $scope.saveBookmark = saveBookmark;
  $scope.clearForm = state.clearForm;
});

bookmarkModule.controller("BookmarkListController", function($scope, bookmarks, deleteBookmark, editBookmark) {
  $scope.bookmarks = bookmarks;
  $scope.deleteBookmark = deleteBookmark;
  $scope.editBookmark = editBookmark;
});
