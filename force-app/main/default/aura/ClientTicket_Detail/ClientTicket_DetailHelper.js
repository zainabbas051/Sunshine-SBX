({
    readUrl : function(component){
        debugger;
        var sPageURL = decodeURIComponent(window.location.search.substring(1)); //You get the whole decoded URL of the page.
        var sURLVariables = sPageURL.split('&'); //Split by & so that you get the key value pairs separately in a list
        var sParameterName;
        var i;
 
        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('='); //to split the key from the value.
 
            if (sParameterName[0] === 'Id') { //lets say you are looking for param name - firstName
                sParameterName[1] === undefined ? 'Not found' : sParameterName[1];
                component.set('v.RecordId',sParameterName[1]);
                continue;
            }
            if (sParameterName[0] === 'empId') { //lets say you are looking for param name - firstName
                sParameterName[1] === undefined ? 'Not found' : sParameterName[1];
                component.set('v.empId',sParameterName[1]);
                //component.set('v.disabled',false);
                continue;
            }
        }
    },
    getRecordDetail : function(component){
        var action = component.get("c.getCaseDetail");
        var caseId  =   component.get('v.RecordId');
        action.setParams({
            recordId : caseId
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if(state == 'SUCCESS'){
                var caseObj = a.getReturnValue();
                if(caseObj.Escalated_To__r != undefined){
                    managerName = caseObj.Escalated_To__r.Name
                    component.set('v.managerName',managerName);
                }      
                component.set('v.caseObj',caseObj);
                this.getDept(component);
                component.set('v.showLoading',false);              
            }
        });
        //adds the server-side action to the queue        
        $A.enqueueAction(action);
    },
    updateTicketInfo : function(component,event,helper){
        

        var caseObj = component.get('v.caseObj');
        var action = component.get("c.updateTicketInfo");
        action.setParams({"caseObj" : caseObj});
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {

                component.find('notifLib').showToast({
                              "title": "Success!",
                              "message": 'Record Updated',
                              "variant" : "Success"
                 });
                 component.set('v.disabled',true);

            }
        });
        $A.enqueueAction(action);
    },
    deptChangeHelper : function(component){

        var selectedDept = component.find('department').get('v.value');
        var caseObj = component.get('v.caseObj'); 
        var sunShineCentreName = caseObj.Ticket_Owner__r.Sunshine_Center_Relation_To__r.Name;
        var action = component.get("c.getSpecificQueryPickList");
        
        action.setParams({
            "sunShineCentre" : sunShineCentreName,
            "deptName" : selectedDept
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var subCategories = [];
                var subCategoryMap  = response.getReturnValue();
                for(var key in subCategoryMap){
                    subCategories.push({value:subCategoryMap[key], key:key});     
                }
                component.set('v.subCategories',subCategories);
            }
        });
        $A.enqueueAction(action);
    },
    getDept : function(component){

        var caseObj = component.get('v.caseObj'); 
        var sunShineCentreName = caseObj.Ticket_Owner__r.Sunshine_Center_Relation_To__r.Name;
        var action = component.get("c.getDeptPickList");
        
        action.setParams({
            "sunShineCentre" : sunShineCentreName,
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var depts = [];
                var deptMap  = response.getReturnValue(); 
                for(var key in deptMap){
                    depts.push({value:deptMap[key], key:key});     
                }
                component.set('v.departments',depts);
                this.deptChangeHelper(component);
            }
        });
        $A.enqueueAction(action);
    }
})