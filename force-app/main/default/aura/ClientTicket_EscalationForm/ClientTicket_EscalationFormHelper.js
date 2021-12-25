({
    getEmployeeSuperVisor : function(component) {
        
        debugger;
        var action = component.get("c.getEmployeeDetail");
        var empId  =   component.get('v.empId');
        action.setParams({
            employeeId : empId
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if(state == 'SUCCESS'){
                var supervisorLst = [];
                var supervisorMap  = a.getReturnValue();
                for(var key in supervisorMap){
                    supervisorLst.push({value:supervisorMap[key], key:key});
                    component.set('v.submitBtn',false);      
                }
                component.set('v.supervisors',supervisorLst);      
            }
        });
        //adds the server-side action to the queue        
        $A.enqueueAction(action);
    },
    submitEscalation : function(component){
        
        var action = component.get("c.escalateCase");
        var caseObj  =   component.get('v.caseObj');
        caseObj.Escalated__c = true;
        var supervisorLst = component.get('v.supervisors');
        component.set('v.managerName',supervisorLst.find(key => caseObj.Escalated_To__c).value);
        component.set('v.caseObj',caseObj);
        action.setParams({
            caseObj : caseObj
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if(state == 'SUCCESS'){
                component.find('notifLib').showToast({
                    "title": "Success!",
                    "variant" : "success",
                    "message": "Case has been Escalated."
                });
                component.set('v.escalatePopUp',false);
            }
        });
        //adds the server-side action to the queue        
        $A.enqueueAction(action);
    }
})