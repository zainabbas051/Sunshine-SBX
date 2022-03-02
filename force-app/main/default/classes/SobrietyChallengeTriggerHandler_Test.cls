@istest
public with sharing class SobrietyChallengeTriggerHandler_Test {
    public static testMethod void  Test1(){
        Alumni_App_Challenges_Configurations__c app = new Alumni_App_Challenges_Configurations__c();
        app.Name = 'test';
        app.Challenge_Description__c = 'test';
        app.Challenge_Landscape_Image__c = 'www.test.com';
        app.Challenge_Medal_Image__c = 'www.test.com';
        app.Challenge_Thumbnail_Image__c = 'www.test.com';
        app.Streak_Duration__c = 1;
        app.Type__c = 'Daily Checkin';
        insert app;

        Alumni_App_Challenges_Configurations__c app1 = new Alumni_App_Challenges_Configurations__c();
        app1.Name = 'test';
        app1.Challenge_Description__c = 'test';
        app1.Challenge_Landscape_Image__c = 'www.test.com';
        app1.Challenge_Medal_Image__c = 'www.test.com';
        app1.Challenge_Thumbnail_Image__c = 'www.test.com';
        app1.Streak_Duration__c = 1;
        app1.Type__c = 'Total Checkin';
        insert app1;

        Alumni_App_Challenges_Configurations__c app11 = new Alumni_App_Challenges_Configurations__c();
        app11.Name = 'test';
        app11.Challenge_Description__c = 'test';
        app11.Challenge_Landscape_Image__c = 'www.test.com';
        app11.Challenge_Medal_Image__c = 'www.test.com';
        app11.Challenge_Thumbnail_Image__c = 'www.test.com';
        app11.Streak_Duration__c = 5;
        app11.Type__c = 'Daily Checkin';
        insert app11;

        Alumni_App_Challenges_Configurations__c app12 = new Alumni_App_Challenges_Configurations__c();
        app12.Name = 'test';
        app12.Challenge_Description__c = 'test';
        app12.Challenge_Landscape_Image__c = 'www.test.com';
        app12.Challenge_Medal_Image__c = 'www.test.com';
        app12.Challenge_Thumbnail_Image__c = 'www.test.com';
        app12.Streak_Duration__c = 5;
        app12.Type__c = 'Total Checkin';
        insert app12;
        
        Alumni_App_Detail__c appdet = new Alumni_App_Detail__c();
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
        
        System.debug('@appSobriety'+appSobriety);

        /*Alumni_App_Challenges_Line_Items__c sobLi = new Alumni_App_Challenges_Line_Items__c();
        sobLi.Alumni_App_Challenges_Configuration__c = app.id;
        sobLi.Alumni_App_Detail__c = appdet.id;
        sobLi.name = 'test';
        insert sobLi;
        */
        Test.startTest();
        insert appSobriety;
        Test.stopTest();  
    
    }

}
