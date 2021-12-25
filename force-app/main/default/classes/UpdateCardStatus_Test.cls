@isTest
private class UpdateCardStatus_Test{


     @testSetup static void setup() {
        // Create common test accounts
        Account a;
        Opportunity oms;
        Payment_Plan__c ppRecord;  

        a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;
        
        Schema.DescribeSObjectResult opp = Schema.SObjectType.Opportunity;
        Map<String, Schema.RecordTypeInfo> rtMapByNameOpp = opp.getRecordTypeInfosByName();
        Id recTypeIdOpp = rtMapByNameOpp.get('Monarch Shores').getRecordTypeId(); 
        
        oms = new Opportunity();
        oms.Name = 'test opp';
        oms.RecordTypeId = recTypeIdOpp;
        oms.Account = a;
        oms.Selected_Treatment_Center__c = a.id;
        oms.Closing_Agent__c = Userinfo.getUserId();
        oms.Amount = 999;
        oms.StageName = 'Working';
        oms.CloseDate = date.Today();
        oms.Test_Class_Checkbox__c = True;
        insert oms;
        
        ppRecord = new Payment_Plan__c();
        ppRecord.Opportunity__c = oms.id;
        ppRecord.Start_Date__c = date.Today();
        ppRecord.Total_Amount_To_Be_Collected__c = 1000;
        ppRecord.Payment_Plan_Type__c = 'Custom';
        insert ppRecord; 
        
        Card_Information__c ciRecord = new Card_Information__c();
        ciRecord.AWS_Link__c = 'Test';
        ciRecord.Card_Number__c = '1234123412341234';
        ciRecord.CVV__c = 123;
        ciRecord.Expiration_Month__c ='11';
        ciRecord.Expiration_Year__c = '20';
        ciRecord.Name_on_Card__c='John Smith';
        ciRecord.Payment_Plan__c = ppRecord.id;
        insert ciRecord;   

        Payment_Plan_Line_Items__c p = new Payment_Plan_Line_Items__c();
        p.Payment_Plan__c = ppRecord.Id;
        p.Amount_For_Collection__c = 100;
        p.Due_Date__c = Date.Today();
        p.Designated_Mode_of_Collection__c = 'Debit/Credit Card';
        p.Status__c = 'Open';
        p.Card_Transaction_Status__c = 'Held for Review';
        insert p;
    }

     public Static testmethod void ProcessTest(){


        Test.startTest();

            Database.executeBatch(new UpdateCardPaymentStatus());
            string jsonRespone_TransactionDetail = '{"transactionObj":{"responseCode":"1","authCode":"BU4YS5","avsResultCode":"Y","cvvResultCode":"P","cavvResultCode":"2","transId":"40044648740","refTransID":"","transHash":"","testRequest":"0","accountNumber":"XXXX0015","accountType":"MasterCard","messages":[{"code":"1","description":"This transaction has been approved."}],"transHashSha2":"","SupplementalDataQualificationIndicator":0},"refId":"a0C3C00000543YqUAI","messages":{"resultCode":"Ok","message":[{"code":"I00001","text":"Successful."}]}}';
              
                
              TransactionResponseWrapper tWrapper = (TransactionResponseWrapper) System.JSON.deserialize(jsonRespone_TransactionDetail , TransactionResponseWrapper.class);
              
              string cardResponse = tWrapper.transactionObj.cardCodeResponse;
              cardResponse = tWrapper.transactionObj.AVSResponse;
              decimal authAmount= tWrapper.transactionObj.authAmount;
              cardResponse = tWrapper.transactionObj.authCode;
              authAmount= tWrapper.transactionObj.settleAmount;
              cardResponse = tWrapper.transactionObj.responseReasonDescription;
              boolean taxExempt = tWrapper.transactionObj.taxExempt;
              Integer responseReasonCode = tWrapper.transactionObj.responseReasonCode;
              Integer responseCode = tWrapper.transactionObj.responseCode;
                cardResponse = tWrapper.transactionObj.transactionStatus;
                   String transactionType = tWrapper.transactionObj.transactionStatus;
     String customerIP = tWrapper.transactionObj.customerIP;
     String submitTimeLocal = tWrapper.transactionObj.submitTimeLocal;
     String product = tWrapper.transactionObj.product;
     String submitTimeUTC = tWrapper.transactionObj.submitTimeUTC;
     String marketType = tWrapper.transactionObj.marketType;
     String transId = tWrapper.transactionObj.transId;

     tWrapper.transactionObj.billTo = new TransactionResponseWrapper.billTo();
     tWrapper.transactionObj.billTo.firstName = 'Ellen';
    
            tWrapper.transactionObj.billTo.lastName = 'Johnson';
            tWrapper.transactionObj.billTo.company = 'Souveniropolis';
            tWrapper.transactionObj.billTo.address = '14 Main Street';
            tWrapper.transactionObj.billTo.city = 'Pecan Springs';
            tWrapper.transactionObj.billTo.state = 'TX';
            tWrapper.transactionObj.billTo.zip = '44628';
            tWrapper.transactionObj.billTo.country = 'USA';

                tWrapper.transactionObj.payment = new TransactionResponseWrapper.payment();
                tWrapper.transactionObj.payment.creditCard = new TransactionResponseWrapper.creditCard();
            tWrapper.transactionObj.payment.creditCard.cardNumber = '111';
            tWrapper.transactionObj.payment.creditCard.expirationDate = 'monthYear';
            tWrapper.transactionObj.payment.creditCard.cardNumber = '666';

            tWrapper.messages = new TransactionResponseWrapper.messages();
            tWrapper.messages.resultCode = '11';



              

        Test.stopTest();
     }
}