//Test Class :  UnclaimContentRequestTest
global class UnclaimContentRequest {
    webservice static String UnclaimContentRequest(String contentId){
        string result = '';
        
        List<Content_Request__c> ListCR = [Select Id, Name, Assigned_Writer__c, Writer_Status__c, OwnerId from Content_Request__c where Id=:contentId limit 1];
        
        if(ListCR.size()>0) 
        {
            Content_Request__c cr = ListCR[0];
            
            if(cr.Assigned_Writer__c == null)
            {
                result = 'You cannot Un-Claim this Content Request, as it has not been Claimed Yet!!';
            }
            else if(cr.OwnerId != UserInfo.getUserId())
            {
                result = 'You do not have access to Un Claim the Content Request';
            }
            else if(cr.Writer_Status__c == 'Approved for Submission')
            {
                result = 'You Cannot Un-Claim this Content Request, as it is Approved for Submission!!';
            }
            else{
                CR.Assigned_Writer__c = null;
                CR.Writer_Status__c = 'Open';
                update CR;
                
                result ='This content request is successfully un-claimed.';
            }
        }
        else{
            result = 'No Content Request found.';
        }
        
        return result ;
     }
}