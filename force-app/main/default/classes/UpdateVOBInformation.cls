global class UpdateVOBInformation{

    webservice static String UpdateVOBInformation(String oppId){
    
        system.debug('oppId::::'+oppId);
        string result;
        Set<string> VOBsetID = new Set<string>();

        
        list<opportunity> lstOpp = [select id,Latest_VOB_Request__c from opportunity where id=:oppId];
        
         for(Opportunity OppIns: lstOpp ){
             VOBsetID.add(OppIns.Latest_VOB_Request__c ) ;
        }
        
        list<VOB_Request__c> LstVob = [SELECT Id,Opportunity__c FROM VOB_Request__c where id=:VOBsetID];
                system.debug('VobsetID::::'+ VOBsetID);

        system.debug('LstOpp::::'+ lstOpp);
        system.debug('LstVOb:::::'+ LstVob);
        VOBOpportunityUpdateProcess.UpdateOpportunities(lstOpp ,LstVob );
        result='VOB information updated successfully!!';
        return result;


    }


}