({
    doInit: function(component, event, helper) {

        helper.findPPLIFromServer(component);
        
        helper.getCardList(component);
        component.set("v.progressIndicatorFlag", "step1");
        component.set("v.value", "option1");
        component.set('v.columns', [{
                label: 'Card',
                fieldName: 'Card_Number__c',
                type: 'text'
            },

        ]);

    },

    onRender: function(component, event, helper) {
        helper.toggleTwoSteps(component);
        component.find("btnNext").set('v.disabled', false);

    },
    showPopup: function(component, event, helper) {

        component.set('v.showPopup', true);
        helper.toggleTwoSteps(component);
        helper.toggleThreeSteps(component);
    },
    processAmount: function(component, event, helper) {

       var showOtherCard = component.get('v.showOtherCard');
       if(!showOtherCard){
             var isValidCVV = helper.validateCVVfromServer(component);
             return;
       }
       helper.executePayment(component);    
    },

    payOptionChange: function(component, event, helper) {

        component.set('v.disabled', true);
        var selectedOption = component.get("v.value");
        var outstandingAmount = component.get('v.outstandingAmnt');
        if (selectedOption == 'option1' && outstandingAmount > 0) {
            component.set('v.disabled', false);
            return;
        }

    },
    closeModel: function(component) {
        component.set('v.showPopup', false);

    },

    goToStepTwo: function(component, event, helper) {
        debugger;
        if (component.find("OtherAmount") != null) {
            var validity = component.find("OtherAmount").get("v.validity");
            if (!validity.valid) {
                return;
            }
        }
        helper.toggleOneAndTwoSteps(component);
        component.set("v.progressIndicatorFlag", "step2");
    },
    goToStepThree: function(component, event, helper) {
        helper.toggleTwoAndThreeSteps(component);
        component.set("v.progressIndicatorFlag", "step3");
    },

    goBackToStepOne: function(component, event, helper) {
        helper.toggleOneAndTwoSteps(component);
        component.set("v.progressIndicatorFlag", "step1");
    },
    goBackToStepTwo: function(component, event, helper) {

        helper.toggleTwoAndThreeSteps(component);
        component.set("v.progressIndicatorFlag", "step2");
    },
    getSelectedCard: function(component, event, helper) {
	   debugger;
        component.set('v.showOtherCard', false);
        var selectedCard = event.getParam("value");
        
        component.set('v.cardNumber', selectedCard);
        if (selectedCard == '') {
            component.set('v.showOtherCard', true);
        }
    },
    handleAmountChange: function(component, event, helper) {

        debugger;
        component.set('v.disabled', false);
        var outstandingAmount = component.get('v.outstandingAmnt');
        let otherAmount = component.get("v.otherAmount");

        if (otherAmount == '') {
            component.set('v.disabled', true);
            return;
        }

        if (otherAmount < outstandingAmount) {
            component.set('v.disabled', true);
            return;
        }

        var leftAmount = otherAmount - outstandingAmount;
        if (leftAmount % 50 != 0) {
            //  alert('Remaining Amount should be multiple of 50');
            component.set('v.disabled', true);
            return;
        }

    }
})