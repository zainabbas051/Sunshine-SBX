@isTest
public class ctrl_GeneratePaymentReceipt_Test{
    
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
        
         string jsonstr = '{"transactionResponse":{"responseCode":"3","authCode":"","avsResultCode":"P","cvvResultCode":"","cavvResultCode":"","transId":"0","refTransID":"","transHash":"","testRequest":"0","accountNumber":"XXXX0015","accountType":"MasterCard","errors":[{"errorCode":"5","errorText":"A valid amount is required."}],"transHashSha2":"","SupplementalDataQualificationIndicator":0},"refId":"a0C3C0000054O1ZUAU","messages":{"resultCode":"Error","message":[{"code":"E00027","text":"The transaction was unsuccessful."}]}}';
           
        
           Authorize_Net_Transaction_Info__c auth = new Authorize_Net_Transaction_Info__c();
            auth.Outbound_API_JSON__c = jsonstr;
            auth.Inbound_API_Response__c = jsonstr;
            auth.Payment_Plan_Line_Items__c = p.id;
            insert auth;
        
        
    }
    
      Static testmethod void ProcessTest(){
            
            
            Authorize_Net_Transaction_Info__c auth = [Select id,Outbound_API_JSON__c,
                                                        Inbound_API_Response__c from Authorize_Net_Transaction_Info__c
                                                        limit 1];
         
            string jsonobj = JSON.serialize(auth);
            
              
            System.currentPageReference().getParameters().put('trans_id', jsonobj);
            
            ctrl_GeneratePaymentReceipt c = new ctrl_GeneratePaymentReceipt();
      }
      
       Static testmethod void ProcessTest_1(){
            
            Ctrl_UploadPaymentReceipt ctrl = new Ctrl_UploadPaymentReceipt();
            
            Payment_Plan_Line_Items__c p = [Select id from Payment_Plan_Line_Items__c limit 1];
            ctrl.UploadPaymentQuery(p.Id);
            ctrl.createPPLIReceiptUrl();
            ctrl.createUrl();
            ctrl.inputFileBlob = 'test';
            ctrl.outputFile = Blob.valueof('test');
            ctrl.bodyContent = 'test';
            ctrl.PDisFile = 'test';
            string userud = ctrl.currentUserId;
      }

}