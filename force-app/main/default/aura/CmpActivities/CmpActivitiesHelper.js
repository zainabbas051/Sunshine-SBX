({
    fetchData : function(component,event) {
        var action = component.get("c.getLineItemsAgainstHouse");
        var selectedHouseId = component.get("v.selectedHouse");
        var viewType = component.get("v.viewType");
        var accessType = component.get("v.accessType");
        debugger;
        action.setParams({  houseId : selectedHouseId ,viewType : viewType, accessType : accessType});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                debugger;
                var dataArray = response.getReturnValue();
                for(var item in dataArray){
                    switch(dataArray[item].Line_Item_Type__c+'-'+dataArray[item].Status__c){
                        case "Bedroom-Incomplete" :
                            component.set("v.BedRoomColor",'slds-item RedColor');
                            break;
                        case "Bedroom-Under Review" :
                            component.set("v.BedRoomColor",'slds-item OrangeColor');
                            break;
                        case "Bathroom-Incomplete" :
                            component.set("v.BathRoomColor",'slds-item RedColor');
                            break;
                        case "Bathroom-Under Review" :
                            component.set("v.BathRoomColor",'slds-item OrangeColor');
                            break;
                        case "Kitchen-Incomplete" :
                            component.set("v.KitchenColor",'slds-item RedColor');
                            break;
                        case "Kitchen-Under Review" :
                            component.set("v.KitchenColor",'slds-item OrangeColor');
                            break;
                        case "Living Area-Incomplete" :
                            component.set("v.LivingAreaColor",'slds-item RedColor');
                            break;
                        case "Living Area-Under Review" :
                            component.set("v.LivingAreaColor",'slds-item OrangeColor');
                            break;
                        case "Landscaping-Incomplete" :
                            component.set("v.LandscapingColor",'slds-item RedColor');
                            break;
                        case "Landscaping-Under Review" :
                            component.set("v.LandscapingColor",'slds-item OrangeColor');
                            break;
                        case "Vehicle Cleaning-Incomplete" :
                            component.set("v.VehicleCleaningColor",'slds-item RedColor');
                            break;
                        case "Vehicle Cleaning-Under Review" :
                            component.set("v.VehicleCleaningColor",'slds-item OrangeColor');
                            break;
                        case "Vehicle Maintenance-Incomplete" :
                            component.set("v.VehicleMaintenanceColor",'slds-item RedColor');
                            break;
                        case "Vehicle Maintenance-Under Review" :
                            component.set("v.VehicleMaintenanceColor",'slds-item OrangeColor');
                            break;
                         case "Reception or Lobby-Incomplete" :
                            component.set("v.ReceptionOrLobby",'slds-item RedColor');
                            break;
                        case "Reception or Lobby-Under Review" :
                            component.set("v.ReceptionOrLobby",'slds-item OrangeColor');
                            break;
                      
            
                    }
                    console.log(dataArray[item].Line_Item_Type__c);
                }
            component.set("v.loaded",false);//loading stop    
            } else {
                console.log("Failed with state: " + state);
            }
        });
        
        $A.enqueueAction(action);
    }
})