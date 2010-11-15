if (typeof (Causes) === 'undefined') Causes = {};

Causes.Session = (function (){

  var login = function(redirect) {
    if (typeof (redirect) === 'undefined') window.location.reload();
    else window.location = redirect;
  };

  return {
    login: login
  };
})();
