({
   
    fetchData : function(component) {
        var action = component.get("c.getMaintenanceTaskByHouseId");
        var HLIId = component.get("v.selectedHouse");
        var taskType = component.get("v.maintenanceType");
        var dateFilter = component.get("v.selectedDate");
        var yearFilter = component.get("v.selectedYear");
        action.setParams({  houseId : HLIId ,  taskType :  taskType , dateFilter : dateFilter , yearFilter : yearFilter});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                var dataLst = response.getReturnValue();   
                component.set("v.data", dataLst);
                component.set("v.loaded",false);//loading start 
                //this.checkCompleteButton(component);
            } else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
   
    completeHouseLineItemRecord : function(component){

        debugger;
       // let lines = [];
        //lines = component.find('linesTable').getSelectedRows();
        component.set("v.loaded",true);//loading start 
       // var activitylist = JSON.stringify(component.get("v.data"));
        var action = component.get("c.completeHouselineItem");
         var data = component.get("v.data");
        var AccessType = component.get("v.AccessType");
        var activitylist = JSON.stringify(data);
        var hli= component.get("v.selectedHouse");
        action.setParams({activityList : activitylist,completedBy : component.get("v.completedBy"), reviewedBy : component.get("v.ReviewedBy"), AccessType :AccessType });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                if(response.getReturnValue() == 'Success'){
                   // showToastMessage('success','Success!','Record has been updated Successfully');
                   component.find('notifLib').showToast({
                    "variant": "success",
                    "header": "Success!",
                    "message": "Record has been updated Successfully"
                    });
                    // fire event to return back to the main screen
                    //creating event from child to Parent
                    //this event is captured by CmpMaintenanceCheckList
                 //   var cmpEvent = component.getEvent("GoBackEvent");
                  //  cmpEvent.setParams({
                    //    "screen" : 'House Grid'
                    //            });
                   // cmpEvent.fire();
                    component.set("v.showModal",false);
                     component.set("v.loaded",false);//loading start 
                    
                    
                }
                else{
                    component.find('notifLib').showToast({
                        "variant": "error",
                        "header": "Something has gone wrong!",
                        "message": "Unfortunately, there was a problem updating the record."
                        });
                        component.set("v.loaded",false);//loading start 
                   
                }
            } else {
                console.log("Failed with state: " + state);
            }
        });
        
        $A.enqueueAction(action);
    },
    checkCompleteButton : function(component){
        debugger;
        var data = component.get('v.data');
        var accessType = component.get("v.AccessType");
        if(accessType == 'BHT'){
            for(var i in data){
                if(data[i].BHT_Status__c == false){
                    //totalCount ++;
                    component.set('v.isCompleted',false);
                    break;
                }
            }    
        }
        if(accessType == 'Supervisor'){
            for(var i in data){
                if(data[i].Supervisor_Status__c == false){
                    //totalCount ++;
                    component.set('v.isCompleted',false);
                    break;
                }
            }    
        }
    }
})