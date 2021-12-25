({
   

    updateEmployeeData : function(component,helper){
        var employeeData = component.get("v.EmployeeSelected");
        employeeData.Employee_Last_Annual_Performance__c = component.get("v.defaultRaiting");
        var action = component.get("c.updateEmployee");
        action.setParams({ "selectedEmpObj" : employeeData});
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               // var onclick = component.get("v.onclick");
    			// onclick.fire();
                
                component.find('notifLib').showToast({
                    "title": "Success!",
                    "variant" : "success",
                    "message": "The record has been updated successfully."
                });
                var cmpEvent = component.getEvent("cmpRefreshEvent");
				cmpEvent.fire();
                component.set('v.isTierTransitionEnabled',false);
                component.set('v.isTier3TransitionEnabled',false);
            }
        });
        $A.enqueueAction(action);
    },
    
    
    
 
	
    toggleOneAndTwoSteps : function(component) {
		var stepOne = component.find("stepOne");
        $A.util.toggleClass(stepOne, 'slds-hide');
        var stepTwo = component.find("stepTwo");
        $A.util.toggleClass(stepTwo, 'slds-hide');
	},
    toggleTwoAndThreeSteps : function(component) {
		
        var stepTwo = component.find("stepTwo");
        $A.util.toggleClass(stepTwo, 'slds-hide');
        var stepThree = component.find("stepThree");
        $A.util.toggleClass(stepThree, 'slds-hide');
	},
    toggleTwoSteps : function(component){
        var stepTwo = component.find("stepTwo");
        $A.util.toggleClass(stepTwo, 'slds-hide');
        
    },
	toggleThreeSteps : function(component){
        var stepThree = component.find("stepThree");
        $A.util.toggleClass(stepThree, 'slds-hide');
        
    },

    
         getEmployeeColumn : function(component) {


        component.set('v.Employeecolumns', [
			
            {label: 'Name', fieldName: 'Name__c', type: 'text'},
            {label: 'Current Tier', fieldName: 'Tier_Allocation__c', type: 'text'},
            {label: 'Role', fieldName: 'User_Role__c', type: 'text'}
                	
        ]);
    },
    
    
   

    getEmployeeData : function(component,helper){
       debugger;
        var empID = component.get("v.empID");
        var isTier2 = component.get("v.isTierTransitionEnabled");
        var isTier3 = component.get("v.isTier3TransitionEnabled");
        var action;
        if(isTier2){
            action = component.get("c.getTeir2Employees");
        }
        if(isTier3){
            action = component.get("c.getTeir3Employees");
        }
       
        action.setParams({ superVisorId : empID });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                component.set("v.Employeedata", resultData);
                
            }
        });
        $A.enqueueAction(action);
    }

})