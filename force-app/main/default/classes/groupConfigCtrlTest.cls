@isTest
public class groupConfigCtrlTest {
    
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
    
    public static testMethod void groupConfigTest(){
        
         TabViews__c tv = new TabViews__c();
         tv.Name = 'ConfigurationTab';
         tv.Button_Access_Type__c = 'Admin';
         insert tv;
            
            List<Account> lstAcc = new List<Account>();
            lstAcc.add(new Account(Name = 'Monarch Shores' ,Type = 'Internal Center'));
            lstAcc.add(new Account(Name = 'Willowsprings Recovery' ,Type = 'Internal Center'));
            lstAcc.add(new Account(Name = 'Chapters Capistrano' ,Type = 'Internal Center'));
            insert lstAcc;
          
        
        
          Group_Session_Configuration__c grpSession = new Group_Session_Configuration__c ();
            grpSession.Day_of_Week__c ='Sunday;Monday;Tuesday;Wednesday;Thursday;Friday;Saturday';
            grpSession.End_Time__c = '10:00 PM';
            grpSession.Start_Time__c = '09:00 PM';
            grpSession.Client_Track__c ='Green Track';
            grpSession.Facility_Name__c = lstAcc[0].ID;
            insert grpSession;
            
             grpSession = new Group_Session_Configuration__c ();
            grpSession.Day_of_Week__c ='Sunday;Monday;Tuesday;Wednesday;Thursday;Friday;Saturday';
            grpSession.End_Time__c = '10:00 PM';
            grpSession.Start_Time__c = '09:00 PM';
            grpSession.Client_Track__c ='Green Track';
            grpSession.Facility_Name__c = lstAcc[1].ID;
            insert grpSession;
            
             grpSession = new Group_Session_Configuration__c ();
            grpSession.Day_of_Week__c ='Sunday;Monday;Tuesday;Wednesday;Thursday;Friday;Saturday';
            grpSession.End_Time__c = '10:00 PM';
            grpSession.Start_Time__c = '09:00 PM';
            grpSession.Client_Track__c ='Green Track';
            grpSession.Facility_Name__c = lstAcc[2].ID;
            insert grpSession;
            
            test.startTest();
            
            system.runAs(userAdmin){
                groupConfigCtrl grpCtrl = new groupConfigCtrl();
                    
                ApexPages.CurrentPage().getParameters().put('ID',grpSession.id);
             
                groupConfigDetailCtrl grpDetail = new groupConfigDetailCtrl();
                
                grpDetail.save();  
                
                Boolean Flag = grpCtrl.buttonAccessType; 
            } 
            
            test.stopTest();
            
            
            
        
    }
}