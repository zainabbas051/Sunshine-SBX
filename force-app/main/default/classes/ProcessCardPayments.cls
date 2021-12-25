global class ProcessCardPayments implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.stateful {
     Exception[] errors = new Exception[0];
     List<Authorize_Net_Transaction_Info__c> listAuthorize_Net= new List<Authorize_Net_Transaction_Info__c>();
     List<Payment_Plan_Line_Items__c> listPPLI = new List<Payment_Plan_Line_Items__c>();
     
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        
       
        string collection = 'Debit/Credit Card';
        string openStatus = 'Open';
        string heldForReviewStatus = 'Held for Review';
        //return Database.getQueryLocator('Select ID , Payment_Plan__c,Sunshine_Center__c,Amount_For_Collection__c  FROM Payment_Plan_Line_Items__c WHERE Due_Date__c = TODAY AND Designated_Mode_of_Collection__c =: collection AND Status__c =:openStatus AND Card_Transaction_Status__c !=:heldForReviewStatus ');
         return Database.getQueryLocator([Select ID , Payment_Plan__c,Sunshine_Center__c,Amount_For_Collection__c FROM Payment_Plan_Line_Items__c 
                                            WHERE Due_Date__c = TODAY AND Designated_Mode_of_Collection__c = 'Debit/Credit Card' AND 
                                            Status__c =:openStatus AND Card_Transaction_Status__c NOT IN ('Held for Review','Declined','Error') ]);
                                            }
                                            
    
    global void execute(Database.BatchableContext BC, List<Payment_Plan_Line_Items__c> lstPaymentPlan) {
       
       
 
        Set<string> setOfPaymentPlan = new Set<string>();
        for(Payment_Plan_Line_Items__c i : lstPaymentPlan)
        {        
            
            setOfPaymentPlan.add(i.Payment_Plan__c);
        }
       
       Map<ID,Card_Information__c > mapOfCardInf = new Map<ID,Card_Information__c>();
       
       for(Card_Information__c iCard : [select id, Card_Number__c, Name_On_Card__c, Expiration_Month__c, Expiration_Year__c, CVV__c, AWS_Link__c, Payment_Plan__c,
                                       Billing_Address__c, Billing_City__c, Billing_State__c, Billing_Zip__c, Payment_Plan_Authorization_URL__c, 
                                       Card_Approved__c, Credit_Card_Authorization_Ext1__c, Credit_Card_Authorization_Ext2__c from Card_Information__c
                                        where Payment_Plan__c IN : setOfPaymentPlan]){
                mapOfCardInf.put(iCard.Payment_Plan__c,iCard);
       }
       
       for(Payment_Plan_Line_Items__c i : lstPaymentPlan){
              
              if(mapOfCardInf.containsKey(i.Payment_Plan__c) == false) continue;
              
              Card_Information__c cardInf = mapOfCardInf.get(i.Payment_Plan__c);
              
              PaymentAuthorization paymentplan = new PaymentAuthorization(i.Id,cardInf,i.Amount_For_Collection__c,i.Sunshine_Center__c  );
                                                                            

              string jsonRequest = paymentplan.JSONReq;
              string jsonRespone;
              jsonRespone = paymentplan.GetPaymentAuthorization();
              
            //**************Update Authorize_Net_Transaction_Info__c Custom Object and Payment Plane Line Item Status*******
       //     Try{
            Authorize_Net_Transaction_Info__c authObj = new Authorize_Net_Transaction_Info__c();
            authObj.Payment_Plan_Line_Items__c = i.Id;
            authObj.Outbound_API_JSON__c = jsonRequest;
            authObj.Inbound_API_Response__c = jsonRespone;
            listAuthorize_Net.add(authObj);

           AuthorizeNetResponse responseObj = AuthorizeNetResponse.parse(jsonRespone);
           Payment_Plan_Line_Items__c paymentLine = new Payment_Plan_Line_Items__c();
           paymentline.Id = i.Id;
           paymentline.Actual_Mode_of_Collection__c = 'Debit/Credit Card';
           paymentline.Collection_Reference_ID__c=responseObj.transactionResponse.transId;
           string responseCode=responseObj.transactionResponse.responseCode;
           switch on responseCode {
                when '1' {       
                    paymentline.Card_Transaction_Status__c='Approved';
                    paymentline.Status__c = 'Closed';
                    paymentline.Closed_Date__c = date.Today();
                }   
                when '2' {      
                    paymentline.Card_Transaction_Status__c='Declined';
                }
                when '3' {       
                    paymentline.Card_Transaction_Status__c='Error';
                }
                when '4' {       
                    paymentline.Card_Transaction_Status__c='Held for Review';
                }
            }
          paymentline.Card_Transaction_Message__c = responseObj.messages.message[0].text;
           
           listPPLI.add(paymentline);
           
       //    }
           
          /* Catch(Exception ex)
           {
           errors.add(ex);
           System.debug('The following exception has occurred: ' + ex.getMessage());
           }*/
              
              
       }
       
     
        
    }   
    
    global void finish(Database.BatchableContext BC) {
    
    system.debug(listAuthorize_Net);
    system.debug(listPPLI);
    insert listAuthorize_Net;
    update listPPLI;
        
  }
}