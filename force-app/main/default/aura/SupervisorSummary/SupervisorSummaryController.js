({
	doInit : function(component, event, helper) {
       // helper.getColumn(component);

        helper.getData(component,helper);
         helper.getT2EmployeeData(component);
        helper.getT3EmployeeData(component);
    },
    UpdateData: function(component, event, helper) {
       // helper.getColumn(component);

        helper.getData(component,helper);
    },

    transitToTier2Handler : function(component){
        debugger;
        component.set("v.isTierTransitionEnabled", true);
        component.set("v.isTier3TransitionEnabled", false);
    },

    transitToTier3Handler : function(component){
        debugger;
        component.set("v.isTier3TransitionEnabled", true);
        component.set("v.isTierTransitionEnabled", false);
    }
    
    ,
    
    ManualTransitHandler : function(component){
        debugger;
        component.set("v.isTier3TransitionEnabled", false);
        component.set("v.isTierTransitionEnabled", false);
         component.set("v.isManualTransitionEnabled", true);
        
    }
})