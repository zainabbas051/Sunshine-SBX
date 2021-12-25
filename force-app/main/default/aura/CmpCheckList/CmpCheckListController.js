({
    enableActivities : function(component, event, helper) {
        debugger;
        var isActivitiesEnabled = event.getParam("isActivitiesEnabled");
        var selectedHouseId = event.getParam("HouseId");
        var viewType = event.getParam("viewType");
        component.set("v.isActivitiesEnabled",isActivitiesEnabled);
        component.set("v.selectedHouse",selectedHouseId);
        component.set("v.viewType",viewType);
        helper.GenerateActivitiesColor(component);
      
    },
    enableHouseGridAccess : function(component, event, helper) {
        debugger;
   
        var accessType = event.getParam("accessType");
        component.set("v.enableHouseGrid","true");
        component.set("v.AccessType",accessType);
        var at=component.get("v.AccessType");
        //alert(at);
        
      
    },
    
    HideActivities : function(component, event, helper) {
       
        var LineItemType=event.getParam("HouseLineItemType");
        component.set("v.HouseLineItemType",LineItemType)
        component.set("v.isActivitiesEnabled",false);
        component.set("v.isBedroomListEnabled",true);
        if(LineItemType == 'Kitchen'||
           LineItemType == 'Living Area' ||
           LineItemType == 'Landscaping'||
           LineItemType == 'Vehicle Cleaning'||
           LineItemType == 'Vehicle Maintenance' ||
           LineItemType == 'Reception or Lobby'){
            component.find('bedroomCmp').set('v.showTask',true);
        }
        
       // component.set("v.loaded",false);//loading stop
    },

    ToggleScreen : function(component,event,helper){
        debugger;
        var screen = event.getParam("screen");

        switch(screen){
            case "Main" :
                component.set("v.isActivitiesEnabled",false);
                component.set("v.isBedroomListEnabled",false);
                break;
            case "Activity":
                component.set("v.isActivitiesEnabled",true);
                component.set("v.isBedroomListEnabled",false);
                helper.GenerateActivitiesColor(component);
                break;
            case "Bedroom":
                component.find('bedroomCmp').set('v.showTask',false);
                component.set("v.loaded",false);//loading stop
                break;

        }
    
    },
    doInit : function(component, event, helper) {
      /*  var action = component.get("c.getAccessType");

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                component.set("v.AccessType", response.getReturnValue());
            } else {
                console.log("Failed with state: " + state);
            }
        });
        
        $A.enqueueAction(action);
        */
    }
    
})