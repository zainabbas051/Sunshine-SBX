({
    saveComments : function(component){

        debugger;
        var action = component.get("c.addComments");
        var caseId  =   component.get('v.RecordId');
        var empId = component.get('v.empId');
        var caseComments  =   component.get('v.caseComments');
        action.setParams({
            recordId : caseId,
            comments : caseComments,
            employeeId : empId
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if(state == 'SUCCESS'){ 
                component.set('v.caseComments','');
                this.getAllComments(component);   
            }
        });
        //adds the server-side action to the queue        
        $A.enqueueAction(action);
    },

    getAllComments : function(component){
        debugger;
        var action = component.get("c.getAllCaseComments");
        var caseId  =   component.get('v.RecordId');
        action.setParams({
            recordId : caseId
        });
        action.setCallback(this, function (a) {
            var state = a.getState();
            if(state == 'SUCCESS'){
                var listComments = a.getReturnValue();
                component.set('v.listComments',listComments);    
            }
        });
        //adds the server-side action to the queue        
        $A.enqueueAction(action);
    }
})