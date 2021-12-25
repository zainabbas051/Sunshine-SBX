@isTest 

public class SEOTimesheetWeeklyUpdateBatchTest 

{
 public Static Profile adminProfile;
  public Static UserRole u_Role;
   public static User userAdmin
    {
        get{
            if (userAdmin == null )
            {
                adminProfile = [Select Id, Name From Profile where name = 'System Administrator' limit 1];
                u_Role= [select id, name from UserRole where name='SEO Associate' limit 1];
                userAdmin  = new user (Username = ' test@key.net', FirstName = 'FirstTest', LastName ='LastTest', alias = 'FLast', 
                            email='test@key.net', communityNickname='test0101019', TimeZoneSidKey='America/New_York',
                            LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', ProfileId=adminProfile.Id ,
                            LanguageLocaleKey='en_US', UserRoleID = u_Role.id);
                insert userAdmin;             
             }
             return userAdmin;
            }
        set;
    }
    static testMethod void testMethod1() 
    {
        
    
 Test.startTest();
        system.runAs(userAdmin){
        OUTREACH_ACCOUNT__c OA = new OUTREACH_ACCOUNT__c();
        OA.Status__c = 'Content Requested';
        OA.OwnerID = UserINFO.getUserID();
        insert OA;
        
        OA = new OUTREACH_ACCOUNT__c();
        OA.Status__c = 'Contributor';
        OA.OwnerID = UserINFO.getUserID();
        insert OA;
        
        OUTREACH_REQUEST__c Out_R=  new OUTREACH_REQUEST__c();
        Out_R.Status__c='Converted';
        Out_R.AssignedSeo__c = UserInfo.getUserId();
        insert Out_R;
        
        Content_Request__c cr = new Content_Request__c();
        cr.Status__c = 'Link Published';
         cr.Link_Published_URL__c ='http://';
         cr.OwnerID = UserInfo.getUserId();
        insert cr;
        
        cr = new Content_Request__c();
        cr.Status__c = 'Link Published';
        cr.Type__c = 'On-Site Blog Post';
        cr.Link_Published_URL__c ='http://';
          cr.OwnerID = UserInfo.getUserId();
        insert cr;
        
        cr = new Content_Request__c();
        cr.Status__c = 'Link Published';
        cr.Type__c = 'Organic Landing Page';
         cr.Link_Published_URL__c ='http://';
           cr.OwnerID =UserInfo.getUserId();
        insert cr;
        
        
        cr = new Content_Request__c();
        cr.Status__c = 'Link Published';
        cr.Type__c = 'Resource Link';
         cr.Link_Published_URL__c ='http://';
           cr.OwnerID = UserInfo.getUserId();
        insert cr;
        
        
        cr = new Content_Request__c();
        cr.Status__c = 'Link Published';
        cr.Type__c = 'Skyscraper Link';
         cr.Link_Published_URL__c ='http://';
           cr.OwnerID = UserInfo.getUserId();
        insert cr;
        
         cr = new Content_Request__c();
        cr.Status__c = 'Link Published';
        cr.Type__c = 'Keyword Mention';
         cr.Link_Published_URL__c ='http://';
           cr.OwnerID = UserInfo.getUserId();
        insert cr;
        
        cr = new Content_Request__c();
        cr.Status__c = 'Link Published';
        cr.Type__c = 'Broken Link';
         cr.Link_Published_URL__c ='http://';
           cr.OwnerID = UserInfo.getUserId();
        insert cr;
        
            cr = new Content_Request__c();
        cr.Status__c = 'Link Published';
        cr.Type__c = 'Infographics';
         cr.Link_Published_URL__c ='http://';
           cr.OwnerID = UserInfo.getUserId();
        insert cr;
        
         cr = new Content_Request__c();
        cr.Status__c = 'Content Request in Progress';
        cr.Type__c = 'Guest Posts';
         cr.Link_Published_URL__c ='http://';
           cr.OwnerID =UserInfo.getUserId();
        insert cr;
        
         cr = new Content_Request__c();
        cr.Status__c = 'Content Request in Progress';
        cr.Type__c = 'Guest Posts';
         cr.Link_Published_URL__c ='http://';
           cr.OwnerID =UserInfo.getUserId();
        insert cr;
        
                 cr = new Content_Request__c();
        cr.Status__c = 'Content Returned For Editing';
        cr.Type__c = 'Resource Link';
         cr.Link_Published_URL__c ='http://';
           cr.OwnerID =UserInfo.getUserId();
        insert cr;
 
        
        
        cr = new Content_Request__c();
        cr.Status__c = 'Link Published';
        cr.Type__c = 'Guest Posts';
        cr.Link_Published_URL__c ='http://';
          cr.OwnerID = UserInfo.getUserId();
        insert cr;
        
        cr = new Content_Request__c();
        cr.Status__c = 'Closed Rejected';
        cr.Type__c = 'Guest Posts';
        cr.Link_Published_URL__c ='http://';
        cr.Closed_Rejected_Reason__c = 'test123';
          cr.OwnerID = UserInfo.getUserId();
        insert cr;
        
        cr = new Content_Request__c();
        cr.Status__c = 'Closed Rejected';
        cr.Type__c = 'Resource Link';
        cr.Link_Published_URL__c ='http://';
         cr.Closed_Rejected_Reason__c = 'test123';
           cr.OwnerID =UserInfo.getUserId();
        insert cr;
        
            cr = new Content_Request__c();
        cr.Status__c = 'Closed Accepted';
        cr.Type__c = 'Resource Link';
        cr.Link_Published_URL__c ='http://';
          cr.OwnerID = UserInfo.getUserId();
        insert cr;
        
         cr = new Content_Request__c();
        cr.Status__c = 'Closed Accepted';
        cr.Type__c = 'Guest Posts';
        cr.Link_Published_URL__c ='http://';
          cr.OwnerID = UserInfo.getUserId();
        insert cr;
        
        cr = new Content_Request__c();
        cr.Status__c = 'Initial Content Submitted';
        cr.Type__c = 'Guest Posts';
        cr.Link_Published_URL__c ='http://';
          cr.OwnerID = UserInfo.getUserId();
        insert cr;
        
         cr = new Content_Request__c();
        cr.Status__c = 'Initial Content Submitted';
        cr.Type__c = 'Resource Link';
        cr.Link_Published_URL__c ='http://';
          cr.OwnerID = UserInfo.getUserId();
        insert cr;
        
         cr = new Content_Request__c();
        cr.Status__c = 'Initial Content Submitted';
        cr.Type__c = 'Organic Landing Page';
        cr.Link_Published_URL__c ='http://';
          cr.OwnerID = UserInfo.getUserId();
        insert cr;
        
         cr = new Content_Request__c();
        cr.Status__c = 'Content Returned For Editing';
        cr.Type__c = 'Organic Landing Page';
        cr.Link_Published_URL__c ='http://';
          cr.OwnerID = UserInfo.getUserId();
        insert cr;
        
        
         cr = new Content_Request__c();
        cr.Status__c = 'Closed Rejected';
        cr.Type__c = 'Organic Landing Page';
        cr.Link_Published_URL__c ='http://';
        cr.Closed_Rejected_Reason__c = 'test123';
          cr.OwnerID = UserInfo.getUserId();
        insert cr;
        
         cr = new Content_Request__c();
        cr.Status__c = 'Closed Rejected';
        cr.Type__c = 'On-Site Blog Post';
        cr.Link_Published_URL__c ='http://';
        cr.Closed_Rejected_Reason__c = 'test123';
          cr.OwnerID = UserInfo.getUserId();
        insert cr;
        
         cr = new Content_Request__c();
        cr.Status__c = 'Closed Accepted';
        cr.Type__c = 'Organic Landing Page';
        cr.Link_Published_URL__c ='http://';
          cr.OwnerID = UserInfo.getUserId();
        insert cr;
        
                 cr = new Content_Request__c();
        cr.Status__c = 'Closed Accepted';
        cr.Type__c = 'On-Site Blog Post';
        cr.Link_Published_URL__c ='http://';
          cr.OwnerID = UserInfo.getUserId();
        insert cr;
        
        
        cr = new Content_Request__c();
        cr.Status__c = 'Initial Content Submitted';
        cr.Type__c = 'Organic Landing Page';
        cr.Link_Published_URL__c ='http://';
          cr.OwnerID = UserInfo.getUserId();
        insert cr;
        
        
            cr = new Content_Request__c();
        cr.Status__c = 'Content Request in Progress';
        cr.Type__c = 'On-Site Blog Post';
        cr.Link_Published_URL__c ='http://';
          cr.OwnerID = UserInfo.getUserId();
        insert cr;
        
            cr = new Content_Request__c();
        cr.Status__c = 'Content Returned For Editing';
        cr.Type__c = 'On-Site Blog Post';
        cr.Link_Published_URL__c ='http://';
          cr.OwnerID = UserInfo.getUserId();
        insert cr;
        
        
        cr = new Content_Request__c();
        cr.Status__c = 'Initial Content Submitted';
        cr.Type__c = 'On-Site Blog Post';
        cr.Link_Published_URL__c ='http://';
          cr.OwnerID = UserInfo.getUserId();
        insert cr;
        
        
        
        
        
        
        
        
        Target_Page__c tr = new Target_Page__c();
        insert tr;
        
        
        Out_R=  new OUTREACH_REQUEST__c();
        Out_R.Status__c='Qualified';
        Out_R.AssignedSeo__c = UserInfo.getUserId();
        insert Out_R;
        
        
        
        

  
        
       

            Map<string,SEO_Timesheet__c> mapOfTimeSheet = new Map<string,SEO_Timesheet__c>();
            
            SEOTimesheetWeeklyUpdateBatch obj = new SEOTimesheetWeeklyUpdateBatch();
            DataBase.executeBatch(obj); 
        }
           
        Test.stopTest();
        
   
    }
}