({
    showBedroomList : function(component,event,helper){
        debugger;
        component.set("v.loaded",true);//loading start   
        var cmpEvent = component.getEvent("ShowBedroomListEvent");
        cmpEvent.setParams({
            "HouseName" : component.get("v.selectedHouse"),
            "HouseLineItemType" :event.target.id
                    });
        cmpEvent.fire();
    },
    generateActivitiesWithColors : function(component, event, helper) {
        debugger;
        helper.fetchData(component);
    }
})