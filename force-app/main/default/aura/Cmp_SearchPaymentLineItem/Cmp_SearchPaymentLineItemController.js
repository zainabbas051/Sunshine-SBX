({
	findCash : function(component, event, helper) {
		
        debugger;
        
       /* var inputCmp = component.find("ReferenceId");
        var value = inputCmp.get("v.value");
        // is input numeric?
        if (value == '') {
            inputCmp.setCustomValidity("This field is required");
        } else {
            helper.findCashFromServer(component);
        } */
        helper.findCashFromServer(component);
       // inputCmp.reportValidity();
        
	}
})