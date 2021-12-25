@isTest
private class ProcessCardPayments_Test{


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
        p.Card_Transaction_Status__c = 'Approved';
        insert p;
    }

      Static testmethod void ProcessTest(){


        Test.startTest();

            Database.executeBatch(new ProcessCardPayments());
            string json = '{"transactionResponse":{"responseCode":"1","authCode":"BU4YS5","avsResultCode":"Y","cvvResultCode":"P","cavvResultCode":"2","transId":"40044648740","refTransID":"","transHash":"","testRequest":"0","accountNumber":"XXXX0015","accountType":"MasterCard","messages":[{"code":"1","description":"This transaction has been approved."}],"transHashSha2":"","SupplementalDataQualificationIndicator":0},"refId":"a0C3C00000543YqUAI","messages":{"resultCode":"Ok","message":[{"code":"I00001","text":"Successful."}]}}';
              AuthorizeNetResponse tWrapper = (AuthorizeNetResponse) System.JSON.deserialize(json , AuthorizeNetResponse.class);
            
        String accountType =   tWrapper.transactionResponse.accountType;
        // list<userFields> userFields = tWrapper.transactionResponse.accountType;
         String accountNumber = tWrapper.transactionResponse.accountNumber;
         String transHashSha2 = tWrapper.transactionResponse.transHashSha2;
         String testRequest = tWrapper.transactionResponse.testRequest;
         Integer SupplementalDataQualificationIndicator = tWrapper.transactionResponse.SupplementalDataQualificationIndicator;
         String transHash = tWrapper.transactionResponse.transHash;
         String transId = tWrapper.transactionResponse.transId;
         String refTransID = tWrapper.transactionResponse.refTransID;
         String cavvResultCode = tWrapper.transactionResponse.cavvResultCode;
         String avsResultCode = tWrapper.transactionResponse.avsResultCode;
         String authCode = tWrapper.transactionResponse.authCode;
         String cvvResultCode = tWrapper.transactionResponse.cvvResultCode;
         String responseCode = tWrapper.transactionResponse.responseCode;

         list<AuthorizeNetResponse.userFields> userFields = new List<AuthorizeNetResponse.userFields>();
         AuthorizeNetResponse.userFields u = new AuthorizeNetResponse.userFields();
         u.value = 'test';
         u.name = 'test';
         userFields.add(u);

             list<AuthorizeNetResponse.message> message = new List<AuthorizeNetResponse.message>();
         AuthorizeNetResponse.message m = new AuthorizeNetResponse.message();
         m.text = 'test';
         m.code = 'test';
         message.add(m);

        // userFields.add(new AuthorizeNetResponse.userFields(value = 'ss',name = 'ss'));
        Test.stopTest();
     }
}