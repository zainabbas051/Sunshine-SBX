/*
    Purpose: This trigger will create Feed Item whenever a task is created with subject = call against Lead or Opportunity
    Modified Date : 3/23/2016
*/
trigger TrgTask on Task (after insert) {

    
    //get obj id of Lead to see if task was created against Lead
    Schema.DescribeSObjectResult Lead_DSR = Lead.SObjectType.getDescribe();
    String LeadId = Lead_DSR.getKeyPrefix();
    
    //get obj id of Opportunity to see if task was created against Opportunity
    Schema.DescribeSObjectResult Oppty_DSR = Opportunity.SObjectType.getDescribe();
    String OpptyId = Oppty_DSR.getKeyPrefix();
    
    //map of lead id and associated task
    map<id,Task> mapLeadTasks = new map<id,Task>();

    //map of oppty id and associated task
    map<id,Task> mapOpptyTasks = new map<id,Task>();
    
    if(trigger.isAfter && trigger.isInsert){
        
        for(Task aTask: trigger.new){
        
            if(aTask.Subject == 'Call'){            
                //if task is created against lead, populate map   
                if(aTask.WhoId != null && String.valueof(aTask.WhoId).startswith(LeadId )){
                    mapLeadTasks.put(aTask.WhoId,aTask);
                }
                //if task is created against opportunity, populate map
                else if(aTask.WhatId != null && String.valueof(aTask.WhatId).startswith(OpptyId )){
                    mapOpptyTasks.put(aTask.WhatId,aTask);
                } 
            }                      
        }  //for ends       
                
        if(mapLeadTasks.size()>0){
            //query leads related to created tasks, and check if record type is monarch shores    
            List<Lead> lstLeads = [select id,Name from Lead where Id in : mapLeadTasks.keyset() and (RecordType.Name = 'Monarch Shores' or RecordType.Name='Elite Rehab Placement')];
            
            //list for creating chatter feed
            list<FeedItem> lstInsertFeedItem  = new list<FeedItem>();
            
            //iterate over monarch shores leads and create chatter feed records
            for(Lead aLead : lstLeads){
                FeedItem post = new FeedItem(); 
                post.ParentId = aLead.Id;
                post.Body = mapLeadTasks.get(aLead.Id).Owner_Name__c+' placed a call to '+aLead.Name + ' at '+Datetime.now().format('MM/dd/YYYY hh:mm a');                  
                lstInsertFeedItem.add(post);
            }  
            if(lstInsertFeedItem.size()>0)
                insert lstInsertFeedItem;          
        }   
        if(mapOpptyTasks.size()>0){
            //query opportunities related to created tasks and check if record type is monarch shores
            List<Opportunity> lstOpportunities = [select id,Name from Opportunity where Id in : mapOpptyTasks.keyset() and (RecordType.Name = 'Monarch Shores' or RecordType.Name='Elite Rehab Placement')];
            
            // list for creating chatter feed
            list<FeedItem> lstInsertFeedItem  = new list<FeedItem>();
            
            //iterate over monarch shores opportunities and create chatter feed records
            for(Opportunity Oppty : lstOpportunities ){
                FeedItem post = new FeedItem(); 
                post.ParentId = Oppty.Id;
                post.Body = mapOpptyTasks.get(Oppty.Id).Owner_Name__c+' placed a call to '+Oppty.Name + ' at '+Datetime.now().format('MM/dd/YYYY hh:mm a');       
                lstInsertFeedItem.add(post);
            }  
            if(lstInsertFeedItem.size()>0)
                insert lstInsertFeedItem;          
        }    
    }    
}