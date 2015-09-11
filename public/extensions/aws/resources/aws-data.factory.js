(function() {
  'use strict';

  angular.module('app.resources')
    .factory('AwsData', AwsDataFactory);

  /** @ngInject */
  function AwsDataFactory($resource) {
    var base = '/api/v1/aws/providers/:id/:action';
    var AwsData = $resource(base, {action: '@action', id: '@id'});

    AwsData.ec2Flavors = ec2Flavors;
    AwsData.ec2Images = ec2Images;
    AwsData.subnets = subnets;
    AwsData.zones = zones;

    return AwsData;

    function ec2Flavors(id) {
      return AwsData.query({id: id, action: 'ec2_flavors'}).$promise;
    }

    function ec2Images(id) {
      return AwsData.query({id: id, action: 'ec2_images'}).$promise;
    }

    function subnets(id) {
      return AwsData.query({id: id, action: 'subnets'}).$promise;
    }

    function zones(id) {
      return AwsData.query({id: id, action: 'availability_zones'}).$promise;
    }
  }
})();
