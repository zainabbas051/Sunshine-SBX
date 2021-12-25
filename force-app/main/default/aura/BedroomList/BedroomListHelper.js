({
    getBedroomlist : function(component) {
        debugger;
        var action = component.get("c.getHouseLineItemsList");
        var houseId = component.get("v.selectedHouse");
        var viewType = component.get("v.viewType");
        var LineItemType = component.get("v.HouseLineItemType");
        action.setParams({  houseId : houseId,
            lineItemType : LineItemType,
             recordType :viewType });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                component.set("v.HouseLineItems", response.getReturnValue());
                component.set("v.loaded",false);//loading start 
            } else {
                console.log("Failed with state: " + state);
            }
        });
        
        $A.enqueueAction(action);

    }
})