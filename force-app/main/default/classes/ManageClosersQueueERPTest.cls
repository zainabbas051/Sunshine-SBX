@isTest
private class ManageClosersQueueERPTest{
    
    public static ERP_Closer_Queue_Assignment_Schedule__c msacs;
    public static QueueSobject qs;
    public static Group grp;
    public static User userAdmin
    {
        get{
            if (userAdmin == null )
            {
                userAdmin  = [select id, name from User where Profile.name=:'System Administrator' limit 1];
            }
            return userAdmin;
            }
        set;
    }
    
    public Static void createSampleData(){
        
        qs = [Select QueueId from QueueSobject Where SobjectType=:'Lead' LIMIT 1];
            
        grp = [Select Id, Name from Group where id=: qs.QueueId LIMIT 1];
        
        msacs = New ERP_Closer_Queue_Assignment_Schedule__c();
        //msacs.User__c = userAdmin.id;
        insert msacs;
    }
    
      public Static testmethod void DMCRRelatedCase_SelectAll(){
          DMCRRelatedCase_SelectAll.SelectAll('Account');
      }
    
    public Static testmethod void ManageAdmisionCoordinatorTest(){
        test.startTest();
        
            createSampleData();
            
            
            
            
            ManageClosersQueueERP mac = new ManageClosersQueueERP();
            mac.cancel();
            
            //Testing the Edit, Save and Deleting existing record.
            mac.indexVal = 0;
            mac.showEditUserScreen();
            mac.saveCQ();
            mac.deleteCQ();
            
            //Testing Add New, Save and Validations
            mac.showAddQueueScreen();
            mac.tempCQRecord.Name = grp.Name;
            
            
            //Validation to make sure that Start and End Time need to be put in if the Day OFF is set to False
            mac.tempCQRecord.Monday_OFF__c= False;
            mac.tempCQRecord.Monday_Start_Time__c = null;
            mac.tempCQRecord.Monday_End_Time__c = null;
            mac.tempCQRecord.Tuesday_OFF__c= False;
            mac.tempCQRecord.Tuesday_Start_Time__c = null;
            mac.tempCQRecord.Tuesday_End_Time__c = null;
            mac.tempCQRecord.Wednesday_OFF__c= False;
            mac.tempCQRecord.Wednesday_Start_Time__c = null;
            mac.tempCQRecord.Wednesday_End_Time__c = null;
            mac.tempCQRecord.Thursday_OFF__c= False;
            mac.tempCQRecord.Thursday_Start_Time__c = null;
            mac.tempCQRecord.Thursday_End_Time__c = null;
            mac.tempCQRecord.Friday_OFF__c= False;
            mac.tempCQRecord.Friday_Start_Time__c = null;
            mac.tempCQRecord.Friday_End_Time__c = null;
            mac.tempCQRecord.Saturday_OFF__c= False;
            mac.tempCQRecord.Saturday_Start_Time__c = null;
            mac.tempCQRecord.Saturday_End_Time__c = null;
            mac.tempCQRecord.Sunday_OFF__c= False;
            mac.tempCQRecord.Sunday_Start_Time__c = null;
            mac.tempCQRecord.Sunday_End_Time__c = null;
            mac.saveCQ();
            
            //Validation to Make sure that if the Day OFF is True, then no values should be put in either Start Time or End time
            mac.tempCQRecord.Monday_OFF__c= True;
            mac.tempCQRecord.Monday_Start_Time__c = null;
            mac.tempCQRecord.Monday_End_Time__c = '0:00';
            mac.tempCQRecord.Tuesday_OFF__c= True;
            mac.tempCQRecord.Tuesday_Start_Time__c = null;
            mac.tempCQRecord.Tuesday_End_Time__c = '0:00';
            mac.tempCQRecord.Wednesday_OFF__c= True;
            mac.tempCQRecord.Wednesday_Start_Time__c = null;
            mac.tempCQRecord.Wednesday_End_Time__c = '0:00';
            mac.tempCQRecord.Thursday_OFF__c= True;
            mac.tempCQRecord.Thursday_Start_Time__c = null;
            mac.tempCQRecord.Thursday_End_Time__c = '0:00';
            mac.tempCQRecord.Friday_OFF__c= True;
            mac.tempCQRecord.Friday_Start_Time__c = null;
            mac.tempCQRecord.Friday_End_Time__c = '0:00';
            mac.tempCQRecord.Saturday_OFF__c= True;
            mac.tempCQRecord.Saturday_Start_Time__c = null;
            mac.tempCQRecord.Saturday_End_Time__c = '0:00';
            mac.tempCQRecord.Sunday_OFF__c= True;
            mac.tempCQRecord.Sunday_Start_Time__c = null;
            mac.tempCQRecord.Sunday_End_Time__c = '0:00';
            mac.saveCQ();
            
            //Making sure we are able to succesfully save a record that passes all validation rules
            mac.tempCQRecord.Monday_OFF__c= False;
            mac.tempCQRecord.Monday_Start_Time__c = '0:00';
            mac.tempCQRecord.Monday_End_Time__c = '23:30';
            mac.tempCQRecord.Tuesday_OFF__c= False;
            mac.tempCQRecord.Tuesday_Start_Time__c = '0:00';
            mac.tempCQRecord.Tuesday_End_Time__c = '23:30';
            mac.tempCQRecord.Wednesday_OFF__c= False;
            mac.tempCQRecord.Wednesday_Start_Time__c = '0:00';
            mac.tempCQRecord.Wednesday_End_Time__c = '23:30';
            mac.tempCQRecord.Thursday_OFF__c= False;
            mac.tempCQRecord.Thursday_Start_Time__c = '0:00';
            mac.tempCQRecord.Thursday_End_Time__c = '23:30';
            mac.tempCQRecord.Friday_OFF__c= False;
            mac.tempCQRecord.Friday_Start_Time__c = '0:00';
            mac.tempCQRecord.Friday_End_Time__c = '23:30';
            mac.tempCQRecord.Saturday_OFF__c= False;
            mac.tempCQRecord.Saturday_Start_Time__c = '0:00';
            mac.tempCQRecord.Saturday_End_Time__c = '23:30';
            mac.tempCQRecord.Sunday_OFF__c= False;
            mac.tempCQRecord.Sunday_Start_Time__c = '0:00';
            mac.tempCQRecord.Sunday_End_Time__c = '23:30';
            mac.saveCQ();
            
            ERP_Closer_Queue_Assignment_Schedule__c tempRecord = [Select id, Queue_Id__c from ERP_Closer_Queue_Assignment_Schedule__c where id=: mac.tempCQRecord.id];
            
            tempRecord.Queue_Id__c = grp.id;
            update tempRecord;
            system.assertEquals(tempRecord.Queue_Id__c,grp.id);
            //Getting the Possible User Options to choose at the time of creating ACA Schedule records
            List<SelectOption> optionList = new List<SelectOption>();
            optionList = mac.getqueueList();
            
            mac.setselectedQueue(grp.Name);
            String userId = mac.getselectedQueue();
            
            
            
            
        test.StopTest();
    }
    
