({
    handleComponentEvent : function(component, event, helper) {
      
        var opptyId = event.getParam("opptyId");
          var accountType = event.getParam("accountType");
         // alert(opptyId);
         //alert(accountType);
        component.set('v.showForm',true);
         component.set('v.opptyId',opptyId);
         component.set('v.accountType',accountType);
        

    }
})