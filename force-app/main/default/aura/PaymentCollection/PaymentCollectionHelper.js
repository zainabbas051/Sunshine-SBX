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
    getAllDetails: function(component) {
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
                component.set("v.PaymentPlanId", jsonResp.PPId);
                component.set("v.payment.amount", jsonResp.TotalAmount);
                component.set("v.payment.oppName", jsonResp.ClientName);
                component.set("v.AddedCards", jsonResp.ListCards);
                
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

    getPPLIList: function(component)
    {
        var recId = component.get("v.recordId");
        var action = component.get("c.returnPaymentLineItem");
        action.setParams({
            "OppId" : recId,
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                console.log(response.getReturnValue());
                
                component.set("v.paymentLineItemList", json.parse(response.getReturnValue()));
                
        
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

    executePayment : function(component){
        
        var dueAmount = parseFloat(component.get("v.budgetAmount"));
        var totalAmount = parseFloat(component.get("v.paymment.amount"));
        var diffAmount = 0.0;

        this.processAmountHelper(component);

        if(totalAmount - dueAmount > 0){
            diffAmount = totalAmount - dueAmount;
            this.createPaymentPlan(component, diffAmount);
        }
    },

    createPaymentPlan : function(component,otherAmount){

        var recId = component.get("v.recordId");
        var action = component.get("c.createPaymentLineItem");
        action.setParams({
            "OppId" : recId,
            "otherAmount" : otherAmount
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {   
                component.set('v.paymentLineItemList',response.getReturnValue());     
                this.processAmountHelper(component);             
                return;
            }
            this.showErrors(component, response.getError());
        });
        $A.enqueueAction(action);
    },

    saveCard: function(component){
        var action = component.get("c.saveCard");
        action.setParams({
            "PPId": component.get("v.PaymentPlanId"),
            "cardNum": component.get("v.payment.card"),
            "cardHoldName": component.get("v.payment.holderName"), 
            "expMon": component.get("v.payment.month"), 
            "expYr": component.get("v.payment.year"), 
            "Cvv":component.get("v.payment.cvv"),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {          
                var resp = response.getReturnValue(); 
                component.set("v.AddNewCard",false);
                component.set('v.selectedCardValue',component.get("v.payment.card"));  
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Card has been added",
                    "message": "Card has been added successfully, please proceed to Payment",
                    "type": "success",
                });
                // Update the UI: close panel, show toast, refresh account page
                //$A.get("e.force:closeQuickAction").fire();
                resultsToast.fire();          
                return;
            }
            this.showErrors(component, response.getError());
        });
        $A.enqueueAction(action);


    },
    processAmountHelper: function(component) {
       
        var recId = component.get("v.recordId");
        var action = component.get("c.processPayment");
        var fileName = $A.localizationService.formatDate(new Date(), "YYYYMMDDhhmmss");
        action.setParams({
            "OppId": recId,
            "fileName" : fileName,
            "cardNumber" : component.get("v.payment.card"),
            "CVC" : component.get("v.payment.cvv"),
            "totalDueAmount" : component.get("v.payment.amount")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {          
                this.uploadFileInAWS(component,response.getReturnValue(),fileName);             
                
                return;
            }
            this.showErrors(component, response.getError());
        });
        $A.enqueueAction(action);
        
    },

    uploadFileInAWS: function(component,uploadJson,fileName) {
      
        if(uploadJson.length == 0){
          component.find('notifLib').showToast({
              "title": "Error!",
              "variant": "error",
              "message": 'Card Transaction was not successfull!'
          });
          $A.util.toggleClass(spinner, "slds-hide");  
          return;
        }
        component.set('v.fileName',fileName);
        this.fileCreateServer(component,uploadJson);
       
    },

    fileCreateServer : function(component,listPpl){

        var action = component.get("c.processPdf");
        action.setParams({
            "ppl": listPpl
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") { 
                var fileName = component.get('v.fileName');
                var uploadJson = response.getReturnValue();
                for(var index in uploadJson){
                    var uploadConfig = JSON.parse(uploadJson[index]);
                    var updatedFileName = fileName + '_'+ uploadConfig.paymentLineItemId +'.pdf';
                    this.fileUploadJs(component,uploadConfig,updatedFileName);
                }
            return;
            }
            this.showErrors(component, response.getError());
        })
        $A.enqueueAction(action);
    },

    fileUploadJs : function(component,uploadConfig,fileName){

        var notif =  component.find('notifLib');
        const AWS = window.AWS;
        AWS.config.region = 'us-west-2';
        AWS.config.update({accessKeyId: 'AKIAIPYELBFZS47EKG7A', secretAccessKey: '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'});
        var blobContent = this.dataURItoBlob(uploadConfig.pdfContent,'pdf');
        var params = {ContentType: 'pdf', Body: blobContent};
        var bucket = new AWS.S3(
        {
          params:
            { 
            
              Bucket: 'revenuecollections',
              Key: 'Sandbox/ClinicalPortal/Reimbursement/' + fileName
            }
        });
        
        bucket.upload(params, function (err, data) {
			
            console.log('entered in file upload');
            var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Payment has been made Successfully",
                    "message": "The payment has been made Successfully",
                    "type": "success",
                });
                resultsToast.fire();

            /*if(err == null){
                component.set("v.disabled",true);
               
                
                // Prepare a toast UI message
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Payment has been made Successfully",
                    "message": "The payment has been made Successfully",
                    "type": "success",
                });
                resultsToast.fire();
                
            }*/
           
            //$A.util.toggleClass(spinner, "slds-hide");           
        });
    },

    dataURItoBlob : function(dataURI, type) {
        // convert base64 to raw binary data held in a string
        var byteString = atob(dataURI);
    
        // separate out the mime component
      //  var mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0]
    
        // write the bytes of the string to an ArrayBuffer
        var ab = new ArrayBuffer(byteString.length);
        var ia = new Uint8Array(ab);
        for (var i = 0; i < byteString.length; i++) {
            ia[i] = byteString.charCodeAt(i);
        }
    
       
        var bb = new Blob([ab], { type: type });
        return bb;
    },

    showErrors: function(component, errors) {
        if (errors) {
            var spinner = component.find("loader");
            $A.util.toggleClass(spinner, "slds-hide");
            if (errors[0] && errors[0].message) {
                component.find('notifLib').showToast({
                    "title": "Error!",
                    "variant": "error",
                    "message": errors[0].message
                });
            }
        }
    },


})