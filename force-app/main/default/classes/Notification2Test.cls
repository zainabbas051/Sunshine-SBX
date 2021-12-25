@isTest
private class Notification2Test
{
    
    private static testmethod void noti2Test(){    
        /*
        EmailTemplate validEmailTemplate = new EmailTemplate();
        validEmailTemplate.isActive = true;
        validEmailTemplate.Name = 'name';
        validEmailTemplate.DeveloperName = 'unique_name_addSomethingSpecialHere';
        validEmailTemplate.TemplateType = 'text';
        validEmailTemplate.FolderId = UserInfo.getUserId();
        
        insert validEmailTemplate;
        */
        
        EmailTemplate temp = [select id from EmailTemplate limit 1];
        
        list<Notification_Setting__c> lstCs = new list<Notification_Setting__c>();
        Notification_Setting__c cs1 = new Notification_Setting__c();
        cs1.Name = 'Blood Glucose';
        
        cs1.Object_name__c = 'Recurring_Assessment__c';
        cs1.Subject__c = 'Test';
        cs1.Message_Body__c = 'Test body';
        cs1.Record_Type_Name__c = ' Blood Glucose';
        cs1.First_Interval_Notification__c = 1; 
        cs1.Is_15_Min__c = false;
        cs1.Notification_Ending_Status__c = 'Closed';
        cs1.Filter_Field_API_Name__c = 'Status__c';
        cs1.Filter_Field_2_API_Name__c  = 'Time_Due__c';
        cs1.Type_of_Notification__c = 'text';
        cs1.Sunshine_Center__c = 'Monarch Shores';
        cs1.Recursive_Interval_Notification__c = 1;
        cs1.Common_House_Phone_Number__c = '123';
        cs1.TemplateID__c = temp.id;//validEmailTemplate.id;
        cs1.Recursive_Template_ID__c = temp.id;
        lstCs.add(cs1);
        
        Notification_Setting__c cs2 = new Notification_Setting__c();
        cs2.Name = 'Vital Signs';        
        cs2.Object_name__c = 'Recurring_Assessment__c';
        cs2.Subject__c = 'Test';
        cs2.Message_Body__c = 'Test body';
        cs2.Record_Type_Name__c = 'Vital Signs';
        cs2.First_Interval_Notification__c = 1; 
        cs2.Is_15_Min__c = false;
        cs2.Notification_Ending_Status__c = 'Closed';
        cs2.Filter_Field_API_Name__c = 'Status__c';
        cs2.Type_of_Notification__c = 'text';
        cs2.Sunshine_Center__c = 'Monarch Shores';
        cs2.Recursive_Interval_Notification__c =1;
        cs2.Common_House_Phone_Number__c = '123';
        cs2.TemplateID__c = temp.id;//validEmailTemplate.id;
        cs2.Filter_Field_2_API_Name__c  = 'Time_Due__c';
        cs2.Recursive_Template_ID__c = temp.id;
        lstCs.add(cs2);
                
        insert lstCs;
            
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
        
        list<Recurring_Assessment__c> lstRA = new list<Recurring_Assessment__c>();
        
         Recurring_Assessment__c recu;
         
         for(integer i=0;i<10;i++){
             recu = new Recurring_Assessment__c();
             recu.Client_Chart__c = cl.ID;
             recu.Time_Due__c = DateTime.Now().addMinutes(-5);
             //recu.Status__c = 'Closed';
             
             recu.RecordTypeID = Schema.SObjectType.Recurring_Assessment__c.getRecordTypeInfosByName().get('Vital Signs').getRecordTypeId();
             lstRA.add(recu);
        }  
        for(integer i=0;i<10;i++){
             recu = new Recurring_Assessment__c();
             recu.Client_Chart__c = cl.ID;
             recu.Time_Due__c = DateTime.Now().addMinutes(-5);
             //recu.Status__c = 'Closed';
             
             recu.RecordTypeID = Schema.SObjectType.Recurring_Assessment__c.getRecordTypeInfosByName().get('Blood Glucose').getRecordTypeId();
             lstRA.add(recu);
        }  
        if(lstRA.size()>0)
            insert lstRA;
        
        Test.startTest();
        
        Notification2 obj = new Notification2 ();
        obj.SendDynamicNotification();    
        
        Notification2Batch b = new Notification2Batch();
        database.executebatch(b);    
         
        Test.stopTest();
    }

}