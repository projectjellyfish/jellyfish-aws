(function() {
  'use strict';

  angular.module('app.components')
    .run(initFields);

  /** @ngInject */
  function initFields(Forms) {
    Forms.fields('aws_regions', {
      type: 'select',
      templateOptions: {
        label: 'Region',
        options: [
          {label: 'N. Virginia (US-East-1)', value: 'us-east-1', group: 'US'},
          {label: 'N. California (US-West-1)', value: 'us-west-1', group: 'US'},
          {label: 'Oregon (US-West-2)', value: 'us-west-2', group: 'US'},
          {label: 'Ireland (EU-West-1)', value: 'eu-west-1', group: 'Europe'},
          {label: 'Frankfurt (EU-Central-1)', value: 'eu-central-1', group: 'Europe'},
          {label: 'Singapore (AP-Southeast-1)', value: 'ap-southeast-1', group: 'Asia Pacific'},
          {label: 'Sydney (AP-Southeast-2)', value: 'ap-southeast-2', group: 'Asia Pacific'},
          {label: 'Tokyo (AP-Northeast-1)', value: 'ap-northeast-1', group: 'Asia Pacific'},
          {label: 'Sãn Paulo (SA-East-1)', value: 'sa-east-1', group: 'South America'}
        ]
      }
    });

    Forms.fields('aws_ec2_images', {
      type: 'async_select',
      templateOptions: {
        label: 'System Image',
        options: []
      },
      data: {
        action: 'ec2Images'
      },
      controller: AwsDataController
    });

    Forms.fields('aws_rds_engines', {
      type: 'async_select',
      templateOptions: {
        label: 'Engine Version',
        options: []
      },
      data: {
        action: 'rdsEngines'
      },
      controller: AwsDataController
    });

    Forms.fields('aws_ec2_flavors', {
      type: 'async_select',
      templateOptions: {
        label: 'Instance Type',
        options: []
      },
      data: {
        action: 'ec2Flavors'
      },
      controller: AwsDataController
    });

    Forms.fields('aws_vpcs', {
      type: 'async_select',
      templateOptions: {
        label: 'VPC',
        options: []
      },
      data: {
        action: 'vpcs'
      },
      controller: AwsDataController
    });

    Forms.fields('aws_subnets', {
      type: 'async_select',
      templateOptions: {
        label: 'Subnet',
        options: []
      },
      data: {
        action: 'subnets'
      },
      controller: AwsDataController
    });

    Forms.fields('aws_zones', {
      type: 'async_select',
      templateOptions: {
        label: 'Availability Zone',
        options: []
      },
      data: {
        action: 'zones'
      },
      controller: AwsDataController
    });

    Forms.fields('aws_key_names', {
      type: 'async_select',
      templateOptions: {
        label: 'Key Name',
        options: []
      },
      data: {
        action: 'keyNames'
      },
      controller: AwsDataController
    });

    Forms.fields('aws_security_groups', {
      type: 'async_select',
      templateOptions: {
        label: 'Security Group',
        options: []
      },
      data: {
        action: 'securityGroups'
      },
      controller: AwsDataController
    });

    /** @ngInject */
    function AwsDataController($scope, AwsData, Toasts) {
      var provider = $scope.formState.provider;
      var action = $scope.options.data.action;

      // Cannot do anything without a provider
      if (angular.isUndefined(provider)) {
        Toasts.warning('No provider set in form state', $scope.options.label);
        return;
      }

      if (!action) {
        Toasts.warning('No action set in field data', $scope.options.label);
        return;
      }

      $scope.to.loading = AwsData[action](provider.id).then(handleResults, handleError);

      function handleResults(data) {
        $scope.to.options = data;
        return data;
      }


      function handleError(response) {
        var error = response.data;

        if (!error.error) {
          error = {
            type: 'Server Error',
            error: 'An unknown server error has occurred.'
          };
        }

        Toasts.error(error.error, [$scope.to.label, error.type].join('::'));

        return response;
      }
    }
  }
})();
