({
   callCheckList : function(component,event,accessType){
   
      	var cmpEvent = component.getEvent("showHouseGrid_Evt");
        cmpEvent.setParams({
            "accessType" : accessType,
        });
        cmpEvent.fire();
    },
    
})