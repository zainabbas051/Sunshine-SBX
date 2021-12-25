({
    
   

    getColumn : function(component) {

        var actions = [
           
            
        ];
        
        component.set('v.columns', [
			
            {label: 'Certification Name', fieldName: 'Certification_Name__c', type: 'text'},
            {label: 'Status', fieldName: 'Status__c', type: 'text',initialwidth:95},
         
            {label: 'Notes', fieldName: 'Approved_Denied_Noted__c', type: 'text'},
     
           
        	
        ]);
    },

    getData : function(component,helper){
       debugger;
        var empID=component.get("v.empID");
        var action = component.get("c.GetRejectedCertification");
        action.setParams({ empID : empID });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                debugger;
                var resultData = response.getReturnValue();
                component.set("v.data", resultData);
            }
        });
        $A.enqueueAction(action);
    }
})