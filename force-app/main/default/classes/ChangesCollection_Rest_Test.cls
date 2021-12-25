@istest
public with sharing class ChangesCollection_Rest_Test {
    
    public static testMethod void  Test1(){
    
        Alumni_App_Challenges_Configurations__c app = new Alumni_App_Challenges_Configurations__c();
        app.Name = 'test';
        app.Challenge_Description__c = 'test';
        app.Challenge_Landscape_Image__c = 'www.test.com';
        app.Challenge_Medal_Image__c = 'www.test.com';
        app.Challenge_Thumbnail_Image__c = 'www.test.com';
        app.Streak_Duration__c = 10;
        insert app;

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/challenges';
        req.addParameter('max','2');
        req.addParameter('page','1');
        req.httpMethod = 'Get';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res; 
        Test.startTest();
        ChangesCollection_Rest.showChallengesCollection();

        Test.stopTest();  
    
    }

    public static testMethod void  Test2(){
    
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/challenges';
        req.httpMethod = 'Get';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res; 
        Test.startTest();
        ChangesCollection_Rest.showChallengesCollection();
        
        Test.stopTest();  
    
    }

    public static testMethod void  Test3(){
    
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/challenges';
        req.addParameter('max','abc');
        req.addParameter('page','xyz');
        req.httpMethod = 'Get';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res; 
        Test.startTest();
        ChangesCollection_Rest.showChallengesCollection();
        
        Test.stopTest();  
    
    }


}