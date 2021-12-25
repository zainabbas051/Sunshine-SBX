({
    fetchData : function(component) {
        var action = component.get("c.getTasksByHouseLineItem");
        var HLIId = component.get("v.selectedHouseLineItem");
        action.setParams({  hliId : HLIId  });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                var dataLst = response.getReturnValue();
                var AccessType = component.get("v.AccessType");
                
                if(AccessType == 'Supervisor'){
                    for(var i in dataLst){
                        var dataObj = dataLst[i];
                        if(dataObj.Related_House_Line_Item__r.Status__c != 'Completed'){
                            dataObj.Supervisor_Status_chkb__c = true;
                        }
                    }
                }
                
                component.set("v.data", dataLst);
                component.set("v.loaded",false);//loading start 
                this.checkCompleteButton(component);
            } else {
                console.log("Failed with state: " + state);
            }
        });
        
        $A.enqueueAction(action);
    },
    fetchTask : function(component){
        var action = component.get("c.getTasksByHouse");
        var HLIId = component.get("v.selectedHouse");
        var HouseLineItemType = component.get("v.HouseLineItemType");
        var viewType = component.get("v.viewType");
        debugger;
        action.setParams({  hliId : HLIId , HouseLineItemType : HouseLineItemType, viewType : viewType  });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                var dataLst = response.getReturnValue();
                var AccessType = component.get("v.AccessType");
                
                if(AccessType == 'Supervisor'){
                    for(var i in dataLst){
                        var dataObj = dataLst[i];
                        if(dataObj.Related_House_Line_Item__r.Status__c != 'Completed'){
                            dataObj.Supervisor_Status_chkb__c = true;
                        }
                    }
                }
                
                component.set("v.data", dataLst);
                component.set("v.loaded",false);//loading start 
            } else {
                console.log("Failed with state: " + state);
            }
        });
        
        $A.enqueueAction(action);
    },
    saveActivityRecords : function(component){

        debugger;
       // let lines = [];
        //lines = component.find('linesTable').getSelectedRows();
        component.set("v.loaded",true);//loading start 
        var data = component.get("v.data");
        var activitylist = JSON.stringify(data);
        var AccessType = component.get("v.AccessType");
       
        var action = component.get("c.saveActivityListRecord");
        action.setParams({ activityList : activitylist });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.loaded",false);//loading start 
            if(component.isValid() && state === "SUCCESS") {
                if(response.getReturnValue() == 'Success'){
                   // showToastMessage('success','Success!','Record has been updated Successfully');
                   component.find('notifLib').showToast({
                    "variant": "success",
                    "header": "Success!",
                    "message": "Record has been updated Successfully"
                    });
                 this.checkCompleteButton(component);
                  
                    // fire event to return back to the main screen
                    //creating event from child to Parent
                    //this event is captured by CmpCheckList
                /*  var cmpEvent = component.getEvent("GoBackEvent");
                    cmpEvent.setParams({
                        "screen" : 'Main'
                                });
                    cmpEvent.fire();*/
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
        var hli=data[0]["Related_House_Line_Item__c"];
        var selectedHouseLineItem=component.get("v.selectedHouseLineItem");
        action.setParams({ hli : hli,activityList : activitylist,completedBy : component.get("v.completedBy"), reviewedBy : component.get("v.ReviewedBy"), AccessType :AccessType });
        
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
                    //this event is captured by CmpCheckList
                    var cmpEvent = component.getEvent("GoBackEvent");
                    cmpEvent.setParams({
                        "screen" : 'Main'
                                });
                    cmpEvent.fire();
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
        component.set('v.isCompleted',false);
        var data = component.get('v.data');
        var accessType = component.get("v.AccessType");
        if(accessType == 'BHT'){
            for(var i in data){
                if(data[i].BHT_Status__c == false){
                    //totalCount ++;
                    component.set('v.isCompleted',true);
                    break;
                }
            }    
        }
    }
})