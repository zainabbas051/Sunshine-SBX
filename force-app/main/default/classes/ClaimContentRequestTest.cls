//test class for ClaimContentRequest
@isTest
public  class ClaimContentRequestTest{
    
    static testmethod void ClaimContentRequest(){
        
        test.startTest();
        
        OUTREACH_ACCOUNT__c OA = new OUTREACH_ACCOUNT__c();
        OA.Status__c = 'Contributor';
        insert OA;
        
        Content_Request__c CR = new Content_Request__c();
        
        CR.Status__c = 'Initial Content Submitted';
        CR.Writer_Status__c = 'Open';        
        CR.Related_Outreach_Account__c = OA.id;
        insert CR;
        
        
        
        ClaimContentRequest.ClaimContentRequest(CR.id,CR.OwnerId);
        
        test.stoptest();
    }
    
    
    static testmethod void ClaimContentRequest_test1(){
        
        test.startTest();
        
        string lastUser = '';
        set<id> setQueueUsers = new set<id>();
        for(Group g : [select id, (select id, UserorGroupId from GroupMembers) from Group where (Name=:'ERP Writers') AND Type =: 'Queue']){
            for(GroupMember gm : g.GroupMembers){
                setQueueUsers.add(gm.UserorGroupId);
                lastUser = String.valueOf(gm.UserorGroupId);
            }
        }

        
        OUTREACH_ACCOUNT__c OA = new OUTREACH_ACCOUNT__c();
        OA.Status__c = 'Contributor';
        insert OA;
        
        Content_Request__c CR = new Content_Request__c();
        
        CR.Status__c = 'Initial Content Submitted';
        CR.Writer_Status__c = 'Open';
        CR.OwnerId = lastUser;
        //CR.Related_Outreach_Account__c = OA.id;
        insert CR;
        
        
        ClaimContentRequest.ClaimContentRequest(CR.id,CR.OwnerId );
        
        test.stoptest();
    }
    
    static testmethod void ClaimContentRequest_test2(){
        
        test.startTest();
        
        string lastUser = '';
        set<id> setQueueUsers = new set<id>();
        for(Group g : [select id, (select id, UserorGroupId from GroupMembers) from Group where (Name=:'ERP Writers') AND Type =: 'Queue']){
            for(GroupMember gm : g.GroupMembers){
                setQueueUsers.add(gm.UserorGroupId);
                lastUser = String.valueOf(gm.UserorGroupId);
            }
        }

        User u = [Select Id,Name from User where Id =: lastUser];
        
        System.runAs(u)
        {
            OUTREACH_ACCOUNT__c OA = new OUTREACH_ACCOUNT__c();
            OA.Status__c = 'Contributor';
            insert OA;
            
            Content_Request__c CR = new Content_Request__c();
            
            CR.Status__c = 'Initial Content Submitted';
            CR.Writer_Status__c = 'Open';
            CR.OwnerId = u.Id;
            //CR.Related_Outreach_Account__c = OA.id;
            insert CR;
            
            
            ClaimContentRequest.ClaimContentRequest(CR.id,CR.OwnerId );    
        }
        
        
        test.stoptest();
    }
    
    static testmethod void ClaimContentRequest_Test3(){
        
        test.startTest();
        
        string lastUser = '';
        set<id> setQueueUsers = new set<id>();
        for(Group g : [select id, (select id, UserorGroupId from GroupMembers) from Group where (Name=:'ERP Writers') AND Type =: 'Queue']){
            for(GroupMember gm : g.GroupMembers){
                setQueueUsers.add(gm.UserorGroupId);
                lastUser = String.valueOf(gm.UserorGroupId);
            }
        }

        User u = [Select Id,Name from User where Id =: lastUser];
        
        System.runAs(u)
        {
            OUTREACH_ACCOUNT__c OA = new OUTREACH_ACCOUNT__c();
            OA.Status__c = 'Contributor';
            insert OA;
            
            Content_Request__c CR = new Content_Request__c();
            
            CR.Status__c = 'Initial Content Submitted';
            CR.Writer_Status__c = 'Open';        
            CR.Related_Outreach_Account__c = OA.id;
            insert CR;
            
            
            List<Content_Request__c> crs1 =  GetContentRequests(3,'In Progress');
            insert crs1;
            
            List<Content_Request__c> crs2 =  GetContentRequests(5,'Needs Editing');
            insert crs2;
            
            
            ClaimContentRequest.ClaimContentRequest(CR.id,'');
        }
        
        test.stoptest();
    }
    
