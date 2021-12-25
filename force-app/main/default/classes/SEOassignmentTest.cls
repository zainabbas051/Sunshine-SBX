@isTest
private class SEOassignmentTest{

    Public static SEO_Outreacher_Mapping__c seoassign;
    Public static OUTREACH_REQUEST__c  outreach ;
    Public Static Profile adminProfile;
    
    public static User userAdmin
    {
        get{
            if (userAdmin == null )
            {
                adminProfile = [Select Id, Name From Profile where name = 'System Administrator' limit 1];
                userAdmin  = new user (Username = ' test@key.net', FirstName = 'FirstTest', LastName ='LastTest', alias = 'FLast', 
                            email='test@key.net', communityNickname='test0101019', TimeZoneSidKey='America/New_York',
                            LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId=adminProfile.Id ,
                            LanguageLocaleKey='en_US');
                insert userAdmin;             
             }
             return userAdmin;
            }
        set;
    }
    
    public static User userAdmin2
    {
        get{
            if (userAdmin2 == null )
            {
                adminProfile = [Select Id, Name From Profile where name = 'System Administrator' limit 1];
                userAdmin2  = new user (Username = ' test2@key.net', FirstName = 'FirstTest2', LastName ='LastTest2', alias = 'FLast2', 
                            email='test2@key.net', communityNickname='test20101019', TimeZoneSidKey='America/New_York',
                            LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId=adminProfile.Id ,
                            LanguageLocaleKey='en_US');
                insert userAdmin2;             
             }
             return userAdmin2;
            }
        set;
    }
    
    

    
    public static User userAdmin3
    {
        get{
            if (userAdmin3 == null )
            {
                adminProfile = [Select Id, Name From Profile where name = 'System Administrator' limit 1];
                userAdmin3  = new user (Username = ' test3@key.net', FirstName = 'FirstTest3', LastName ='LastTest3', alias = 'FLast3', 
                            email='test3@key.net', communityNickname='test30101019', TimeZoneSidKey='America/New_York',
                            LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId=adminProfile.Id ,
                            LanguageLocaleKey='en_US');
                insert userAdmin3;             
             }
             return userAdmin3;
            }
        set;
    }
    
    
    public static User userAdmin4
    {
        get{
            if (userAdmin4 == null )
            {
                adminProfile = [Select Id, Name From Profile where name = 'System Administrator' limit 1];
                userAdmin4  = new user (Username = ' test4@key.net', FirstName = 'FirstTest4', LastName ='LastTest4', alias = 'FLast4', 
                            email='test3@key.net', communityNickname='test40101019', TimeZoneSidKey='America/New_York',
                            LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId=adminProfile.Id ,
                            LanguageLocaleKey='en_US');
                insert userAdmin4;             
             }
             return userAdmin4;
            }
        set;
    }
            
            
      Public Static void createSampleData(){
               
          seoassign = new SEO_Outreacher_Mapping__c();
          seoassign.Name = userAdmin3.Id;
          seoassign.SEO_ID__c= userAdmin.Id;
          seoassign.SEO_Name__c = 'userAdmin' ;
          insert seoassign;
          
          
          seoassign = new SEO_Outreacher_Mapping__c();
          seoassign.Name = userAdmin4.Id;
          seoassign.SEO_ID__c = userAdmin2.Id;
          seoassign.SEO_Name__c= 'userAdmin2' ;
          insert seoassign;
          
  
          
          outreach = new OUTREACH_REQUEST__c ();
          outreach.Status__c = 'Qualified';
          outreach.Category__c = 'Test';
          outreach.Contact_Email_Address__c = 'test123@test.com';
          outreach.Contact_Phone_Number__c = '1234567890' ;         
          insert outreach;
          //outreach.Status__c = 'Qualified';
          //update  outreach;
         
          
         
      } 
      Public Static testmethod void SEOassignmentTest(){
       test.startTest();
  //     system.runAs(userAdmin){
            createSampleData();
            outreach.Status__c = 'Open';
            update  outreach;
            outreach.Status__c = 'Qualified';
            update  outreach;           
            outreach.Status__c = 'Open';
            update  outreach;
            outreach.Status__c = 'Qualified';
            update  outreach;
            outreach.Status__c = 'Open';
            update  outreach;
            outreach.Status__c = 'Qualified';
            outreach.Social_Media_Accounts__c = True ;
            update  outreach;

             
 //      }
       test.StopTest();
      }  


}