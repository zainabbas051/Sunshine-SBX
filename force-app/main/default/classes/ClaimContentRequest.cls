//test class ClaimContentRequestTest
global class ClaimContentRequest{
    
     webservice static String ClaimContentRequest(String contentId, string OwnerId){
         boolean flag1 = True;
         boolean flag2 = True;
         boolean flag3 = True;
         boolean flag4 = True;
         boolean flag5 = True;
         boolean flag6 = True;
         boolean flag7 = True;
         boolean flag8 = True;
         boolean flag9 = True;
         
         string result = '';
         
         Map<string,integer> assignments = new Map<string,integer>();
         for(AggregateResult ar : [Select Count(Id) total,  Writer_Status__c from Content_Request__c where Assigned_Writer__c =: UserInfo.getUserId() group by Writer_Status__c])
         {
             
             string writerStatus = String.valueOf(ar.get('Writer_Status__c'));
             Integer count = Integer.valueOf(ar.get('total'));
             assignments.put(writerStatus, count);
         }
         
         set<id> setQueueUsers = new set<id>();
         
         for(Group g : [select id, (select id, UserorGroupId from GroupMembers) from Group where (Name=:'ERP Writers') AND Type =: 'Queue']){
             for(GroupMember gm : g.GroupMembers){
                setQueueUsers.add(gm.UserorGroupId);
             }
         }
         
         
         if( OwnerId!= '' && setQueueUsers.contains(OwnerId)){
             result = 'This content request has already been Claimed, it cannot be claimed Again!!';
         }
         else if(!setQueueUsers.contains(UserInfo.getUserId())){
             result = 'Only Writers are allowed to Claim a Content Request Record!!!';
         }
        
         else if((assignments.get('In Progress') != null && assignments.get('In Progress') >= integer.ValueOf(label.Stephanie_content_request_In_progress_count) && userInfo.getUserId() == label.Stephanie_User_ID) 
                || (assignments.get('Needs Editing') != null && assignments.get('Needs Editing') >= integer.ValueOf(label.Stephanie_content_request_Needs_editing_count) && userInfo.getUserId() == label.Stephanie_User_ID ))
         {
             result = 'You already have too many content assigned, you cannot claim any more at this moment!!';
         }
         
         else if((assignments.get('In Progress') != null && assignments.get('In Progress') >= integer.ValueOf(label.content_request_In_progress_count)&& userInfo.getUserId() != label.Stephanie_User_ID && userInfo.getUserId() != label.Adam_Ryan_User_ID)
                || (assignments.get('Needs Editing') != null && assignments.get('Needs Editing') >= integer.ValueOf(label.content_request_Needs_editing_count)&& userInfo.getUserId() != label.Stephanie_User_ID && userInfo.getUserId() != label.Adam_Ryan_User_ID))
         {
           
             result = 'You already have too many content assigned, you cannot claim any more at this moment!!';
         }
         
         else if((assignments.get('In Progress') != null && assignments.get('In Progress') >= integer.ValueOf(label.Stephanie_content_request_In_progress_count) && userInfo.getUserId() == label.Adam_Ryan_User_ID) 
                || (assignments.get('Needs Editing') != null && assignments.get('Needs Editing') >= integer.ValueOf(label.Stephanie_content_request_Needs_editing_count) && userInfo.getUserId() == label.Adam_Ryan_User_ID ))
         {
           
             result = 'You already have too many content assigned, you cannot claim any more at this moment!!';
         }
         
         else if((assignments.get('In Progress') != null && assignments.get('In Progress') >= integer.ValueOf(label.content_request_In_progress_count)&& userInfo.getUserId() != label.Adam_Ryan_User_ID && userInfo.getUserId() != label.Stephanie_User_ID )
                || (assignments.get('Needs Editing') != null && assignments.get('Needs Editing') >= integer.ValueOf(label.content_request_Needs_editing_count)&& userInfo.getUserId() != label.Adam_Ryan_User_ID && userInfo.getUserId() != label.Stephanie_User_ID ))
         {
           
             result = 'You already have too many content assigned, you cannot claim any more at this moment!!';}
         else if(contentId !=null){
             Content_Request__c CR = new Content_Request__c ();
             CR.Assigned_Writer__c = UserInfo.getUserId();
             CR.Writer_Status__c = 'In Progress';
             CR.Id = contentId;
             update CR;
             
             result ='This content request is successfully claimed.';
         }
         return result ;
     }
}