({
    doInit : function(component, event, helper) {
        helper.getHouselist(component);
    },
    showDailyActiviy : function(component,event,helper){
        component.set("v.loaded",true);//loading start
        debugger;
    
        var cmpEvent = component.getEvent("ShowActivitiesEvent");
        cmpEvent.setParams({
            "isActivitiesEnabled" : "true",
            "HouseId" : event.getSource().get("v.value"),
            "viewType" : "Daily_Line_Item"
        });
        cmpEvent.fire();
       
    },
    showWeeklyActiviy : function(component,event,helper){
       
        component.set("v.loaded",true);//loading start
        var cmpEvent = component.getEvent("ShowActivitiesEvent");
        cmpEvent.setParams({
            "isActivitiesEnabled" : "true",
            "HouseId" : event.getSource().get("v.value"),
            "viewType" : "Weekly_Line_Item"
        });
        cmpEvent.fire();
       
    },
    showAllActiviy : function(component,event,helper){
       
        component.set("v.loaded",true);//loading start
        var cmpEvent = component.getEvent("ShowActivitiesEvent");
        cmpEvent.setParams({
            "isActivitiesEnabled" : "true",
            "HouseId" : event.getSource().get("v.value"),
            "viewType" : "Director_Review"
        });
        cmpEvent.fire();
       
    }
})