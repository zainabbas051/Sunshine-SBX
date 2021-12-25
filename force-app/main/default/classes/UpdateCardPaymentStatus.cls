global class UpdateCardPaymentStatus implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.stateful {
     Exception[] errors = new Exception[0];
     List<Authorize_Net_Transaction_Info__c> listAuthorize_Net= new List<Authorize_Net_Transaction_Info__c>();
     List<Payment_Plan_Line_Items__c> listPPLI = new List<Payment_Plan_Line_Items__c>();
     
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        
       
        string collection = 'Debit/Credit Card';
        string openStatus = 'Open';
        string heldForReviewStatus = 'Held for Review';
        return Database.getQueryLocator('Select ID , Payment_Plan__c,Sunshine_Center__c,Amount_For_Collection__c,Collection_Reference_ID__c  FROM Payment_Plan_Line_Items__c WHERE Designated_Mode_of_Collection__c =: collection AND Card_Transaction_Status__c =:heldForReviewStatus ');
    }
    
    global void execute(Database.BatchableContext BC, List<Payment_Plan_Line_Items__c> lstPaymentPlan) {
       
       
 
        Set<string> setOfPaymentPlan = new Set<string>();
        for(Payment_Plan_Line_Items__c i : lstPaymentPlan)
        {        
            
            setOfPaymentPlan.add(i.Payment_Plan__c);
        }
       
       Map<ID,Card_Information__c > mapOfCardInf = new Map<ID,Card_Information__c>();
       
       for(Card_Information__c iCard : [select id, Card_Number__c, Name_On_Card__c,Payment_Plan__c,
                                        Expiration_Month__c, Expiration_Year__c, CVV__c, AWS_Link__c, Billing_Address__c, Billing_City__c, Billing_State__c, Billing_Zip__c from Card_Information__c
                                        where Payment_Plan__c IN : setOfPaymentPlan]){
                mapOfCardInf.put(iCard.Payment_Plan__c,iCard);
       }
       
       for(Payment_Plan_Line_Items__c i : lstPaymentPlan){
              
              if(mapOfCardInf.containsKey(i.Payment_Plan__c) == false) continue;
              
              Card_Information__c cardInf = mapOfCardInf.get(i.Payment_Plan__c);
                 system.debug('ggggg' + i.Collection_Reference_ID__c );
              
              PaymentAuthorization paymentplanTransactionDetail = new PaymentAuthorization(i.Sunshine_Center__c, i.Collection_Reference_ID__c );
              string jsonRequest_TransactionDetail = paymentplanTransactionDetail.JSONReq;
              string jsonRespone_TransactionDetail = paymentplanTransactionDetail.getTransactionDetail();
              jsonRespone_TransactionDetail = jsonRespone_TransactionDetail.replace('transaction','transactionObj');
             
             system.debug('ggggg' + jsonRespone_TransactionDetail );
              TransactionResponseWrapper tWrapper = (TransactionResponseWrapper) System.JSON.deserialize(jsonRespone_TransactionDetail , TransactionResponseWrapper.class);
                 system.debug('ggggg' + tWrapper );
              
              string statusMsg;
              
                 switch on tWrapper.transactionObj.responseCode{
                when 1 {       
                    statusMsg ='Approved';
                }   
                when 2 {      
                    statusMsg='Declined';
                }
                when 3 {       
                    statusMsg='Error';
                }
                when 4 {       
                    statusMsg='Held for Review';
                }
                
                }
            
            if(statusMsg=='Approved')
            {
 
               listPPLI.add(new Payment_Plan_Line_Items__c(Id = i.Id, Card_Transaction_Status__c = statusMsg, Status__c = 'Closed',Closed_Date__c = date.Today() ));
               }  
            else
              listPPLI.add(new Payment_Plan_Line_Items__c(Id = i.Id, Card_Transaction_Status__c = statusMsg));
              
         
              
              
       }
       
       update listPPLI;
       
     
        
    }   
    
    global void finish(Database.BatchableContext BC) {
    
    system.debug(listAuthorize_Net);
    system.debug(listPPLI);
    insert listAuthorize_Net;
    update listPPLI;
        
  }
}