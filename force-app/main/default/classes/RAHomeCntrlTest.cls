@isTest
public class RAHomeCntrlTest{
    
     public Static Profile adminProfile;
    
    public static User userAdmin
    {
        get{
            if (userAdmin == null )
            {
                adminProfile = [Select Id, Name From Profile where name = 'System Administrator' limit 1];
                userAdmin  = new user (Username = ' test@key.net', FirstName = 'FirstTest', LastName ='LastTest', alias = 'FLast', 
                            email='test@key.net', communityNickname='test0101019', TimeZoneSidKey='America/New_York',
                            LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId=adminProfile.Id ,
                            LanguageLocaleKey='en_US', Acess_Type__c='Admin');
                insert userAdmin;             
             }
             return userAdmin;
            }
        set;
    }

     static testMethod void RACtrlTest(){
        
         test.startTest();
         system.runAs(userAdmin){
             TabViews__c tv = new TabViews__c();
             tv.Name = 'RecurringAssessments';
             tv.Button_Access_Type__c = 'Admin';
             insert tv;
             
             Account a = new Account();
             a.Name = 'Monarch Shores';
             a.Type = 'Internal Center';
             insert a;
             
                 
             Client_Chart__c cl = new Client_Chart__c();
             cl.Treatment_Center__c = a.ID;
             cl.Primary_Therapist__c = UserINFO.getUserID();
             cl.RecordTypeID = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
             insert cl;
             
             Recurring_Assessment__c ra = new Recurring_Assessment__c();
             ra.Client_Chart__c = cl.ID;
             ra.Name = 'Config';
             ra.Vital_SIgns_Required__c = true;
             ra.Vital_SIgns_Recurring_Time__c = 'Q2 Hours';
             ra.CIWA_Assessment_Required__c = true;
             ra.CIWA_Assessment_Recurring_Time__c = 'Q2 Hours';
             ra.COWS_Assessment_Required__c = true;
             ra.COWS_Assessment_Recurring_Time__c = 'Q2 Hours';
             ra.BMI_Assessment_Required__c = true;
             ra.BMI_Assessment_Recurring_Time__c = 'Every 7 Days';
             ra.Blood_Glucose_Assessment_Required__c = true;
             ra.Blood_Glucose_Assessment_Recurring_Time__c = 'Q4 Hours';
             ra.Detox_Required__c = true;
             ra.Detox_Recurring_Time__c = 'Q15';
             ra.RecordTypeId = Schema.SObjectType.Recurring_Assessment__c.getRecordTypeInfosByName().get('Configurations').getRecordTypeId();
             insert ra;
             
             Test.setCurrentPageReference(new PageReference('/apex/RAHome'));
             System.currentPageReference().getParameters().put('ID', cl.ID);
             
             RAHomeCntrl raCtrl = new RAHomeCntrl();
             raCtrl.RecurringAssessments();
             raCtrl.ra.Name = null;
             raCtrl.upateConfig();
             
             Boolean Flag = raCtrl.buttonAccessType;
         }
         test.stopTest();
     }
    
    static testMethod void RACtrlTest2(){
        
         test.startTest();
         system.runAs(userAdmin){
             TabViews__c tv = new TabViews__c();
             tv.Name = 'RecurringAssessments';
             tv.Button_Access_Type__c = 'Admin';
             insert tv;
             
             Account a = new Account();
             a.Name = 'Monarch Shores';
             a.Type = 'Internal Center';
             insert a;
             
                 
             Client_Chart__c cl = new Client_Chart__c();
             cl.Treatment_Center__c = a.ID;
             cl.Primary_Therapist__c = UserINFO.getUserID();
             cl.RecordTypeID = Schema.SObjectType.Client_Chart__c.getRecordTypeInfosByName().get('Monarch Shores').getRecordTypeId();
             insert cl;
             
             Test.setCurrentPageReference(new PageReference('/apex/RAHome'));
             System.currentPageReference().getParameters().put('ID', cl.ID);
             
             RAHomeCntrl raCtrl = new RAHomeCntrl();
             raCtrl.RecurringAssessments();
            
             raCtrl.upateConfig();

         }
         test.stopTest();
     }

}