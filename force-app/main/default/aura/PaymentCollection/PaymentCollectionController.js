({
    
    doInit1: function(component, event, helper){
        console.log('IN');
        var recId = component.get("v.recordId");
        var action = component.get("c.returnPaymentData");
        console.log('recID='+recId);
        action.setParams({
            "OppId" : recId,
        });

        action.setCallback(this, function(response){
            console.log('Response::'+JSON.stringify(response.getReturnValue()));
            var state = response.getState();
            console.log(state);
            if(state === "SUCCESS"){
                
                console.log("From server: " + JSON.stringify(response.getReturnValue()));
                console.log(response.getReturnValue());
                component.set("v.NonpaidStatus", true);
                
                var jsonResp = JSON.parse(response.getReturnValue());
                console.log('Amount = '+jsonResp.TotalAmount);
                console.log('Opp = '+jsonResp.ClientName);
                console.log('ListCards = '+jsonResp.ListCards);
                component.set("v.budgetAmount", jsonResp.TotalAmount);
                
                component.set("v.payment.amount", jsonResp.TotalAmount);
                component.set("v.payment.oppName", jsonResp.ClientName);
                component.set("v.AddedCards", jsonResp.ListCards);
                
                /*component.set("v.payment.holderName", jsonResp.CardHolderName);
                component.set("v.payment.card", jsonResp.CardNumber);
                component.set("v.payment.month", jsonResp.ExpMonth);
                component.set("v.payment.year", jsonResp.ExpYear);
                component.set("v.payment.cvv", jsonResp.CVV);*/
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
    
    onChange: function (component, event, helper) {
        var selPickListValue = event.getSource().get("v.value");
        console.log('*selPickListValue :'+selPickListValue );

        if(selPickListValue != 'Enter New Card')
        {
            console.log('*selval inside :'+selPickListValue );
            helper.bringExistingCard(component, selPickListValue);
        }
        else
        {
            component.set("v.payment.holderName", null);
            component.set("v.payment.card", null);
            component.set("v.payment.month", null);
            component.set("v.payment.year", null);
            component.set("v.payment.cvv", null);
        }
        
    },

    

    cardHide: function(component, event, helper) {
        let hideNum = [];
          for(let i = 0; i < card.length; i++){
          if(i < card.length-4){
            hideNum.push("*");
          }else{
            hideNum.push(card[i]);
          }
        }
        return hideNum.join("");
    },

    submitPayment: function(component, event, helper){

        var validExpense = component.find('expenseform').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        
        var amount = component.get("v.payment.amount");

        var valid = helper.validateAmount(component,amount);

        if(valid != true){
            // Prepare a toast UI message
            var resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                "title": "Amount shouldn't be less than Remaining Due",
                "message": "Please add amount greater or equal to remaining budget in mutiples of 50",
                "type": "error",
            });
            // Update the UI: close panel, show toast, refresh account page
            $A.get("e.force:closeQuickAction").fire();
            resultsToast.fire();
            $A.get("e.force:refreshView").fire();
        }
        else if(valid == true && validExpense == true)
        {
            console.log('Payment Please');
        }


    },

    clickCreate: function(component, event, helper) {
        var validExpense = component.find('expenseform').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        
        var validBalAmount = true;
        // If Amount is greater than Budget Amount
        var invAmount = parseFloat(component.get("v.paymment.amount"));
        var budgetAmn = parseFloat(component.get("v.budgetAmount"));
        if(invAmount > budgetAmn){
            // Prepare a toast UI message
            validBalAmount = false;
            var resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                "title": "Amount shouldn't be greater than Remaining Balance Amount",
                "message": "Please add Invoice Amount with in Remaining Budget",
                "type": "error",
            });
            // Update the UI: close panel, show toast, refresh account page
            //$A.get("e.force:closeQuickAction").fire();
            resultsToast.fire();
            //$A.get("e.force:refreshView").fire();
        }
        
        // If we pass error checking, do some real work
        if(validExpense && validBalAmount){
            // Create the new expense
            var newPayment = component.get("v.payment");
            var Invoice = component.get("v.invoice");
            
            console.log("Payment: " + JSON.stringify(newPayment));
            console.log("Invoice: " + JSON.stringify(Invoice));
            helper.chargeCard(component, newPayment,Invoice);
        }
    },
    //lightning spinner
    // function automatic called by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // remove slds-hide class from mySpinner
        //var spinner = component.find("mySpinner");
        //$A.util.removeClass(spinner, "slds-hide");
        component.set("v.HideSpinner", true);
    },
     
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // add slds-hide class from mySpinner    
        //var spinner = component.find("mySpinner");
        //$A.util.addClass(spinner, "slds-hide");
        component.set("v.HideSpinner", false);
    
}
 
})