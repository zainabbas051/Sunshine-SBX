({
    cancelEscalate : function(component,event,helper){
        component.set('v.escalatePopUp',false);
    },
    defaultAction : function(component,event,helper){

        helper.getEmployeeSuperVisor(component);
    },
    submitEscalateDetail : function(component,event,helper){
        
        debugger;
        var dateTimeField = component.find('dateTimeReqField');
        dateTimeField.showHelpMessageIfInvalid();
        var valid = dateTimeField.get("v.validity").valid;
        if(!valid){
           return;
        }

        var supvisorField = component.find("supervisorField");
        var value = supvisorField.get("v.value");
        if(value===''||value===null) {
            supvisorField.showHelpMessageIfInvalid();
            return;
        }

        helper.submitEscalation(component);
    }
})