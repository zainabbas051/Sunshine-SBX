({    
    chargeCard: function(component, payment,Invoice) {
        console.log('InvoiceId from array::'+Invoice[0][0].Id);
        var environment = component.get('v.environmentType');
        /*var InvoiceId = component.get("v.recordId");
        if(InvoiceId == null)
            InvoiceId = location.search.split('InvoiceId=')[1];*/
        var InvoiceId = Invoice[0][0].Id;
        console.log("InvoiceId="+InvoiceId);
        var action = component.get("c.callPaymentMethod");
        action.setParams({
            "amount": '' + payment.amount,
            "holderName": '' + payment.holderName,
            "card" : '' + payment.card,
            "cvv": '' + payment.cvv,
            "year": '' + payment.year,
            "month": '' + payment.month,
            "curr" : '' + payment.currencyval,
            "description": "Payment for Invoice :" + component.get("v.invoiceNumber"),
            "email": component.get("v.contactEmail"),
            "notes": payment.notes,
            "invoiceId" : InvoiceId,
            //"description": "Payment for Invoice :" + component.get("v.recordId"),
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {

                console.log("From server: " + response.getReturnValue());
                
                if(response.getReturnValue() == "SUCCESS"){
                    //console.log(Invoice.Id);
                    //Updating Invoice Status to PAID
                    //this.updateInvoice(component,InvoiceId);
                    
                    //Redirecting to Thankyou page if opened under community
                    if (environment == 'Community') {
                        console.log("thanksPg:");
                        //window.open(thanksPg,'_self');
                        
                        
                    }else{
                        // Prepare a toast UI message
                        var resultsToast = $A.get("e.force:showToast");
                        resultsToast.setParams({
                            "title": "Payment has been made Successfully",
                            "message": "Invoice has been updated",
                            "type": "success",
                        });
                        // Update the UI: close panel, show toast, refresh account page
                        $A.get("e.force:closeQuickAction").fire();
                        resultsToast.fire();
                        $A.get("e.force:refreshView").fire();
                    }
                } else {
                    console.log('Showing error');

                	//result.push(response.getReturnValue().toString());
                	component.set("v.result", response.getReturnValue().toString());  
                    
                    console.log(component.get("v.result"));
                }
            } else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                console.log("From server: " + response.getReturnValue());
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        component.set("v.result", errors[0].message);  
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    updateInvoice: function(component, InvoiceId) {
        var action = component.get("c.updateInvoice");
        //var InvoiceId = component.get("v.recordId");
        action.setParams({
            "invoiceId": InvoiceId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS") {
				//console.log()
            } else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    bringExistingCard: function(component, selValue){
        console.log('*selValue :'+selValue );
        var recId = component.get("v.recordId");
        var action = component.get("c.returnSelectedCard");
        action.setParams({
            "cardNum" : selValue,
            "OppId" : recId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                console.log(response.getReturnValue());
                var jsonResp = JSON.parse(response.getReturnValue()); 

                component.set("v.payment.holderName", jsonResp.CardHolderName);
                component.set("v.payment.card", jsonResp.CardNumber);
                component.set("v.payment.month", jsonResp.ExpMonth);
                component.set("v.payment.year", jsonResp.ExpYear);
                component.set("v.payment.cvv", jsonResp.CVV);

            }
            else if(state === "ERROR")
            {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        component.set("v.result", errors[0].message);  
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    validateAmount: function(component, amount){
        
        var valid = false;
        var invAmount = parseFloat(amount);
        var dueAmount = parseFloat(component.get("v.budgetAmount"));

        if(invAmount && invAmount != 0 && invAmount >= dueAmount){
            if(invAmount % 50 != 0)
            {
                valid = false;
            }
            else
            {
                valid = true;
            }
        }
        return valid;
    },

})