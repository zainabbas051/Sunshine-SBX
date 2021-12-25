@isTest
public class MainTabControllerTest {
     public Static Profile adminProfile;
     public static User userAdmin
    {
        get{
            if (userAdmin == null )
            {
                adminProfile = [Select Id, Name From Profile where name = 'System Administrator' limit 1];
                userAdmin  = new user (Username = ' test@key.net', FirstName = 'FirstTest', LastName ='LastTest', alias = 'FLast', 
                            email='test@key.net', communityNickname='test0101019', TimeZoneSidKey='America/New_York',
                            LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId=adminProfile.Id , Acess_Type__c = 'Admin',
                            LanguageLocaleKey='en_US', User_Role__c = NULL);
                insert userAdmin;             
             }
             return userAdmin;
            }
        set;
    }
    
    
     public Static testmethod void MainTabTest(){
         
         test.startTest();
         
           system.runAs(userAdmin){
               
               TabViews__c tb = new TabViews__c();
               tb.Is_Main_Tab__c = true;
               tb.Tabs_Access_Type__c = 'Admin;Clinical;Medical;Operations';
               tb.Name = 'Client';
               
               insert tb;
               
               MainTabController m = new MainTabController();
           }
         
         
         test.stopTest();
     
     }

}