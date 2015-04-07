angular.module('nextbus', [])

.controller('TimesController', function ($scope, Times){
  angular.extend($scope, Times);
})
.factory('Times', function ($http){
  var data;

  var getTimes = function(dest){
    return $http({
      method: 'GET',
      url: '/next/' + dest
    })
    .then(function (response){
      data = response.data
      console.log(data)
    });
  };

  return {
    data: data,
    getTimes: getTimes
  };
});
