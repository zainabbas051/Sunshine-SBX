({
    CreateTrainings : function(component,helper){
       debugger;
		var SupervisorId = component.get("v.empID");
        var Trainings = JSON.stringify(component.get("v.SelectedTrainingdata"));
        var Employees = JSON.stringify(component.get("v.SelectedEmployeedata"));
        var dateOfTraining =component.find("DoT").get("v.value");
        var locationOfTraining =component.find("LoT").get("v.value");
        var notes = component.find("notesA").get("v.value");
        var action = component.get("c.createMandatoryCertifications");
        action.setParams({ "empList" : Employees,
                          "certList" : Trainings,
                          "supervisorId" : SupervisorId,
                          "trainingDate" : dateOfTraining,
                          "location" : locationOfTraining,
                          "Notes" : notes
                         });
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
                        
                      	component.set('v.isBulkAdd',false);
                  $A.get('e.force:refreshView').fire();
                      
                    }
                
                    catch (err) {
                        alert('The Bulk Training Program has been created ');
                    }
               
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

    getTrainingColumn : function(component) {


        component.set('v.Trainingcolumns', [
			
            {label: 'Certification Name', fieldName: 'Name', type: 'text'},
            {label: 'Certification Cost', fieldName: 'Certification_Cost__c', type: 'text'}        	
        ]);
    },
         getEmployeeColumn : function(component) {


        component.set('v.Employeecolumns', [
			
            {label: 'Employee Name', fieldName: 'Name__c', type: 'text'},
            {label: 'Designation', fieldName: 'Designation__c', type: 'text'}        	
        ]);
    },
    
    
    getTrainingData : function(component,helper){
       debugger;

        var action = component.get("c.GetAllCertification");
        
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                component.set("v.Trainingdata", resultData);
            }
        });
        $A.enqueueAction(action);
    },

    getEmployeeData : function(component,helper){
       debugger;
		var empID = component.get("v.empID");
        var action = component.get("c.GetReportingEmployees");
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