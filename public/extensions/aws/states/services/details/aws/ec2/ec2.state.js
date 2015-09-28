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
  function StateController(service) {
    var vm = this;

    vm.title = '';
    vm.service = service;

    vm.activate = activate;

    activate();

    function activate() {
    }
  }
})();
