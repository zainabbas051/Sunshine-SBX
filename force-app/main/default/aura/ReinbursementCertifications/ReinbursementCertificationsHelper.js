({
    
   

    getColumn : function(component) {

        var actions = [
           
            
        ];
        
        component.set('v.columns', [
			
            {label: 'Certification Name', fieldName: 'Certification_Name__c', type: 'text'},
            {label: 'Status', fieldName: 'Reimbursement_Request_Status__c', type: 'text',initialwidth:95},
            {label: 'Sumbitted Date', fieldName: 'Reimbursement_Request_Submit_Date__c', type: 'text',initialwidth:95},
            {label: 'Pay out Date', fieldName: 'Reimbursement_Request_Payout_Date__c', type: 'date' , typeAttributes: { month: '2-digit', day: '2-digit', year : "numeric"}},
            
     
           
        	
        ]);
    },

    getData : function(component,helper){
       debugger;
        var empID=component.get("v.empID");
        var action = component.get("c.GetReinbursementCertification");
        action.setParams({ empID : empID });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                component.set("v.data", resultData);
            }
        });
        $A.enqueueAction(action);
    }
})