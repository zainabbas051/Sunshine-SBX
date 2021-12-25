@istest
public without sharing class Coach_Rest_Test {
    
    public static testMethod void  Test1(){
        
        Alumni_App_Daily_Content__c con = new Alumni_App_Daily_Content__c();
        con.Name = 'test';
        con.Type__c = 'Clinical Video';
        con.Content_Body__c = 'test';
        con.Author__c = 'test author';
        con.Main_Image_URL__c = 'www.test.com';
        con.Thumbnail_Image_URL__c = 'www.test.com';
        insert con;

        Alumni_App_Daily_Content__c con1 = new Alumni_App_Daily_Content__c();
        con1.Name = 'test';
        con1.Type__c = 'Clinical Video';
        con1.Content_Body__c = 'test';
        con1.Author__c = 'test author';
        con1.Main_Image_URL__c = 'www.test.com';
        con1.Thumbnail_Image_URL__c = 'www.test.com';
        insert con1;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/learn_home';
        req.addParameter('max','2');
        req.addParameter('page','1');
        req.addParameter('type','video');
        req.httpMethod = 'Get';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        Coach_Rest.showLearningMaterial();
        Test.stopTest();  
    
    }
    public static testMethod void  Test2(){
        
        Alumni_App_Daily_Content__c con = new Alumni_App_Daily_Content__c();
        con.Name = 'test';
        con.Type__c = 'Clinical Audio';
        con.Content_Body__c = 'test';
        con.Author__c = 'test author';
        con.Main_Image_URL__c = 'www.test.com';
        con.Thumbnail_Image_URL__c = 'www.test.com';
        insert con;

        Alumni_App_Daily_Content__c con1 = new Alumni_App_Daily_Content__c();
        con1.Name = 'test';
        con1.Type__c = 'Clinical Audio';
        con1.Content_Body__c = 'test';
        con1.Author__c = 'test author';
        con1.Main_Image_URL__c = 'www.test.com';
        con1.Thumbnail_Image_URL__c = 'www.test.com';
        insert con1;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/learn_home';
        req.addParameter('max','2');
        req.addParameter('page','1');
        req.addParameter('type','audio');
        req.httpMethod = 'Get';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        Coach_Rest.showLearningMaterial();
        Test.stopTest();  
    
    }
    public static testMethod void  Test3(){
        
        Alumni_App_Daily_Content__c con = new Alumni_App_Daily_Content__c();
        con.Name = 'test';
        con.Type__c = 'Clinical Articles';
        con.Content_Body__c = 'test';
        con.Author__c = 'test author';
        con.Main_Image_URL__c = 'www.test.com';
        con.Thumbnail_Image_URL__c = 'www.test.com';
        insert con;

        Alumni_App_Daily_Content__c con1 = new Alumni_App_Daily_Content__c();
        con1.Name = 'test';
        con1.Type__c = 'Clinical Articles';
        con1.Content_Body__c = 'test';
        con1.Author__c = 'test author';
        con1.Main_Image_URL__c = 'www.test.com';
        con1.Thumbnail_Image_URL__c = 'www.test.com';
        insert con1;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/learn_home';
        req.addParameter('max','2');
        req.addParameter('page','1');
        req.addParameter('type','text');
        req.httpMethod = 'Get';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        Coach_Rest.showLearningMaterial();
        Test.stopTest();  
    
    }

    public static testMethod void  Test4(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/learn_home';
        req.httpMethod = 'Get';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        Coach_Rest.showLearningMaterial();
        Test.stopTest();  
    
    }
}