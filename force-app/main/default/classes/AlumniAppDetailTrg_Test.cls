@isTest
public with sharing class AlumniAppDetailTrg_Test {
   
    static testMethod void testMethod1(){
        Alumni_App_Challenges_Configurations__c ch11 = new Alumni_App_Challenges_Configurations__c();
        ch11.name = '5 day daily challenge';
        ch11.Streak_Duration__c = 5;
        ch11.Type__c = 'Daily Checkin';
        insert ch11;

        Alumni_App_Challenges_Configurations__c ch22 = new Alumni_App_Challenges_Configurations__c();
        ch22.name = '5 day total challenge';
        ch22.Streak_Duration__c = 5;
        ch22.Type__c = 'Total Checkin';
        insert ch22;
        
        Alumni_App_Challenges_Configurations__c ch1 = new Alumni_App_Challenges_Configurations__c();
        ch1.name = '1 day daily challenge';
        ch1.Streak_Duration__c = 1;
        ch1.Type__c = 'Daily Checkin';
        insert ch1;
        
        Alumni_App_Challenges_Configurations__c ch2 = new Alumni_App_Challenges_Configurations__c();
        ch2.name = '1 day total challenge';
        ch2.Streak_Duration__c = 1;
        ch2.Type__c = 'Total Checkin';
        insert ch2;

        
        test.startTest();
        Alumni_App_Detail__c appDetail = new Alumni_App_Detail__c();
        appDetail.username__c = 'test';
        insert appDetail;
        test.stopTest();
        
    }
}
