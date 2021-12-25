({
    
   getenableRequestBtn : function(component){
       
        var empID=component.get("v.empID");
        var action = component.get("c.getEnableRequestBtn");
        action.setParams({ empID : empID });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var btnStatus = response.getReturnValue();
                component.set("v.enableRequestBtn", btnStatus);
            }
        });
        $A.enqueueAction(action);
    },

    getColumn : function(component) {

        var actions = [
           
            
        ];
        
        component.set('v.columns', [
			
            {label: 'Certification Name', fieldName: 'Certification_Name__c', type: 'text'},
            {label: 'Status', fieldName: 'Status__c', type: 'text'},
            {label: 'Requested Date', fieldName: 'Date_Requested__c', type: 'date' , typeAttributes: { month: '2-digit', day: '2-digit', year : "numeric"}} ,
		
            
            
            {
                type:  'button',
                typeAttributes: 
                {
                  iconName: 'utility:clear',
                  label: 'Cancel Request', 
                  name: 'deleteRecord', 
                  title: 'cancelRequest', 

                }
              }
           
        	
        ]);
    },

    getData : function(component,helper){
      
        debugger;
        var empID=component.get("v.empID");
        var action = component.get("c.GetApplaiedCertification");
        action.setParams({ empID : empID });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
              
                component.set("v.data", resultData);
               /* if(resultData.length==0)
                    component.set("v.enableRequestBtn", true);
                else
					component.set("v.enableRequestBtn", false);  
                */
                
                component.set("v.enableRequestBtn", true);  
            }
        });
        $A.enqueueAction(action);
    },
    cancelCertificationRequest : function(component,helper,row,event){
      
        //var empID=component.get("v.empID");
        var certID=component.get("v.certificationId");
        var action = component.get("c.cancelCertificationRequest");
        action.setParams({ certificationRequestID : certID});
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var rows = component.get('v.data');
                var rowIndex = rows.indexOf(row);
                rows.splice(rowIndex, 1);
                component.set('v.data', rows);
                var cmpEventBudget = component.getEvent("UpdateEmpBudget");
                cmpEventBudget.fire();
				var evt = $A.get("e.c:UpdateAvailableCertifications");
                evt.setParams({ "Update": true});
                evt.fire();                
                try {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title: 'Success',
                            message: 'The Certification request has been cancelled',
                            duration: ' 5000',
                            key: 'info_alt',
                            type: 'success',
                            mode: 'pester'
                        });
                        toastEvent.fire();
                    this.getData(component,this);
                    }
                    catch (err) {
                        alert('The Certification request has been cancelled');
                    }
     
                          
                
        
            }
        });
        $A.enqueueAction(action);
        
    }
})