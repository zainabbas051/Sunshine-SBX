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
        if(selPickListValue != 'Please Select')
        {
            console.log('*selval inside :'+selPickListValue );
            component.set("v.AddNewCard",false);
            component.set("v.disabled", false);
            component.set("v.showValidateCVV",true);
            helper.bringExistingCard(component, selPickListValue);
        }
        else if(selPickListValue == 'Please Select')
        {
            component.set("v.showValidateCVV",false);
            component.set("v.ExsCardCVV",null);
            component.set("v.AddNewCard",true);
            component.set("v.payment.holderName", null);
            component.set("v.payment.card", null);
            component.set("v.payment.month", null);
            component.set("v.payment.year", null);
            component.set("v.payment.cvv", null);
            component.set("v.disabled", true);
        }
        
    },

    cancelForm : function(component,event,helper){
        component.set('v.recordId',undefined);
    },

    ptSelect : function(component,event,helper){
        var selVal = event.getSource().get("v.value");
        if(selVal == 'Custom')
            component.set('v.amountDisabled',false);
        else
            component.set('v.amountDisabled',true);
    },


    exsNewCardSelect : function(component,event,helper){
        var selVal = event.getSource().get("v.value");
        console.log(component.get("v.NewExiCardSel"));
        if(selVal == 'New'){
            component.set('v.isModalOpen',true);
            component.set('v.ExistingCardsListFromApex',null);
        }
        else if(selVal == 'Existing'){
            helper.callAllExsCards(component);
            console.log('exisCards=='+component.get("v.ExistingCardsListFromApex"));
            console.log('selected card='+component.get("v.selectedCardValue"));
        }
        else{
            component.set('v.ExistingCardsListFromApex',null);
        }
        

        //this.checkIfExsCards(component,event,helper);
    },

    checkIfExsCards : function(component,event,helper){
        var exsCards = component.get("v.AddedCards");
        if(exsCards.length > 0){
            component.set("v.hasExistingCards", true);
        }
        else{
            component.set("v.hasExistingCards", false);
        }
        console.log("exsCards?="+component.get("v.hasExistingCards"));
    },

    closeModal : function(component,event,helper){
        component.set('v.isModalOpen',false);
        component.set('v.NewExiCardSel',"None");
        component.set('v.ExistingCardsListFromApex',null);
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

        /*var validExpense = component.find('expenseform').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);*/
        
        var selCard = component.get('v.selectedCardValue')

        var amount = component.get("v.payment.amount");

        var valid = helper.validateAmount(component,amount);
        var cvvValid = true;
        var isExistingCard = component.get("v.NewExiCardSel");
        if(isExistingCard == 'Existing'){
            cvvValid = helper.validateCVV(component);
            if(!cvvValid){
                // Prepare a toast UI message
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Invalid / Incorrect CVV",
                    "message": "CVV does not match",
                    "type": "error",
                });
                // Update the UI: close panel, show toast, refresh account page
                //$A.get("e.force:closeQuickAction").fire();
                resultsToast.fire();

            }
        }

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
        else if(valid == true && cvvValid == true)// && validExpense == true)
        {
            console.log('Payment Please');
            helper.executePayment(component);
            /*if(selCard == 'Enter New Card'){
                helper.saveCard(component);
            }*/
            
        }


    },

    AddNewCard: function(component, event, helper) {
        var validExpense = component.find('expenseform').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        
        if(validExpense){
            var cname = component.get("v.NewCardName");
            var cnum = component.get("v.NewCardNumber");
            var cem = component.get("v.NewCExpMonth");
            var cey = component.get("v.NewCExpYear");
            var ccvv = component.get("v.NewCardCVV");
        
            component.set("v.payment.holderName",cname); 
            component.set("v.payment.card",cnum);
            component.set("v.payment.month",cem);
            component.set("v.payment.year",cey);
            component.set("v.payment.cvv",ccvv);
            
            helper.saveCard(component);
            component.set('v.isModalOpen',false);
            component.set('v.disabled',false);
            component.set('v.ExistingCardsListFromApex',null);
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