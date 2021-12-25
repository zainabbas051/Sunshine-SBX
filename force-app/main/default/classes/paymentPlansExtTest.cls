@isTest(seeAllData = true)
private class paymentPlansExtTest{
    Public static Account a;
    Public static Opportunity oms;
    Public static Payment_Plan__c ppRecord;
    public static Card_Information__c ciRecord;
    Public static User u_test;
    public Static Profile adminProfile;
    public Static ApexPages.StandardController paymentPlanController;
    public Static paymentPlansExt ppe;
 
    public static User userAdmin
    {
        get{
            if (userAdmin == null )
            {
                adminProfile = [Select Id, Name From Profile where name = 'System Administrator' limit 1];
                userAdmin  = new user (Username = ' test@key.net', FirstName = 'FirstTest', LastName ='LastTest', alias = 'FLast', 
                            email='test@key.net', communityNickname='test0101019', TimeZoneSidKey='America/New_York',
                            LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId=adminProfile.Id ,
                            LanguageLocaleKey='en_US');
                insert userAdmin;             
             }
             return userAdmin;
            }
        set;
    }
     
     public Static void createSampleData(){
        
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
        oms.Closing_Agent__c = userAdmin.id;
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
        
        
        
     }
     
     public Static testmethod void paymentPlansExtTest(){
       test.startTest();
       system.runAs(userAdmin){
           createSampleData();
           
           ApexPages.currentPage().getParameters().put('Id', oms.id);
           
           paymentPlanController = new ApexPages.StandardController(oms);
           ppe = new paymentPlansExt(paymentPlanController); 
           
           List<SelectOption> paymentPlanTypes = ppe.getPaymentPlanTypes();
           list<SelectOption> modeOfPayments = ppe.getModeOfPayments();
           
           PageReference pr1 = ppe.savePaymentPlan();
           
           ppe.setmodeOfPayment('Debit/Credit Card');
           ppe.setpaymentPlanType('Custom');
           ppe.settypeOfCollection('Deductible');
           
           List<SelectOption> collectionsList = ppe.getTypeOfCollectionS();
           String var4 = ppe.gettypeOfCollection();
           
           String var2 = ppe.selectedModeOfPayment;
         
           String var3 = ppe.getpaymentPlanType();
           
           ppe.addPaymentPlanLineItems();
           
           ppe.addPaymentPlanLineItems();
           
           ppe.deleteIndexValue = 0;
           
           ppe.deletePaymentPlanLineItems();
           
           
           ppe.tempPaymentPlan.Start_Date__c = date.Today();
           ppe.tempPaymentPlan.Total_Amount_To_Be_Collected__c = 1000;
           
           //PageReference pr2 = ppe.savePaymentPlan();
           
           for(paymentPlansExt.paymentPlanLineItems li : ppe.paymentPlanLineItemsList){
               li.amount = 1000;
               li.dueDate = date.Today();
           }
           
           ppe.setNewAttachments[0].cardNumber = '1234123412341234';
           ppe.setNewAttachments[0].nameOnCard = 'John Smith';
           ppe.setNewAttachments[0].expirationMonth = '11';
           ppe.setNewAttachments[0].expirationYear = '20';
           ppe.setNewAttachments[0].cvvNumber = 123;
           ppe.setNewAttachments[0].billingAddress = '45831 Waterside Drive';
           ppe.setNewAttachments[0].billingCity = 'Macomb';
           ppe.setNewAttachments[0].billingState = 'MI';
           ppe.setNewAttachments[0].billingZip = '48044';
           
           PageReference pr3 = ppe.savePaymentPlan();
           
           Card_Information__c ci = new Card_Information__c();
           
           Payment_Plan_Line_Items__c ppli = new Payment_Plan_Line_Items__c();
           List<Payment_Plan_Line_Items__c> ppliList = new List<Payment_Plan_Line_Items__c>();
           ppliList.add(ppli);
           
           Boolean Flag2 = ppe.checkRequiredFieldsCardInformation(ci);
           Boolean Flag3 = ppe.checkRequiredFieldsPPLI(ppliList);
           
          
       }       
       test.StopTest();
             
      }
      
      public Static testmethod void paymentPlansExtTest_Monthly(){
       test.startTest();
       system.runAs(userAdmin){
           createSampleData();
           
           ApexPages.currentPage().getParameters().put('Id', oms.id);
           
           paymentPlanController = new ApexPages.StandardController(oms);
           ppe = new paymentPlansExt(paymentPlanController); 
           
           ppe.setmodeOfPayment('Debit/Credit Card');
           ppe.setpaymentPlanType('Monthly');
           ppe.settypeOfCollection('Deductible');
           
           ppe.tempPaymentPlan.Start_Date__c = date.Today();
           ppe.tempPaymentPlan.Total_Amount_To_Be_Collected__c = 1000;
           ppe.tempPaymentPlan.Number_of_Installments__c = 1;
           
           /*for(paymentPlansExt.paymentPlanLineItems li : ppe.paymentPlanLineItemsList){
               li.amount = 1000;
               li.dueDate = date.Today();
           }
           */
           ppe.setNewAttachments[0].cardNumber = '1234123412341234';
           ppe.setNewAttachments[0].nameOnCard = 'John Smith';
           ppe.setNewAttachments[0].expirationMonth = '11';
           ppe.setNewAttachments[0].expirationYear = '20';
           ppe.setNewAttachments[0].cvvNumber = 123;
           ppe.setNewAttachments[0].billingAddress = '45831 Waterside Drive';
           ppe.setNewAttachments[0].billingCity = 'Macomb';
           ppe.setNewAttachments[0].billingState = 'MI';
           ppe.setNewAttachments[0].billingZip = '48044';
           
           PageReference pr3 = ppe.savePaymentPlan();
           
           
           
          
       }       
       test.StopTest();
             
      }
}