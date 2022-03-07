@isTest
private class HousingRentalCollection_CtrlTest{

    
   @TestSetup 
   static void createData() {
     
        Account a = new Account();
        a.Name = 'test account';
        a.Type = 'Treatment Center';
        insert a;
        
        Schema.DescribeSObjectResult opp = Schema.SObjectType.Opportunity;
        Map<String, Schema.RecordTypeInfo> rtMapByNameOpp = opp.getRecordTypeInfosByName();
        Id recTypeIdOpp = rtMapByNameOpp.get('Monarch Shores').getRecordTypeId(); 
        
        Opportunity oms = new Opportunity();
        oms.Name = 'test opp';
        oms.RecordTypeId = recTypeIdOpp;
        oms.Account = a;
        oms.Selected_Treatment_Center__c = a.id;
        oms.Closing_Agent__c = UserInfo.getUserId();
        oms.Amount = 999;
        oms.StageName = 'Working';
        oms.CloseDate = date.Today();
        oms.Test_Class_Checkbox__c = True;
        insert oms;
        
        Payment_Plan__c ppRecord = new Payment_Plan__c();
        ppRecord.Opportunity__c = oms.id;
        ppRecord.Start_Date__c = date.Today();
        ppRecord.Total_Amount_To_Be_Collected__c = 1000;
        ppRecord.Payment_Plan_Type__c = 'Custom';
        insert ppRecord;
        
        Payment_Plan_Line_Items__c ppl = new Payment_Plan_Line_Items__c();
        ppl.Type_of_Collection__c = 'Housing';
        ppl.Payment_Plan__c = ppRecord.Id;
        ppl.Status__c = 'Open';
        insert ppl;
        
        Payment_Plan_Line_Items__c ppll = new Payment_Plan_Line_Items__c();
        ppll.Type_of_Collection__c = 'Housing';
        ppll.Payment_Plan__c = ppRecord.Id;
        ppll.Status__c = 'Closed';
        insert ppll;
        
        Card_Information__c ci = new Card_Information__c();
        ci.Card_Number__c = '123';
        ci.Name_on_Card__c = 'Safia';
        ci.Payment_Plan__c = ppRecord.Id;
        ci.Expiration_Year__c = '2024';
        ci.Expiration_Month__c = '02';
        insert ci;
    }
    
      public Static testmethod void HouseRentalCollection(){
      
          Opportunity oppty = [Select id from opportunity limit 1];
          List<Payment_Plan_Line_Items__c> ppli = [Select id, Status__c,Payment_Plan__c, Amount_For_Collection__c, Sunshine_Center__c from Payment_Plan_Line_Items__c  where Status__c = 'Open' limit 1];
          Card_Information__c ci=[Select id,Card_Number__c,Name_on_Card__c,Payment_Plan__c,Expiration_Year__c,Expiration_Month__c from Card_Information__c where Payment_Plan__c =:ppli[0].Payment_Plan__c limit 1 ];
          HousingRentalCollection_Ctrl.getPaymentLineItem(oppty.Id);
          HousingRentalCollection_Ctrl.getCardInfoList(oppty.Id);
          HousingRentalCollection_Ctrl.ValidateCVV('123',123);
          HousingRentalCollection_Ctrl.processPayment(ppli,'test',ci,50.0,false);
          HousingRentalCollection_Ctrl.processPdf(new List<string> { ppli[0].Id });
          HousingRentalCollection_Ctrl.fetchUser();
          Authorize_Net_Transaction_Info__c auth = [Select Id from Authorize_Net_Transaction_Info__c 
                                                    Limit 1];
          ApexPages.currentPage().getParameters().put('Id',auth.Id);
          ctrl_GeneratePaymentReceiptv2 payment = new ctrl_GeneratePaymentReceiptv2();
      
      }
      
      public Static testmethod void HouseRentalCollectionTest(){
      
          Opportunity oppty = [Select id from opportunity limit 1];
          List<Payment_Plan_Line_Items__c> ppli = [Select id, Status__c,Payment_Plan__c, Amount_For_Collection__c, Sunshine_Center__c from Payment_Plan_Line_Items__c  where Status__c = 'Open' limit 1];
          Payment_Plan_Line_Items__c ppliClone = ppli[0].clone(false,false);
          Card_Information__c ci=[Select id,Card_Number__c,Name_on_Card__c,Payment_Plan__c,Expiration_Year__c,Expiration_Month__c from Card_Information__c where Payment_Plan__c =:ppli[0].Payment_Plan__c limit 1 ];
          HousingRentalCollection_Ctrl.createPaymentLineItem(ppli,40);
          HousingRentalCollection_Ctrl.savePaymentLineItem(new List<Payment_Plan_Line_Items__c> { ppliClone });
          HousingRentalCollection_Ctrl.getOpptyDetail(oppty.Id);
      
      }


}