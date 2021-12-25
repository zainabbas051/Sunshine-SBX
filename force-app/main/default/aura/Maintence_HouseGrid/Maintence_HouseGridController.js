({
    doInit : function(component, event, helper) {
        helper.getHouselist(component);
    },
    showActivities : function(component,event,helper){

        component.set("v.loaded",true);//loading start
        var houseId =  event.getSource().get("v.value");
        debugger;
        var maintenanceType =  event.getSource().get("v.label");
        component.set("v.selectedHouse",houseId);
        component.set("v.maintenanceType",maintenanceType);
        component.set("v.IsTaskListEnabled",true);
        
    }
})