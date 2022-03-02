@istest
public without sharing class AlumniAppLogin_Rest_Test {
    
    public static testMethod void  Test1(){
        
        Alumni_App_Detail__c appdet = new Alumni_App_Detail__c();
        appdet.User_Email__c = 'test@test.com';
        appdet.Username__c = 'test@test.com';
        appdet.Password__c = '123test';
        insert appdet;

        Alumni_App_Sobriety_Checkin__c appSobriety = new Alumni_App_Sobriety_Checkin__c();
        appSobriety.name = 'test';
        appSobriety.Anxiety_Score__c = '1'; 
        appSobriety.Cravings_Score__c = '1';
        appSobriety.Depression_Score__c = '1';
        appSobriety.Feeling_Today__c = 'Fine'; 
        appSobriety.Notes__c =  '1';
        appSobriety.Sobriety_Checkin_Date__c = date.today();
        appSobriety.Alumni_App_Detail__c = appdet.id;
        insert appSobriety;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/Login';
        req.addParameter('email','test@test.com');
        req.addParameter('password','123test');
        req.addParameter('device_token','abc1234');
        req.httpMethod = 'Get';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        AlumniAppLogin_Rest.getLogin();
        AlumniAppDetail_Selector.getUserDetailByUserName('test@test.com');
        Test.stopTest();  
    
    }

    public static testMethod void  Test2(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/Login';
        req.addParameter('email','test@test.com');
        req.addParameter('password','123test');
        req.addParameter('device_token','abc1234');
        req.httpMethod = 'Get';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        AlumniAppLogin_Rest.getLogin();
        Test.stopTest();  
    
    }

    public static testMethod void  Test3(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/Login';
        req.httpMethod = 'Get';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        AlumniAppLogin_Rest.getLogin();
        Test.stopTest();  
    
    }
}