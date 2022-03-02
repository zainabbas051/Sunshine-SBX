/*
    this trigger is for updating last activity date on oppty
    author: Huma
    modified: 7/30/2016
*/
trigger TrgChatterFeedItem on FeedItem (after insert) {
	
    //get obj id of Opportunity to see if task was created against Opportunity
    Schema.DescribeSObjectResult Oppty_DSR = Opportunity.SObjectType.getDescribe();
    String OpptyId = Oppty_DSR.getKeyPrefix();
    
    //map of opportunity id and chatter created by ids
    map<id,id> mapOpptyIdAndOwner = new map<id,id>();
    
    //check if feed item is created against opportunity and capture created by id
    for(FeedItem feed : trigger.new){
    	if(feed.ParentId != null && String.valueof(feed.ParentId).startswith(OpptyId )){
			mapOpptyIdAndOwner.put(feed.ParentId,feed.CreatedById);
        }
    }
    
    //list for updating opportunities
    list<Opportunity> lstUpdateOpportunity = new list<Opportunity>();
    
    //query opportunities related to feeds and check if feed is created by owner then update last activity date
    for(Opportunity opp : [select id,OwnerId from Opportunity where id in: mapOpptyIdAndOwner.keyset()]){
        if(opp.OwnerId == mapOpptyIdAndOwner.get(opp.id)){
            Opportunity updateOpp = new Opportunity();
            updateOpp.id = opp.id;
            updateOpp.Last_Activity_Date__c = DateTime.now();
            lstUpdateOpportunity.add(updateOpp);
        }
    }
    
    if(lstUpdateOpportunity.size()>0)
    	update lstUpdateOpportunity;  
}