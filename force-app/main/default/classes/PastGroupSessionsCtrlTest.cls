@isTest
public class PastGroupSessionsCtrlTest {
    
    
        static testMethod void Test1(){
            
            
                 Group_Therapy_Session__c grp = new Group_Therapy_Session__c();
                 grp.Status__c = 'Open';
                 grp.RecordTypeID = Schema.SObjectType.Group_Therapy_Session__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
                 grp.Date__c = Date.Today();
                 grp.Start_Time__c = '03:30 AM';
                 grp.End_Time__c = '05:30 AM';
                 grp.Date__c = Date.Today().AddDays(-2);
                 insert grp;
                 
                  grp = new Group_Therapy_Session__c();
                 grp.Status__c = 'Open';
                 grp.RecordTypeID = Schema.SObjectType.Group_Therapy_Session__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
                 grp.Date__c = Date.Today();
                 grp.Start_Time__c = '03:30 AM';
                 grp.End_Time__c = '05:30 AM';
                 grp.Date__c = Date.Today().AddDays(-6);
                 insert grp;
                 
                Test.setCurrentPageReference(new PageReference('/apex/GroupSessions'));
                System.currentPageReference().getParameters().put('rt', 'Monarch Shores');
                PastGroupSessionsCtrl p = new PastGroupSessionsCtrl();
                p.getPreviousWeek();
                p.GetNextWeek();
                
            
        }
    
}