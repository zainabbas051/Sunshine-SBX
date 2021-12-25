({
    getPickListValues : function(component,fieldApi,attributeName) {

        debugger;
        var action = component.get("c.getPickListValues");
        //Setting the Apex Parameter
		action.setParams({
			fieldApiName: fieldApi
        });
        
        action.setCallback(this, function (a) {
            var state = a.getState();
            if(state == 'SUCCESS'){
                var pickListValues = a.getReturnValue();
                var opts=[];
                for(var i=0;i< pickListValues.length;i++){
                    opts.push({label: pickListValues[i], value: pickListValues[i]});
                }
                component.set(attributeName,opts);
                component.set('v.showLoading',false);  
            }
        });
        //adds the server-side action to the queue        
		$A.enqueueAction(action);
    },
    saveIncident : function(component){

        var action = component.get("c.saveIncident");
        var incidentObj = component.get('v.incidentObj');
        incidentObj.Level_One_Incident_Type__c = component.get('v.levelOneSelected');
        incidentObj.Level_Two_Incident_Type__c = component.get('v.levelTwoSelected');
        incidentObj.Level_Three_Incident_Type__c = component.get('v.levelThreeSelected');
        incidentObj.Check_All_That_Apply__c = component.get('v.checkAllSelected');
        incidentObj.Sunshine_Center__c = component.get('v.selectedSunShineCentre');
        //Setting the Apex Parameter
		action.setParams({
            //incJsonStr: JSON.stringify(incidentObj)
            incJsonStr: incidentObj
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if(state == 'SUCCESS'){
                component.find('notifLib').showToast({
                    "title": "Success!",
                    "message": "Record has been updated Successfully",
                    "variant": "Success"
                });
                component.set('v.showForm',false);
            }
        });
        //adds the server-side action to the queue        
		$A.enqueueAction(action);
    },
    getRecordDetails : function(component){

        var action = component.get("c.getIncidentById");
        action.setParams({
            recordId: component.get('v.RecordId')
        });
        action.setCallback(this, function (a) {
            debugger;
            var state = a.getState();
            if(state == 'SUCCESS'){
                var splitArrays = [];
                var incidentObj = a.getReturnValue();
                component.set("v.incidentObj",incidentObj);
                debugger;
                var sunshineCentre = incidentObj.Sunshine_Center_Name__c
                component.set('v.selectedSunShineCentre',sunshineCentre);
                splitArrays = incidentObj.Level_One_Incident_Type__c.split(';');
                component.set('v.levelOneSelected',splitArrays);
                splitArrays = incidentObj.Level_Two_Incident_Type__c.split(';');
                component.set('v.levelTwoSelected',splitArrays);
                splitArrays = incidentObj.Level_Three_Incident_Type__c.split(';');
                component.set('v.levelThreeSelected',splitArrays);
                splitArrays = incidentObj.Check_All_That_Apply__c.split(';');
                component.set('v.checkAllSelected',splitArrays);
                component.set('v.showLoading',false);            
            }
        });

        //adds the server-side action to the queue        
		$A.enqueueAction(action);
    }
})