    static testmethod void ClaimContentRequest_Test4(){
        
        test.startTest();
        
        string lastUser = '';
        set<id> setQueueUsers = new set<id>();
        for(Group g : [select id, (select id, UserorGroupId from GroupMembers) from Group where (Name=:'ERP Writers') AND Type =: 'Queue']){
            for(GroupMember gm : g.GroupMembers){
                setQueueUsers.add(gm.UserorGroupId);
                lastUser = String.valueOf(gm.UserorGroupId);
            }
        }

        User u = [Select Id,Name from User where Id =: lastUser];
        
        System.runAs(u)
        {
            OUTREACH_ACCOUNT__c OA = new OUTREACH_ACCOUNT__c();
            OA.Status__c = 'Contributor';
            insert OA;
            
            Content_Request__c CR = new Content_Request__c();
            
            CR.Status__c = 'Initial Content Submitted';
            CR.Writer_Status__c = 'Open';        
            CR.Related_Outreach_Account__c = OA.id;
            insert CR;
            
            
            List<Content_Request__c> crs1 =  GetContentRequests(1,'In Progress');
            insert crs1;
            ClaimContentRequest.ClaimContentRequest(crs1[0].id,'');
            List<Content_Request__c> crs2 =  GetContentRequests(1,'Needs Editing');
            insert crs2;
            ClaimContentRequest.ClaimContentRequest(CR.id,'');
            
            List<Content_Request__c> crs3 =  GetContentRequests(1,'In Progress');
            insert crs3;
            ClaimContentRequest.ClaimContentRequest(CR.id,'');
            List<Content_Request__c> crs4 =  GetContentRequests(1,'Needs Editing');
            insert crs4;
            
            
            ClaimContentRequest.ClaimContentRequest(CR.id,'');
        }
        
        test.stoptest();
    }
    
     static testmethod void ClaimContentRequest_Test5(){
        
        test.startTest();
        
        string lastUser = '';
        set<id> setQueueUsers = new set<id>();
        for(Group g : [select id, (select id, UserorGroupId from GroupMembers) from Group where (Name=:'ERP Writers') AND Type =: 'Queue']){
            for(GroupMember gm : g.GroupMembers){
                setQueueUsers.add(gm.UserorGroupId);
                lastUser = String.valueOf(gm.UserorGroupId);
            }
        }

        User u = [Select Id,Name from User where Id =: label.Adam_Ryan_User_ID];
        
        System.runAs(u)
        {
            OUTREACH_ACCOUNT__c OA = new OUTREACH_ACCOUNT__c();
            OA.Status__c = 'Contributor';
            insert OA;
            
            Content_Request__c CR = new Content_Request__c();
            
            CR.Status__c = 'Initial Content Submitted';
            CR.Writer_Status__c = 'Open';        
            CR.Related_Outreach_Account__c = OA.id;
            insert CR;
            
            
           
            List<Content_Request__c> crs3 =  GetContentRequests(1,'In Progress');
            insert crs3;
            ClaimContentRequest.ClaimContentRequest(CR.id,'');
            List<Content_Request__c> crs4 =  GetContentRequests(1,'Needs Editing');
            insert crs4;
            
            
            ClaimContentRequest.ClaimContentRequest(CR.id,'');
        }
        
        test.stoptest();
    }
    
    
    static List<Content_Request__c> GetContentRequests(Integer count, string WriterStatus){
        List<Content_Request__c> crs = new List<Content_Request__c>();
        for (Integer i = 0, j = 0; i <= count; i++) {
            Content_Request__c cr = new Content_Request__c();
            cr.Writer_Status__c = WriterStatus;
            cr.Assigned_Writer__c = UserInfo.getUserId();
            crs.add(cr);
        }
        return crs;
    }
}