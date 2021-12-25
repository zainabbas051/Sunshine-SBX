public class ctrl_InvocaCallLog{

    public PageReference Redirect(){
        
        string recId= ApexPages.currentPage().getParameters().get('callLogId');
        createTask(recId);
        Id profileId=userinfo.getProfileId();
        if(profileId==Label.Marketing_profiles)
        updateInvocaCallLog(recId);
        return setUrl(recId);
        
        
    
    }
    
    void updateInvocaCallLog(string recId){
    INVOCA_FOR_SF__Invoca_Call_Log__c invoca= new INVOCA_FOR_SF__Invoca_Call_Log__c();
    invoca.id=recId;
    invoca.Reviewed_by_Marketing__c=true;
    invoca.Reviewed_by_Marketing_User__c=UserInfo.getUserId();
    invoca.Reviewed_by_Marketing_Date_Time__c=DateTime.Now();
    update invoca;
    
    }
    
    void createTask(string recId){
      
        Task tsk = new Task();
        tsk.Subject = 'Invoca Call Review';
        tsk.WhatId = recId;
        //This is the default...
        tsk.OwnerId = UserInfo.getUserId();
        tsk.Status = 'Completed';
        tsk.Type = 'Call';
        tsk.ActivityDate= Date.today();
        insert tsk;
    }
    
    public PageReference setUrl(string recId){
      
      INVOCA_FOR_SF__Invoca_Call_Log__c ivocaCallLog = [SELECT Id,
                                                          INVOCA_FOR_SF__recording__c FROM
                                                           INVOCA_FOR_SF__Invoca_Call_Log__c  WHERE
                                                           ID =: recId];
      
     return new PageReference(ivocaCallLog.INVOCA_FOR_SF__recording__c);
    
    
    }
}