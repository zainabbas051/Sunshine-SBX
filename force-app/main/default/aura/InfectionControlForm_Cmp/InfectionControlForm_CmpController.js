({
    defaultAction : function(component, event, helper) {

        helper.getPickListValues(component,"Check_All_That_Apply__c","v.checkAllOptions");
        component.set('v.showLoading',true);  
        helper.getPickListValues(component,"Level_One_Incident_Type__c","v.levelOneOptions");
        component.set('v.showLoading',true);  
        helper.getPickListValues(component,"Level_Two_Incident_Type__c","v.levelTwoOptions");
        component.set('v.showLoading',true);  
        helper.getPickListValues(component,"Level_Three_Incident_Type__c","v.levelThreeOptions");

        var opts = [
            { value: "Observed by Writer", label: "Observed by Writer" },
            { value: "Reported to Writer", label: "Reported to Writer" },
        ];
        component.set('v.incidentList',opts);
        debugger;
        if(component.get("v.RecordId") != undefined){
            helper.getRecordDetails(component);
            component.set("v.disabled",true);
        }
      
    },
    levelOneHandleChange : function(component,event,helper){

        component.set('v.levelOneOther',false);
        var changeValue = event.getParam("value");
        if(changeValue.indexOf('Other') > -1){
            component.set('v.levelOneOther',true);
        }
       
    },
    levelTwoHandleChange : function(component,event,helper){

        component.set('v.levelTwoOther',false);
        var changeValue = event.getParam("value");
        if(changeValue.indexOf('Other') > -1){
            component.set('v.levelTwoOther',true);
        }
       
    },
    levelThreeHandleChange : function(component,event,helper){

        component.set('v.levelThreeOther',false);
        var changeValue = event.getParam("value");
        if(changeValue.indexOf('Other') > -1){
            component.set('v.levelThreeOther',true);
        }   
    },
    incidentHandleChange : function(component,event,helper){
        var changeValue = event.getParam("value");
        if(changeValue == 'Observed by Writer'){
            component.set("v.incidentObj.Observed_by_Writer__c",true);
        }
        if(changeValue == 'Reported to Writer'){
            component.set("v.incidentObj.Reported_to_Writer__c",true);
        }
    },

    saveInc : function(component,event,helper){

        var allValid = component.find('field').reduce(function (validSoFar, inputCmp) {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);

        var multiCheckbox = component.find("mygroup");
        var multiCheckboxValue = '';
        for(var i = 0 ; i < multiCheckbox.length; i++){
            multiCheckboxValue += multiCheckbox[i].get("v.value");
        }
        if(multiCheckboxValue == ''){
            component.find('notifLib').showToast({
                "title": "Error!",
                "message": "Please select anyone of the Level",
                "variant": "Error"
            });
            return;
        }
       
        if(allValid){
            helper.saveIncident(component);
        }
    },

    cancelForm  : function(component,event,helper){
        component.set('v.showForm',false);
       var pageURL=  decodeURIComponent(window.location);
        if(pageURL.search("certificationportalincident")>-1)
        {
            component.set('v.returntoMain',true);
          
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          'url': pageURL
        });
        urlEvent.fire();
        }    },

    navigate : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
         urlEvent.setParams({
           'url': '../apex/IncidentReportPDF_HTML?id=' + component.get('v.RecordId')
         });
         urlEvent.fire();
       }
    
})