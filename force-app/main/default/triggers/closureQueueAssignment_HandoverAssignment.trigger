//Test Class : closureQueueAssignment_HandoverAssigTest
trigger closureQueueAssignment_HandoverAssignment on Lead (after insert, after update) {
    
    if(Trigger_Custom_Setting__c.getValues('Default') != null && Trigger_Custom_Setting__c.getValues('Default').Handover_Switch__c == True)
    return;                
    
    
    
    if(TriggerContextUtility3.isFirstRun()){
        TriggerContextUtility3.setFirstRunFalse(); 
    
        //list for inserting lead helper records
        list<Lead_Helper__c> leadHelperInsert = new list<Lead_Helper__c>();
        
        //list for updating leads
        list<Lead> lstUpdateLeads = new list<Lead>();
        Map<String,String> qualifyLeadSMSMap = new Map<String,String>();
        
        for(Lead l : Trigger.new){
            if(!l.IsConverted){
                system.debug(l.Status);
                system.debug(trigger.isInsert);
                if(l.Status == 'Qualified' && (trigger.isInsert || (l.status != trigger.oldMap.get(l.id).status && trigger.isUpdate))){
                    
                    String ownerId='';
                    String ownerName='';
                    String leadOwnerString = '';
                    
                    //premium lead
                    if(l.Premium_Leads__c)
                        leadOwnerString = TransfertoMSNewCtrl.getPremiumLeadOwner();
                    //normal lead
                    else
                        leadOwnerString = TransfertoMSNewCtrl.getNormalLeadOwner();
                    
                    system.debug('leadOwnerString ::::'+leadOwnerString);
                    List<String> leadOwnerStringList = new List<String>();
                    if(leadOwnerString != null){
                        leadOwnerStringList.addAll(leadOwnerString.split(';')); 
                        if(leadOwnerStringList.size()==1){
                            ownerId=leadOwnerString.split(';')[0];
                            ownerName=leadOwnerString.split(';')[0];
                        }else{
                            ownerId=leadOwnerString.split(';')[0];
                            ownerName=leadOwnerString.split(';')[1];
                        }
                    }else{
                        ownerId=label.Closers_Queue_Id;
                        ownerName='Closers Queue';
                    }
                    system.debug('ownerId ::::'+ownerId);
                    system.debug('ownerName ::::'+ownerName);
                    if(ownerId!= ''){
                        DateTime QualifiedDT = DateTime.newInstance(DateTime.Now().year(), DateTime.Now().month(), DateTime.Now().day(), DateTime.Now().hour(), DateTime.Now().minute(), 0);    
                        Lead updateLead = new Lead();
                        updateLead.OwnerId = ownerId;
                        updateLead.Lead_Handover_Default_AC__c = ownerId;
                        updateLead.Closer_Queue_User_Name__c = UserInfo.getName();
                        updateLead.Time_Lead_Qualified__c = QualifiedDT;
                        updateLead.id = l.id;
                        lstUpdateLeads.add(updateLead); 
                        
                        qualifyLeadSMSMap.put(label.Tom_Kearns_Id,'New Lead, '+l.FirstName+' '+l.LastName+', was qualified to '+ownerName);                  
                        qualifyLeadSMSMap.put(ownerId,'New Lead, '+l.FirstName+' '+l.LastName+', was qualified, and assigned to you!!');                           
                                                             
                        Lead_Helper__c lh = new Lead_Helper__c();
                        lh.Time_Lead_Qualified__c = QualifiedDT;
                        lh.Lead_Id__c = l.id;
                        lh.Lead_Owner__c = ownerName;
                        leadHelperInsert.add(lh);
                    }           
                }                
            }
        } 
        
        try{ 
            if(lstUpdateLeads.size()>0)
                try{
                    Utilities.sendSMS(qualifyLeadSMSMap);
                    update lstUpdateLeads;
                }catch(exception e){
                    system.debug('exception ::'+e.getMessage());
                }
                
            if(leadHelperInsert.size()>0)
                insert leadHelperInsert; 
        }catch(Exception e){
            system.debug(e.getMessage()+' '+e.getLineNUmber());
        }
    }
}