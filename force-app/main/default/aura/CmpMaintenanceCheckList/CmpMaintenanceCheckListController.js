({

    enableHouseGridAccess : function(component, event, helper) {
        debugger;
   
        var accessType = event.getParam("accessType");
        component.set("v.enableHouseGrid","true");
        component.set("v.AccessType",accessType);
        var at=component.get("v.AccessType");
        //alert(at);
        
      
    },
    
    ToggleScreen : function(component,event,helper){
        debugger;
        var screen = event.getParam("screen");

        switch(screen){
            case "House Grid" :
                component.set("v.enableHouseGrid",true);
                component.set("v.IsTaskListEnabled",false);
                component.set("v.loaded",false);
                break;
           case "Task Grid" :
                component.set("v.enableHouseGrid",false);
                component.set("v.IsTaskListEnabled",true);
                component.set("v.loaded",false);
                break;
            case "Main" :
                component.set("v.enableHouseGrid",false);
                component.set("v.loaded",false);
                break;
        }  
    }
})