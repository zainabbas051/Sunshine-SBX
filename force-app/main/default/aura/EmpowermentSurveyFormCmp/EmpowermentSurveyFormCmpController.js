({
    save : function(component, event, helper) {
            
            debugger;
        	
            let validExpense = component.find('empowermentForm').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if(validExpense){
             let newExpense = component.get("v.empowerObj");
            console.log("Create expense: " + JSON.stringify(newExpense));
             helper.saveEmpowerment(component);
        }
         
		  
    }
})