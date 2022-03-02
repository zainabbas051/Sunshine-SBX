//Test Class : updateBizibleAttributionOnOppTest
trigger updateBizibleAttributionOnOpp on bizible2__Bizible_Attribution_Touchpoint__c (after insert, after update) {
    
    List<Id> oppIdList = new List<Id>();
    Set<Id> oppIdSet = new Set<Id>();
    List<Opportunity> oppUpdateList = new List<Opportunity>();  
    List<bizible2__Bizible_Attribution_Touchpoint__c> batUpdateList = new List<bizible2__Bizible_Attribution_Touchpoint__c>();  
    Map<Id,bizible2__Bizible_Attribution_Touchpoint__c> bizibleIdMap = new Map<Id,bizible2__Bizible_Attribution_Touchpoint__c>();
      
    for(bizible2__Bizible_Attribution_Touchpoint__c bat : Trigger.New){
        if(bat.bizible2__Opportunity__c != null && bat.Attribution_Updated__c == False && bat.bizible2__Touchpoint_Position__c.contains('FT')){
            oppIdList.add(bat.bizible2__Opportunity__c);
            bizibleIdMap.put(bat.id,bat);
        }
    }
    
    if(!oppIdList.isEmpty()){
        for(Opportunity opp : [Select id, Bizible_Touchpoint_Position__c from Opportunity where ID IN: oppIdList]){
            if(opp.Bizible_Touchpoint_Position__c == null){
                oppIdSet.add(opp.id); 
            }
        }
    }
    
    if(!oppIdSet.isEmpty()){
        for(id batId : bizibleIdMap.keySet()){
            
            bizible2__Bizible_Attribution_Touchpoint__c tempBT = new bizible2__Bizible_Attribution_Touchpoint__c(id = batId);
            tempBT.Attribution_Updated__c = True;
            batUpdateList.add(tempBT);
            
            if(oppIdSet.contains(bizibleIdMap.get(batId).bizible2__Opportunity__c)){
                
                bizible2__Bizible_Attribution_Touchpoint__c bt = new bizible2__Bizible_Attribution_Touchpoint__c();
                bt = bizibleIdMap.get(batId);
                
                Opportunity tempOpp = new Opportunity(id = bt.bizible2__Opportunity__c);
                tempOpp.Bizible_Ad_Campaign_Name__c = bt.bizible2__Ad_Campaign_Name__c;
                tempOpp.Bizible_Ad_Content__c = bt.bizible2__Ad_Content__c;
                tempOpp.Bizible_Ad_Destination_URL__c = bt.bizible2__Ad_Destination_URL__c;
                tempOpp.Bizible_Ad_Group_Name__c = bt.bizible2__Ad_Group_Name__c;
                tempOpp.Bizible_Browser__c = bt.bizible2__Browser__c;
                tempOpp.Bizible_Form_URL__c = bt.bizible2__Form_URL__c;
                tempOpp.Bizible_Geo_City__c = bt.bizible2__Geo_City__c;
                tempOpp.Bizible_Geo_Country__c = bt.bizible2__Geo_Country__c;
                tempOpp.Bizible_Geo_Region__c = bt.bizible2__Geo_Region__c;
                tempOpp.Bizible_Keyword_Text__c = bt.bizible2__Keyword_Text__c;
                tempOpp.Bizible_Landing_Page__c = bt.bizible2__Landing_Page__c;
                tempOpp.Bizible_Marketing_Channel_Path__c = bt.bizible2__Marketing_Channel_Path__c;
                tempOpp.Bizible_Marketing_Channel__c = bt.bizible2__Marketing_Channel__c;
                tempOpp.Bizible_Medium__c = bt.bizible2__Medium__c;
                tempOpp.Bizible_Platform__c = bt.bizible2__Platform__c;
                tempOpp.Bizible_Referrer_Page__c = bt.bizible2__Referrer_Page__c;
                tempOpp.Bizible_Segment__c = bt.bizible2__Segment__c;
                tempOpp.Bizible_Touchpoint_Position__c = bt.bizible2__Touchpoint_Position__c;
                tempOpp.Bizible_Touchpoint_Source__c = bt.bizible2__Touchpoint_Source__c;
                tempOpp.Bizible_Touchpoint_Type__c = bt.bizible2__Touchpoint_Type__c;
                tempOpp.Bizible_UniqueId__c = bt.bizible2__UniqueId__c;
                oppUpdateList.add(tempOpp);
            }
        }
    }
    
    if(!oppUpdateList.isEmpty())
        update oppUpdateList;
    
    if(!batUpdateList.isEmpty())
        update batUpdateList;
}