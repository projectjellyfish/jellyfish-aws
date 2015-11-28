(function() {
  'use strict';

  angular.module('app.states')
    .run(appRun);

  /** @ngInject */
  function appRun(StateOverride) {
    StateOverride.override('services.details', function(service) {
      if ('JellyfishAws::Service::Ec2' == service.type) {
        return {
          templateUrl: 'extensions/aws/states/services/details/aws/ec2/ec2.html',
          controller: StateController
        };
      }
    })
  }

  /** @ngInject */
  function StateController(service, AwsData) {
    var vm = this;

    vm.title = '';
    vm.service = service;

    vm.activate = activate;

    vm.deprovision = deprovision;

    activate();

    function activate() {
    }

    function handleResponse(response) {
      console.log(response);
      vm.response = response;
    }

    function handleError(response) {
      console.log(response);
      vm.response = response;
    }

    function deprovision(){
      vm.response = null;
      AwsData['deprovision'](vm.service.provider.id, vm.service.id).then(handleResponse, handleError);
    }
  }
})();
