({
   

    updateEmployeeData : function(component,helper){
        var employeeData = component.get("v.EmployeeSelected");
        employeeData.Employee_Last_Annual_Performance__c = component.get("v.defaultRaiting");
        var action = component.get("c.updateEmployee");
        action.setParams({ "selectedEmpObj" : employeeData});
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.find('notifLib').showToast({
                    "title": "Success!",
                    "variant" : "success",
                    "message": "The record has been updated successfully."
                });
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    
    
 /*   CreateTrainings : function(component){
        
        
        debugger;
        var SupervisorId = component.get("v.empID");
        var Trainings = JSON.stringify(component.get("v.SelectedTrainingdata"));
        var Employees = JSON.stringify(component.get("v.SelectedEmployeedata"));
        var dateOfTraining =component.find("DoT").get("v.value");
        var locationOfTraining =component.find("LoT").get("v.value");
        var action = component.get("c.createMandatoryCertifications");
       // var row = component.get('v.selectedRow');
        action.setParams({ empList : Employees,
                         certList : Trainings,
                         supervisorId : SupervisorId,
                         trainingDate : dateOfTraining,
        				location:locationOfTraining});
        action.setCallback(this,function(response) {
           
            var state = response.getState();
            if (state === "SUCCESS") {
                
              
                try {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title: 'Success',
                            message: 'The Bulk Training Program has been created ',
                            duration: ' 5000',
                            key: 'info_alt',
                            type: 'success',
                            mode: 'pester'
                        });
                        toastEvent.fire();
                        
                      	
                      
                    }
                
                    catch (err) {
                        alert('The Certification request has been created');
                    }
               
                
            }
        });
        $A.enqueueAction(action);
    }*/
    
	
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
			
            {label: 'Employee Name', fieldName: 'Name__c', type: 'text'},
            {label: 'Employement Start Date', fieldName: 'Employment_Start_Date__c', type: 'date'}        	
        ]);
    },
    
    
   

    getEmployeeData : function(component,helper){
       debugger;
		var empID = component.get("v.empID");
        var action = component.get("c.getTeir2Employees");
        action.setParams({ superVisorId : empID });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                component.set("v.Employeedata", resultData);
            }
        });
        $A.enqueueAction(action);
    },

})