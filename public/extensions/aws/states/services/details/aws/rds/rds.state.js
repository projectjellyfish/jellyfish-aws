(function() {
  'use strict';

  angular.module('app.states')
    .run(appRun);

  /** @ngInject */
  function appRun(StateOverride) {
    StateOverride.override('services.details', function(service) {
      if ('JellyfishAws::Service::RDS' == service.type) {
        return {
          templateUrl: 'extensions/aws/states/services/details/aws/rds/rds.html',
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
    vm.getServiceOutput = getServiceOutput;

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

    function getServiceOutput(service_output_name){
      var outputs = vm.service.service_outputs.filter(function(elt, idx){ return elt.name == service_output_name });
      if(outputs.length > 0){
        return outputs[0];
      }else{
        return null;
      }
    }
  }
})();
