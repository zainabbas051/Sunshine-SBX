@isTest(seeAllData=True)
private class ManageAdmisionCoordinatorTest{
    
    public static MS_Admision_Coordinator_Schedule__c msacs;
    
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
        
        msacs = New MS_Admision_Coordinator_Schedule__c();
        msacs.User__c = userAdmin.id;
        insert msacs;
    }
    
    public Static testmethod void ManageAdmisionCoordinatorTest(){
        test.startTest();
        
            createSampleData();
            ManageAdmisionCoordinator mac = new ManageAdmisionCoordinator();
            mac.cancel();
            
            //Testing the Edit, Save and Deleting existing record.
            mac.indexVal = 0;
            mac.showEditUserScreen();
            mac.saveACM();
            mac.deleteACM();
            
            //Testing Add New, Save and Validations
            mac.showAddUserScreen();
            mac.tempACMRecord.User__c = userAdmin.id;
            
            //Validation to make sure that Start and End Time need to be put in if the Day OFF is set to False
            mac.tempACMRecord.Monday_OFF__c= False;
            mac.tempACMRecord.Monday_Start_Time__c = null;
            mac.tempACMRecord.Monday_End_Time__c = null;
            mac.tempACMRecord.Tuesday_OFF__c= False;
            mac.tempACMRecord.Tuesday_Start_Time__c = null;
            mac.tempACMRecord.Tuesday_End_Time__c = null;
            mac.tempACMRecord.Wednesday_OFF__c= False;
            mac.tempACMRecord.Wednesday_Start_Time__c = null;
            mac.tempACMRecord.Wednesday_End_Time__c = null;
            mac.tempACMRecord.Thursday_OFF__c= False;
            mac.tempACMRecord.Thursday_Start_Time__c = null;
            mac.tempACMRecord.Thursday_End_Time__c = null;
            mac.tempACMRecord.Friday_OFF__c= False;
            mac.tempACMRecord.Friday_Start_Time__c = null;
            mac.tempACMRecord.Friday_End_Time__c = null;
            mac.tempACMRecord.Saturday_OFF__c= False;
            mac.tempACMRecord.Saturday_Start_Time__c = null;
            mac.tempACMRecord.Saturday_End_Time__c = null;
            mac.tempACMRecord.Sunday_OFF__c= False;
            mac.tempACMRecord.Sunday_Start_Time__c = null;
            mac.tempACMRecord.Sunday_End_Time__c = null;
            mac.saveACM();
            
            //Validation to Make sure that if the Day OFF is True, then no values should be put in either Start Time or End time
            mac.tempACMRecord.Monday_OFF__c= True;
            mac.tempACMRecord.Monday_Start_Time__c = null;
            mac.tempACMRecord.Monday_End_Time__c = '0:00';
            mac.tempACMRecord.Tuesday_OFF__c= True;
            mac.tempACMRecord.Tuesday_Start_Time__c = null;
            mac.tempACMRecord.Tuesday_End_Time__c = '0:00';
            mac.tempACMRecord.Wednesday_OFF__c= True;
            mac.tempACMRecord.Wednesday_Start_Time__c = null;
            mac.tempACMRecord.Wednesday_End_Time__c = '0:00';
            mac.tempACMRecord.Thursday_OFF__c= True;
            mac.tempACMRecord.Thursday_Start_Time__c = null;
            mac.tempACMRecord.Thursday_End_Time__c = '0:00';
            mac.tempACMRecord.Friday_OFF__c= True;
            mac.tempACMRecord.Friday_Start_Time__c = null;
            mac.tempACMRecord.Friday_End_Time__c = '0:00';
            mac.tempACMRecord.Saturday_OFF__c= True;
            mac.tempACMRecord.Saturday_Start_Time__c = null;
            mac.tempACMRecord.Saturday_End_Time__c = '0:00';
            mac.tempACMRecord.Sunday_OFF__c= True;
            mac.tempACMRecord.Sunday_Start_Time__c = null;
            mac.tempACMRecord.Sunday_End_Time__c = '0:00';
            mac.saveACM();
            
            //Making sure we are able to succesfully save a record that passes all validation rules
            mac.tempACMRecord.Monday_OFF__c= True;
            mac.tempACMRecord.Monday_Start_Time__c = null;
            mac.tempACMRecord.Monday_End_Time__c = null;
            mac.tempACMRecord.Tuesday_OFF__c= True;
            mac.tempACMRecord.Tuesday_Start_Time__c = null;
            mac.tempACMRecord.Tuesday_End_Time__c = null;
            mac.tempACMRecord.Wednesday_OFF__c= True;
            mac.tempACMRecord.Wednesday_Start_Time__c = null;
            mac.tempACMRecord.Wednesday_End_Time__c = null;
            mac.tempACMRecord.Thursday_OFF__c= True;
            mac.tempACMRecord.Thursday_Start_Time__c = null;
            mac.tempACMRecord.Thursday_End_Time__c = null;
            mac.tempACMRecord.Friday_OFF__c= True;
            mac.tempACMRecord.Friday_Start_Time__c = null;
            mac.tempACMRecord.Friday_End_Time__c = null;
            mac.tempACMRecord.Saturday_OFF__c= True;
            mac.tempACMRecord.Saturday_Start_Time__c = null;
            mac.tempACMRecord.Saturday_End_Time__c = null;
            mac.tempACMRecord.Sunday_OFF__c= True;
            mac.tempACMRecord.Sunday_Start_Time__c = null;
            mac.tempACMRecord.Sunday_End_Time__c = null;
            mac.saveACM();
            
            //Getting the Possible User Options to choose at the time of creating ACA Schedule records
            List<SelectOption> optionList = new List<SelectOption>();
            optionList = mac.getuserList();
            
            mac.setselectedUser(userAdmin.id);
            String userId = mac.getselectedUser();
            
        test.StopTest();
    }
}