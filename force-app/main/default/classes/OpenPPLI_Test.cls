@isTest
    public with sharing class OpenPPLI_Test {

    Public static Account a;
    Public static Opportunity oms;
    Public static Payment_Plan__c ppRecord;
    public static Payment_Plan_Line_Items__c ppli;
    public static Card_Information__c ciRecord;
    public static Payment_Plan_Refund_Request__c pprr;
    public static Invoice_Process_Request__c iprr;
    Public static User u_test;
    public Static Profile adminProfile;
    public Static ApexPages.StandardController paymentPlanController;
    public Static paymentPlansDetailExt ppde;

    @TestSetup 
   static void createData() {
     
        Account a = new Account();
        a.Name = 'Monarch Shores';
        a.Type = 'Internal Center';
        insert a;

        Account a1 = new Account();
        a1.Name = 'Monarch Shores';
        a1.Type = 'Treatment Center';
        insert a1;
        
        Schema.DescribeSObjectResult opp = Schema.SObjectType.Opportunity;
        Map<String, Schema.RecordTypeInfo> rtMapByNameOpp = opp.getRecordTypeInfosByName();
        Id recTypeIdOpp = rtMapByNameOpp.get('Monarch Shores').getRecordTypeId(); 
        
        Employee__c emp = new Employee__c();
        emp.Name = 'Test Supervisor';
        emp.Sunshine_Center_Relation_To__c = a.id;
        emp.Sunshine_Center_Access__c = 'Monarch Shores';
        insert emp;

        Opportunity oms = new Opportunity();
        oms.Name = 'test opp';
        oms.RecordTypeId = recTypeIdOpp;
        oms.Account = a;
        oms.Selected_Treatment_Center__c = a1.id;
        oms.Closing_Agent__c = UserInfo.getUserId();
        oms.Amount = 999;
        oms.StageName = 'Working';
        oms.CloseDate = date.Today();
        oms.Test_Class_Checkbox__c = True;
        oms.Sunshine_Center__c = a.id;
        insert oms;
        
        Payment_Plan__c ppRecord = new Payment_Plan__c();
        ppRecord.Opportunity__c = oms.id;
        ppRecord.Start_Date__c = date.Today().addDays(-60);
        ppRecord.Total_Amount_To_Be_Collected__c = 1000;
        ppRecord.Payment_Plan_Type__c = 'Custom';
        insert ppRecord;
        
        Payment_Plan_Line_Items__c ppl = new Payment_Plan_Line_Items__c();
        ppl.Type_of_Collection__c = 'Housing';
        ppl.Payment_Plan__c = ppRecord.Id;
        ppl.Status__c = 'Open';
        ppl.Due_Date__c = Date.today().addDays(-30);
        insert ppl;
        
        Payment_Plan_Line_Items__c ppll = new Payment_Plan_Line_Items__c();
        ppll.Type_of_Collection__c = 'Housing';
        ppll.Payment_Plan__c = ppRecord.Id;
        ppll.Status__c = 'Open';
        ppll.Due_Date__c = Date.today().addDays(-30);
        insert ppll;
        
        Card_Information__c ci = new Card_Information__c();
        ci.Card_Number__c = '123';
        ci.Name_on_Card__c = 'Safia';
        ci.Payment_Plan__c = ppRecord.Id;
        ci.Expiration_Year__c = '2024';
        ci.Expiration_Month__c = '02';
        insert ci;
    }
    

    static testMethod void testMethod1(){
        Opportunity oppty = [Select id from opportunity limit 1];
        List<Payment_Plan_Line_Items__c> ppli = [Select id, Status__c,Payment_Plan__c, Amount_For_Collection__c, Sunshine_Center__c from Payment_Plan_Line_Items__c  where Status__c = 'Open' limit 1];
        Card_Information__c ci=[Select id,Card_Number__c,Name_on_Card__c,Payment_Plan__c,Expiration_Year__c,Expiration_Month__c from Card_Information__c where Payment_Plan__c =:ppli[0].Payment_Plan__c limit 1 ];
        Employee__c emp = [select id, Sunshine_Center_Relation_To__c, Sunshine_Center_Access__c from Employee__c ];
        OpenHousingPPLI_Ctrl.getAllSunshinesAccess(emp.id);
        OpenHousingPPLI_Ctrl.getAllPPLIs(1, 0, emp.id);
        OpenHousingPPLI_Ctrl.getPPLIsByFilter(1, 1, emp.Id);
        system.debug(ppli[0].Sunshine_Center__c);

    }
}