    public Static testmethod void closersQueueAssignmentTest(){
        test.startTest();
        
            createSampleData();
            
            ERP_Closer_Queue_Assignment_Schedule__c tempRecord1 = new ERP_Closer_Queue_Assignment_Schedule__c();
            ERP_Closer_Queue_Assignment_Schedule__c tempRecord2 = new ERP_Closer_Queue_Assignment_Schedule__c();
            list<Id> queueIdList = new List<Id>();
            For(QueueSobject qso : [Select QueueId from QueueSobject Where SobjectType=:'Lead' LIMIT 2])
                queueIdList.add(qso.QueueId);
            List<Group> grpList = [Select Id, Name from Group where id IN: queueIdList LIMIT 2];
            
            //Making sure we are able to succesfully save a record that passes all validation rules
            tempRecord1.Name = grpList[0].Name;
            tempRecord1.Monday_OFF__c= False;
            tempRecord1.Monday_Start_Time__c = '1:00';
            tempRecord1.Monday_End_Time__c = '23:30';
            tempRecord1.Tuesday_OFF__c= False;
            tempRecord1.Tuesday_Start_Time__c = '1:00';
            tempRecord1.Tuesday_End_Time__c = '23:30';
            tempRecord1.Wednesday_OFF__c= False;
            tempRecord1.Wednesday_Start_Time__c = '1:00';
            tempRecord1.Wednesday_End_Time__c = '23:30';
            tempRecord1.Thursday_OFF__c= False;
            tempRecord1.Thursday_Start_Time__c = '1:00';
            tempRecord1.Thursday_End_Time__c = '23:30';
            tempRecord1.Friday_OFF__c= False;
            tempRecord1.Friday_Start_Time__c = '1:00';
            tempRecord1.Friday_End_Time__c = '23:30';
            tempRecord1.Saturday_OFF__c= False;
            tempRecord1.Saturday_Start_Time__c = '1:00';
            tempRecord1.Saturday_End_Time__c = '23:30';
            tempRecord1.Sunday_OFF__c= False;
            tempRecord1.Sunday_Start_Time__c = '1:00';
            tempRecord1.Sunday_End_Time__c = '23:30';
            insert tempRecord1;
            
            //Making sure we are able to succesfully save a record that passes all validation rules
            tempRecord2.Name = grpList[1].Name;
            tempRecord2.Monday_OFF__c= False;
            tempRecord2.Monday_Start_Time__c = '1:00';
            tempRecord2.Monday_End_Time__c = '23:30';
            tempRecord2.Tuesday_OFF__c= False;
            tempRecord2.Tuesday_Start_Time__c = '1:00';
            tempRecord2.Tuesday_End_Time__c = '23:30';
            tempRecord2.Wednesday_OFF__c= False;
            tempRecord2.Wednesday_Start_Time__c = '1:00';
            tempRecord2.Wednesday_End_Time__c = '23:30';
            tempRecord2.Thursday_OFF__c= False;
            tempRecord2.Thursday_Start_Time__c = '1:00';
            tempRecord2.Thursday_End_Time__c = '23:30';
            tempRecord2.Friday_OFF__c= False;
            tempRecord2.Friday_Start_Time__c = '1:00';
            tempRecord2.Friday_End_Time__c = '23:30';
            tempRecord2.Saturday_OFF__c= False;
            tempRecord2.Saturday_Start_Time__c = '1:00';
            tempRecord2.Saturday_End_Time__c = '23:30';
            tempRecord2.Sunday_OFF__c= False;
            tempRecord2.Sunday_Start_Time__c = '1:00';
            tempRecord2.Sunday_End_Time__c = '23:30';
            insert tempRecord2;
            
            //ERP_Closer_Queue_Assignment_Schedule__c tempRecord = [Select id, Queue_Id__c from ERP_Closer_Queue_Assignment_Schedule__c where id=: mac.tempCQRecord.id];
            
            tempRecord1.Queue_Id__c = grpList[0].id;
            tempRecord2.Queue_Id__c = grpList[1].id;
            
            update tempRecord1;
            update tempRecord2;
            
            String leadOwnerString = ClosersQueueAssignmentController.closersQueueAssignment();
            
            Id recTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Elite Rehab Placement').getRecordTypeId(); 
            
            Lead l = New Lead();
            l.FirstName = 'Test';
            l.LastName = 'Test';
            l.LeadSource = 'Insurance Form';
            l.Company = 'test';
            l.Subscriber_Last_Name__c = 'Test';
            l.Subscriber_First_Name__c = 'Test';
            l.Contact_First_Name__c = 'Test';
            l.Contact_Last_Name__c = 'Test';
            l.Subscriber_DOB_Text__c = '2014-01-12';
            l.Email='test@test.com';
            l.recordTypeId = recTypeId;
            l.status='Open';
            insert l;
            
            TriggerContextUtility2.firstRun = True;
            
            l.Test_Class_Checkbox__c = True;
            l.Status = 'Qualified';
            Update l;
            
        test.StopTest();
    }
}