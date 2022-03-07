@isTest
public with sharing class AlumniApp_VerifyOtp_Test {

    public static testMethod void  Test1(){
        Alumni_App_Detail__c appdet = new Alumni_App_Detail__c();
        appdet.username__c = 't@t.com';
        appdet.Password__c = '123';
        appdet.User_Email__c = 't@t.com';
        appdet.Optp_Token_s__c = '1212';
        insert appdet;

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/sobriety_check';
        req.requestBody = Blob.valueOf('{"email" : "t@t.com","otp" : "1212"}');
        req.httpMethod = 'Post';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        AlumniApp_VerifyOtp.verifyOtp();
        Test.stopTest();  
    
    }

    public static testMethod void  Test2(){
        Alumni_App_Detail__c appdet = new Alumni_App_Detail__c();
        appdet.username__c = 't@t.com';
        appdet.Password__c = '123';
        appdet.User_Email__c = 't@t.com';
        appdet.Optp_Token_s__c = '1212';
        insert appdet;

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/sobriety_check';
        req.requestBody = Blob.valueOf('{"email" : "t@t.com","otp" : "34310"}');
        req.httpMethod = 'Post';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        AlumniApp_VerifyOtp.verifyOtp();
        Test.stopTest();  
    
    }

    public static testMethod void  Test3(){
        Alumni_App_Detail__c appdet = new Alumni_App_Detail__c();
        appdet.username__c = 't@t.com';
        appdet.Password__c = '123';
        appdet.User_Email__c = 't@t.com';
        appdet.Optp_Token_s__c = '1212';
        insert appdet;

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/sobriety_check';
        //req.requestBody = Blob.valueOf('{"email" : "t1@t.com"}');
        req.httpMethod = 'Post';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        AlumniApp_VerifyOtp.verifyOtp();
        Test.stopTest();  
    
    }
    
}