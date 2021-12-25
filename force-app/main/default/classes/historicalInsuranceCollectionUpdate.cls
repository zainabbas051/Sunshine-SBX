//Test Class : historicalInsuranceCollectionUpdateTest
global class historicalInsuranceCollectionUpdate{
    
     webservice static String historicalInsuranceCollectionUpdate(String oppId){
         
         system.debug('oppId ::::'+oppId);
         string result;
         
         Opportunity tempOpp = [Select id, per_Selected_Program__c, Sunshine_Center__r.Name, Insurance_Provider__r.Chapters_Reimbursement_Rate__c, Insurance_Provider__r.Willow_Reimbursement_Rate__c, Insurance_Provider__r.Mountain_Reimbursement_Rate__c, Insurance_Provider__r.Monarch_Reimbursement_Rate__c from Opportunity where id=: oppId];
         if(tempOpp.per_Selected_Program__c == null){
             if(tempOpp.Sunshine_Center__r.Name.contains('Chapters')){
                 tempOpp.per_Selected_Program__c = tempOpp.Insurance_Provider__r.Chapters_Reimbursement_Rate__c;
             }
             if(tempOpp.Sunshine_Center__r.Name.contains('Willow')){
                 tempOpp.per_Selected_Program__c = tempOpp.Insurance_Provider__r.Willow_Reimbursement_Rate__c;
             }
             if(tempOpp.Sunshine_Center__r.Name.contains('Mountain')){
                 tempOpp.per_Selected_Program__c = tempOpp.Insurance_Provider__r.Mountain_Reimbursement_Rate__c;
             }
             if(tempOpp.Sunshine_Center__r.Name.contains('Monarch') || tempOpp.Sunshine_Center__r.Name.contains('Lincoln')){
                 tempOpp.per_Selected_Program__c = tempOpp.Insurance_Provider__r.Monarch_Reimbursement_Rate__c;
             }
             try{
                 update tempOpp;
                 result = 'The % per Selected Progr on the Opportunity is Sucessfully Updated!!';
             }catch(exception e){
                 result = 'OOOPS, Some thing went wrong while updating the opportunity. Please Contact Naveen!!';    
             }
         }else{
              result = 'The % per Selected Progr on the Opportunity is not Blank, so it cannot be updated!!';  
         }    
         
         system.debug('result:'+ result);
         return result;
      }

}