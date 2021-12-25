({
    findPPLIFromServer: function(component) {

        var spinner = component.find("loader");
        var action = component.get("c.getPaymentLineItem");
        var OppId = component.get("v.OppId");
        // alert(OppId);
        action.setParams({
            OppId: OppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var totalAmount = 0;
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                for (var i = 0; i < data.length; i++) {
                    if (data[i].Status__c == 'Open') {
                        totalAmount += data[i].Amount_For_Collection__c;
                        component.set('v.disabled', false);
                    }
                }
                component.set("v.outstandingAmnt", totalAmount);
                component.set("v.paymentLineItemList", response.getReturnValue());
               // $A.util.toggleClass(spinner, 'slds-hide');
                return;
                // component.set("v.showList",true);
            }
            this.showErrors(component, response.getError());

        });
        $A.enqueueAction(action);
        this.findClosedPPLIFromServer(component);
    },
    findClosedPPLIFromServer: function(component) {

        var spinner = component.find("loader");
        var action = component.get("c.getClosedPaymentLineItem");
        var OppId = component.get("v.OppId");
        // alert(OppId);
        action.setParams({
            OppId: OppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var totalAmount = 0;
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
    
                component.set("v.ClosedpaymentLineItemList", response.getReturnValue());
                $A.util.toggleClass(spinner, 'slds-hide');
                return;
                // component.set("v.showList",true);
            }
            this.showErrors(component, response.getError());

        });
        $A.enqueueAction(action);
    },
    
    getCardList: function(component) {
        debugger;
       // var spinner = component.find("loader");
        var action = component.get("c.getCardInfoList");
        var OppId = component.get("v.OppId");
        // alert(OppId);
        action.setParams({
            OppId: OppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
       
            if (state === "SUCCESS") {
                debugger;
                var data = response.getReturnValue();
                //component.set("v.CardList", response.getReturnValue());
                var cardOptions = [] ;
                for (var i = 0; i < data.length; i++) {
                    let endDigit = data[i].Card_Number__c.slice(data[i].Card_Number__c.length-4, data[i].Card_Number__c.length);
                    let countNum = '';
                    
                    for(var j = (data[i].Card_Number__c.length)-4; j>0; j--){
                        countNum += 'X';
                    }
                    var cardNum = countNum + endDigit;
                    var cardID = data[i].Card_Number__c;
                    cardOptions.push({
                                label:cardNum, 
                                value: cardID
                                });    
                }
                cardOptions.push({
                                label:'Other', 
                                value: ''
                            });
                component.set("v.CardList", cardOptions);
                return;
             
            }
            this.showErrors(component, response.getError());

        });
        $A.enqueueAction(action);
    },
   validateCVVfromServer: function(component) {
        debugger;
        var spinner = component.find("loader");
        $A.util.toggleClass(spinner, "slds-hide");
        var action = component.get("c.ValidateCVV");
        var cardNumber= component.get('v.cardNumber');
        var CVV= component.get('v.CVV');
        // alert(OppId);
        action.setParams({
            cardNumber: cardNumber,
            CVV: CVV
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
       
            if (state === "SUCCESS") {
                debugger;
                var data = response.getReturnValue();
                component.set("v.isValidCVV",data);
                if(data==false){
                   this.showInvalidCVVError(component);
                   var spinner = component.find("loader");
            	   $A.util.toggleClass(spinner, "slds-hide");
                   return;
                }
                this.executePayment(component);
            }
           // this.showErrors(component, response.getError());
        });
        $A.enqueueAction(action);
    },
    
    executePayment : function(component){
        
        var selectedOption = component.get('v.value');
        var otherAmount = 0;
        if (selectedOption == 'option1') {
            otherAmount = -1;
            this.processAmountHelper(component);
        } else {
            otherAmount = component.get("v.otherAmount") - component.get("v.outstandingAmnt");
            this.createPaymentPlan(component, otherAmount);
        }
    } ,
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
        debugger;
        var stepTwo = component.find("stepTwo");
        $A.util.toggleClass(stepTwo, 'slds-hide');
        
    },
	toggleThreeSteps : function(component){
        var stepThree = component.find("stepThree");
        $A.util.toggleClass(stepThree, 'slds-hide');
        
    },

    createPaymentPlan : function(component,otherAmount){

        debugger;
        var spinner = component.find("loader");
        $A.util.toggleClass(spinner, "slds-hide");
        var action = component.get("c.createPaymentLineItem");
        action.setParams({
            paymentPlanLst: component.get("v.paymentLineItemList"),
            otherAmount : otherAmount
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

    processAmountHelper: function(component) {
        debugger;
        
        
        var action = component.get("c.processPayment");
        var fileName = $A.localizationService.formatDate(new Date(), "YYYYMMDDhhmmss");
        action.setParams({
            paymentPlanLst: component.get("v.paymentLineItemList"),
            fileName : fileName,
            cardNumber : component.get("v.cardNumber"),
            CVC : component.get("v.CVV"),
            totalDueAmount : component.get("v.outstandingAmnt")
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
        
        
        component.set('v.showPopup',false);
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
    showInvalidCVVError: function(component) {
      
            var spinner = component.find("loader");
            $A.util.toggleClass(spinner, "slds-hide");
            
                component.find('notifLib').showToast({
                    "title": "Error!",
                    "variant": "error",
                    "message": "Invalid CVV. Try Again."
                });
            
        
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
     // for(var index in uploadJson){
       // var uploadConfig = JSON.parse(uploadJson[index]);
       // var updatedFileName = fileName + '_'+ uploadConfig.paymentLineItemId +'.pdf';
     //   this.fileUploadJs(component,uploadConfig,updatedFileName);
     // }
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

    fileCreateServer : function(component,listPpl){

        var action = component.get("c.processPdf");
        action.setParams({
            ppl: listPpl
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

        debugger;
        var notif =  component.find('notifLib');
        var spinner = component.find("loader");
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
			
           
            if(err == null){
               // $A.get('e.force:refreshView').fire(); 
                notif.showToast({
                    "title": "Success!",
                    "variant" : "success",
                    "message": "The payment has been made Successfully"
                     
                }); 
                $A.get('e.force:refreshView').fire();      
            }
           
            //$A.util.toggleClass(spinner, "slds-hide");           
        });
    }
})