public Inherited sharing class SearchPaymentLineItem_Ctrl{
    
  @AuraEnabled 
    public static string fetchUser(){
       User u = [select id,Name from User where id =: userInfo.getUserId()];
        return u.Name;
    }
    
   @AuraEnabled
    public static List<PaymentLineWrapper> getPaymentLineItem(string referenceId , string sunShineCentre){

        integer index = 0;
        List<PaymentLineWrapper> lstPaymentLineItem = new List<PaymentLineWrapper>();
        List<Payment_Plan_Line_Items__c> ppLineItem = [Select Payment_Plan__r.Name,Payment_Plan__r.Opportunity__c,Collector_Notes__c,Id,Collection_Reference_ID__c,
                                                      Payment_Plan__r.Opportunity__r.Name,
                                                        Amount_For_Collection__c,Additional_Notes__c,Status__c,Closed_Date__c, 
                                                        Name_of_Person_Responsible__c, Date_of_Cash_Collection__c,Cash_Collection_Discrepancy__c,
                                                        Email_Address_of_Person_Responsible__c FROM 
                                                        Payment_Plan_Line_Items__c WHERE 
                                                         Payment_Plan__r.Opportunity__r.Sunshine_Center_Name__c LIKE: '%'+sunShineCentre+'%' AND
                                                        Status__c = 'Cash Collected' AND Actual_Mode_of_Collection__c = 'Cash' order by Date_of_Cash_Collection__c ];
        
        for(Payment_Plan_Line_Items__c iPp : ppLineItem){

            lstPaymentLineItem.add(new PaymentLineWrapper(iPp,index));
            index++;
        }

        return lstPaymentLineItem;
    }
    
    @AuraEnabled
    public static void saveRecord (string jsonString){

        PaymentLineWrapper paymentPlanLineItemParam = (PaymentLineWrapper)System.JSON.deserializeStrict(jsonString, PaymentLineWrapper.Class);   
        update paymentPlanLineItemParam.paymentLineItem;
           /* if(paymentPlanLineItemParam != null){
              paymentPlanLineItemParam.Status__c='Closed';
              paymentPlanLineItemParam.Actual_Mode_of_Collection__c='Cash';
              update paymentPlanLineItemParam;*/
              
            /*  Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
               message.setSenderDisplayName('Tom Kearns'); 
               message.setReplyTo('no-reply@company.com');
               message.setUseSignature(false); 
               message.setBccSender(false); 
               message.setSaveAsActivity(false); 
  
               String[] emailAddress= new String[] {};
               emailAddress.add(paymentPlanLineItemParam.Email_Address_of_Person_Responsible__c);
               message.subject = 'Payment Plan: '+paymentPlanLineItemParam.Payment_Plan__r.Name+' Cash Collection Confirmation';
               message.plainTextBody = 'Cash Collection with the Collection Reference Id: '+String.valueOf(paymentPlanLineItemParam.id)+' has been confirmed. Below are the detail';
               message.plainTextBody+='\n\n\nActual Amount: $'+paymentPlanLineItemParam.Amount_For_Collection__c;
                if(paymentPlanLineItemParam.Cash_Collection_Discrepancy__c==true)
               message.plainTextBody+='\nDiscrepancy: Yes';
               if(paymentPlanLineItemParam.Cash_Collection_Discrepancy__c==false)
                message.plainTextBody+='\nDiscrepancy: No';
               message.plainTextBody+='\nAdditional Notes: '+ paymentPlanLineItemParam.Additional_Notes__c;
               message.toAddresses =emailAddress;
               Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
               Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
 
 if (results[0].success) 
 {
   System.debug('The email was sent successfully.');
 } else {
   System.debug('The email failed to send: ' +  results[0].errors[0].message);
 } */
              
           // }
        
    }
    
    public class PaymentLineWrapper {

       
        @AuraEnabled
        public Payment_Plan_Line_Items__c paymentLineItem {get; set;}
        @AuraEnabled
        public String IsAmountCorrect {get;set;}
        @AuraEnabled
        public String ActualCashCollected {get;set;}
        @AuraEnabled
        public String AdditionalNotes {get;set;}
        @AuraEnabled
        public boolean IsEditable {get;set;}
        @AuraEnabled
        public string ActualCashId {get;set;}
        @AuraEnabled
        public string AdditionalNotesId {get;set;}


        public PaymentLineWrapper(Payment_Plan_Line_Items__c aPp, integer Index){
            paymentLineItem = aPp;
            IsAmountCorrect = 'Yes';
            IsEditable = true;
            ActualCashId = 'actualCash' + Index;
            AdditionalNotesId = 'addNotes' + Index;

        }

    }
}