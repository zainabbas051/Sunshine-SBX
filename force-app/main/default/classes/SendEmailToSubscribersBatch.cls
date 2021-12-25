public without sharing class SendEmailToSubscribersBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
    public list<Report_Dashboard_Schedules__mdt> listMdt;
    public SendEmailToSubscribersBatch() {
        listMdt = [select id, DeveloperName, MasterLabel,
                        Day_of_Week__c, Email_Recipients__c, 
                        Report_Dashboard_ID__c, Time_of_Day__c, 
                        Type__c from Report_Dashboard_Schedules__mdt];

    }
    public SendEmailToSubscribersBatch(boolean forTestClass) {
        if(forTestClass){
            listMdt = [select id, DeveloperName, MasterLabel,
                        Day_of_Week__c, Email_Recipients__c, 
                        Report_Dashboard_ID__c, Time_of_Day__c, 
                        Type__c from Report_Dashboard_Schedules__mdt];
        }
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        string q = 'select id, DeveloperName, MasterLabel, Day_of_Week__c, Email_Recipients__c, Report_Dashboard_ID__c, Time_of_Day__c, Type__c from Report_Dashboard_Schedules__mdt';
        return Database.getQueryLocator(q);
    }

    public void execute(Database.BatchableContext BC, List<Report_Dashboard_Schedules__mdt> scope){
        if(test.isRunningTest())
            scope = listMdt;
        
        for(Report_Dashboard_Schedules__mdt mdtRec : scope){
            sendEmailToSubscribers.sendEmailToSubscribers(mdtRec);
        }
    }
    
    public void finish(Database.BatchableContext BC){
    }
}