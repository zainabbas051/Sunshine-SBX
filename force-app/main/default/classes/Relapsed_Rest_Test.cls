@istest
public with sharing class Relapsed_Rest_Test {
    
    public static testMethod void  Test1(){
        
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
        oms.Phone__c = '111222333';
        oms.Email__c = 't@t.com';
        insert oms;
        
        Alumni_App_Detail__c appdet = new Alumni_App_Detail__c();
        appdet.Opportunity__c = oms.id;
        insert appdet;


        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/relapsed';
        req.addHeader('id', appdet.id);
        //req.requestBody = Blob.valueOf('{"note":"","feeling":"Happy","anxious":1,"depressed":1,"craving":1}');
        req.httpMethod = 'Post';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        Relapsed_Rest.checkRelapsed();
        Test.stopTest();
    }


    public static testMethod void  Test2(){
        
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
        oms.Phone__c = '111222333';
        oms.Email__c = 't@t.com';
        insert oms;
        
        Alumni_App_Detail__c appdet = new Alumni_App_Detail__c();
        appdet.Opportunity__c = oms.id;
        insert appdet;


        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/relapsed';
        //req.addHeader('id', appdet.id);
        //req.requestBody = Blob.valueOf('{"note":"","feeling":"Happy","anxious":1,"depressed":1,"craving":1}');
        req.httpMethod = 'Post';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        Relapsed_Rest.checkRelapsed();
        Test.stopTest();
    }
}
