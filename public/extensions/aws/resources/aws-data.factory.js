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
    AwsData.vpcs = vpcs;
    AwsData.subnets = subnets;
    AwsData.zones = zones;
    AwsData.keyNames = keyNames;
    AwsData.securityGroups = securityGroups;
    AwsData.deprovision = deprovision;

    return AwsData;

    function ec2Flavors(id) {
      return AwsData.query({id: id, action: 'ec2_flavors'}).$promise;
    }

    function ec2Images(id) {
      return AwsData.query({id: id, action: 'ec2_images'}).$promise;
    }

    function vpcs(id) {
      return AwsData.query({id: id, action: 'vpcs'}).$promise;
    }

    function subnets(id) {
      return AwsData.query({id: id, action: 'subnets'}).$promise;
    }

    function zones(id) {
      return AwsData.query({id: id, action: 'availability_zones'}).$promise;
    }

    function keyNames(id) {
      return AwsData.query({id: id, action: 'key_names'}).$promise;
    }

    function securityGroups(id) {
      return AwsData.query({id: id, action: 'security_groups'}).$promise;
    }

    function deprovision(id, service_id) {
      return AwsData.query({id: id, action: 'deprovision', service_id: service_id}).$promise;
    }
  }
})();
