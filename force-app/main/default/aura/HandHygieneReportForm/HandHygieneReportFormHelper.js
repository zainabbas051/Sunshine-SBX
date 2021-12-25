({

    saveHandHygineReport : function(component){
		debugger;
        var action = component.get("c.saveHandHygiene");
        var handHygieneObj = component.get('v.handHygieneObj');
        handHygieneObj.Sunshine_Center__c = component.get('v.selectedSunShineCentre');
        // infectionObj.Sunshine_Center__c = 'Monarch Shores';
        //Setting the Apex Parameter
		action.setParams({
            //incJsonStr: JSON.stringify(incidentObj)
            incJsonStr: handHygieneObj
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if(state == 'SUCCESS'){
                component.find('notifLib').showToast({
                    "title": "Success!",
                    "message": "Report has been created Successfully",
                    "variant": "Success"
                });
                component.set('v.showForm',false);
                component.set("v.disabled",true);
                
            }
        });
        //adds the server-side action to the queue        
		$A.enqueueAction(action);
    },
    getRecordDetails : function(component){

        var action = component.get("c.getHandHygieneReportById");
        action.setParams({
            recordId: component.get('v.RecordId')
        });
        action.setCallback(this, function (a) {
            debugger;
            var state = a.getState();
            if(state == 'SUCCESS'){
                var splitArrays = [];
                var handHygieneObj = a.getReturnValue();
                component.set("v.handHygieneObj",handHygieneObj);
                debugger;
                var sunshineCentre = handHygieneObj.Sunshine_Center_Name__c;
                
                component.set('v.selectedSunShineCentre',sunshineCentre);
           
                
                component.set('v.showLoading',false);            
            }
        });

        //adds the server-side action to the queue        
		$A.enqueueAction(action);
    }
})