({
    
    doInit1: function(component, event, helper){
        console.log('IN');
        console.log('selected card ='+component.get('v.selectedCardValue'));
        helper.getAllDetails(component);

        
    },
    
    onChange: function (component, event, helper) {
        var selPickListValue = event.getSource().get("v.value");
        console.log('*selPickListValue :'+selPickListValue );
        component.set("v.selectedCardValue", selPickListValue);
        console.log('*sel card attr :'+component.get("v.selectedCardValue"));
        if(selPickListValue != 'Enter New Card')
        {
            console.log('*selval inside :'+selPickListValue );
            component.set("v.AddNewCard",false);
            helper.bringExistingCard(component, selPickListValue);
        }
        else
        {
            component.set("v.AddNewCard",true);
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
        
        var selCard = component.get('v.selectedCardValue')

        var amount = component.get("v.payment.amount");

        var valid = helper.validateAmount(component,amount);

        if(!valid){
            // Prepare a toast UI message
            var resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                "title": "Amount shouldn't be less than Remaining Due",
                "message": "Please add amount greater or equal to remaining budget in mutiples of 50",
                "type": "error",
            });
            // Update the UI: close panel, show toast, refresh account page
            //$A.get("e.force:closeQuickAction").fire();
            resultsToast.fire();
            //$A.get("e.force:refreshView").fire();
        }
        else if(valid == true && validExpense == true)
        {
            console.log('Payment Please');
            helper.executePayment(component);
            /*if(selCard == 'Enter New Card'){
                helper.saveCard(component);
            }*/
            
        }


    },

    AddNewCard: function(component, event, helper) {
        helper.saveCard(component);
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