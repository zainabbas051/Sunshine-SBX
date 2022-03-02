@istest
public with sharing class AlumniAppDetail_Batch_Test {
    
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
        appSobriety.Sobriety_Checkin_Date__c = date.today().addDays(-1);
        appSobriety.Alumni_App_Detail__c = appdet.id;
        insert appSobriety;
        System.debug('@appSobriety'+appSobriety);

        Alumni_App_Sobriety_Checkin__c appSobriety1 = new Alumni_App_Sobriety_Checkin__c();
        appSobriety1.name = 'test';
        appSobriety1.Anxiety_Score__c = '1'; 
        appSobriety1.Cravings_Score__c = '1';
        appSobriety1.Depression_Score__c = '1';
        appSobriety1.Feeling_Today__c = 'Fine'; 
        appSobriety1.Notes__c =  '1';
        appSobriety1.Sobriety_Checkin_Date__c = date.today().addDays(-1);
        appSobriety1.Alumni_App_Detail__c = appdet.id;
        insert appSobriety1;

        Alumni_App_Challenges_Line_Items__c sobLi = new Alumni_App_Challenges_Line_Items__c();
        sobLi.Alumni_App_Challenges_Configuration__c = app.id;
        sobLi.Alumni_App_Detail__c = appdet.id;
        sobLi.name = 'test';
        insert sobLi;


        
        Test.startTest();
        database.executebatch(new AlumniAppDetail_Batch());
        
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

        appdet.Longest_Checkin__c = 0;
        appdet.Current_Checkin_Streak__c = 1;
        update appdet;
        Test.startTest();
        database.executebatch(new AlumniAppDetail_Batch());
        
        Test.stopTest();  
    
    }
}
