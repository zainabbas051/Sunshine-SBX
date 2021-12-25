({
    GoBack : function(component, event, helper) {
        debugger;
         var screen = event.target.id;
         component.set("v.loaded",true);//loading start 
         //this event is captured by CmpCheckList
         var cmpEvent = component.getEvent("GoBackEvent");
         cmpEvent.setParams({
             "screen" : screen
                     });
         cmpEvent.fire();
    }
})