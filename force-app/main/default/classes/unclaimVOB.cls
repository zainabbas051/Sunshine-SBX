global without sharing class unclaimVOB{
    webservice static String unclaimVOB(String oppId){
    system.debug('oppID'+oppID);
    
    string result;
    opportunity oppIns = [select id,ownerid,name,VOB_Status__c, Latest_VOB_Request__c from opportunity where id=:oppID];
    
    if(userInfo.getuserId().contains(label.Tatiana_User_ID) || userInfo.getuserId().contains(label.Tahil_User_Id) || 
        userInfo.getuserId().contains(label.Andy_User_Id)|| userInfo.getuserId().contains(label.Lynelle_Smith_Id) || userInfo.getuserId().contains(label.Caylin_Blake_User_Id)||userInfo.getuserId().contains(label.Brent_Wood)){             
        if(oppIns.VOB_Status__c=='Open')
            result = 'VOB has not been claimed yet, it cannot be unclaimed!!';   
        else if(oppIns.VOB_Status__c=='In Progress'){
            oppIns.VOB_Status__c = 'Open';
            oppIns.VOB_Agent__c= null;
            OppIns.VOB_Claimed__c=null;
            update oppIns;
            
            if(oppIns.Latest_VOB_Request__c != null){
              VOB_Request__c vr = new VOB_Request__c(id=oppIns.Latest_VOB_Request__c, VOB_Agent__c = null, VOB_Claimed__c=null, VOB_Request_Status__c = 'Open');
              update vr;
              
            }
            result = 'VOB is sucessfully unclaimed!!';
        
        }
        else if(oppIns.VOB_Status__c=='Completed') 
            result = 'You cannot unclaim VOB, as VOB for this opportunity is already completed!!';   
        
        system.debug('result:'+ result);
    }else{
        result = 'Only Tahnil or Ashley can Unclaim a VOB!!';
    } 
    return result;
    }

}