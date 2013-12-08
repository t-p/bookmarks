(function(app) {

  app.factory("Bookmark", function($resource) {
    return $resource("/bookmarks/:id", {id:"@id"});
  });

})(
  angular.module("BookmarkApp", ["ngResource"])
);
