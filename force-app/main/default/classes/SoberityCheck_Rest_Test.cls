@istest
public class SoberityCheck_Rest_Test {
    public static testMethod void  Test1(){
        Alumni_App_Detail__c appdet = new Alumni_App_Detail__c();
        insert appdet;

        Alumni_App_Challenges_Configurations__c app = new Alumni_App_Challenges_Configurations__c();
        app.Name = 'test';
        app.Challenge_Description__c = 'test';
        app.Challenge_Landscape_Image__c = 'www.test.com';
        app.Challenge_Medal_Image__c = 'www.test.com';
        app.Challenge_Thumbnail_Image__c = 'www.test.com';
        app.Streak_Duration__c = 10;
        insert app;

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
        System.debug('@appSobriety'+appSobriety);

        Alumni_App_Challenges_Line_Items__c sobLi = new Alumni_App_Challenges_Line_Items__c();
        sobLi.Alumni_App_Challenges_Configuration__c = app.id;
        sobLi.Alumni_App_Detail__c = appdet.id;
        sobLi.name = 'test';
        insert sobLi;


        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/sobriety_check';
        req.addHeader('id', appdet.id);
        req.requestBody = Blob.valueOf('{"note":"","feeling":"Happy","anxious":1,"depressed":1,"craving":1}');
        req.httpMethod = 'Post';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        SoberityCheck_Rest.SoberityCheckRequestWrapper wrap = new SoberityCheck_Rest.SoberityCheckRequestWrapper();
        wrap.loginId = appdet.id;
        SoberityCheck_Rest.addSoberityCheck();
        //SobrietyHistory_Rest.sObretyHistoryResp wrap = new SobrietyHistory_Rest.sObretyHistoryResp(appdet.id);
        //wrap.recordId = appdet.id;
        //SobrietyHistory_Rest.badges b;
        //SobrietyHistory_Rest.HistroyResponseWrapper hp;
        Test.stopTest();  
    
    }

    public static testMethod void  Test2(){
        Alumni_App_Detail__c appdet = new Alumni_App_Detail__c();
        insert appdet;

        Alumni_App_Challenges_Configurations__c app = new Alumni_App_Challenges_Configurations__c();
        app.Name = 'test';
        app.Challenge_Description__c = 'test';
        app.Challenge_Landscape_Image__c = 'www.test.com';
        app.Challenge_Medal_Image__c = 'www.test.com';
        app.Challenge_Thumbnail_Image__c = 'www.test.com';
        app.Streak_Duration__c = 10;
        insert app;

        Alumni_App_Sobriety_Checkin__c appSobriety = new Alumni_App_Sobriety_Checkin__c();
        appSobriety.name = 'test';
        appSobriety.Anxiety_Score__c = '1'; 
        appSobriety.Cravings_Score__c = '1';
        appSobriety.Depression_Score__c = '1';
        appSobriety.Feeling_Today__c = 'Fine'; 
        appSobriety.Notes__c =  '1';
        appSobriety.Sobriety_Checkin_Date__c = date.today().addDays(2);
        appSobriety.Alumni_App_Detail__c = appdet.id;
        insert appSobriety;
        System.debug('@appSobriety'+appSobriety);

        Alumni_App_Challenges_Line_Items__c sobLi = new Alumni_App_Challenges_Line_Items__c();
        sobLi.Alumni_App_Challenges_Configuration__c = app.id;
        sobLi.Alumni_App_Detail__c = appdet.id;
        sobLi.name = 'test';
        insert sobLi;


        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/sobriety_check/';
        req.httpMethod = 'Post';
        req.addHeader('Content-Type', 'application/json'); 
        req.requestBody = Blob.valueOf('{"note":"","feeling":"Happy","anxious":1,"depressed":1,"craving":1}');
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        SobrietyHistory_Rest.sObretyHistoryResp wrap = new SobrietyHistory_Rest.sObretyHistoryResp(appdet.id);
        SoberityCheck_Rest.addSoberityCheck();

        Test.stopTest();  
    
    }

    public static testMethod void  Test3(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/sobriety_check/';
        req.httpMethod = 'Post';
        req.addHeader('id', '00001'); 
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        SoberityCheck_Rest.addSoberityCheck();
        Test.stopTest();  
    
    }

    
}