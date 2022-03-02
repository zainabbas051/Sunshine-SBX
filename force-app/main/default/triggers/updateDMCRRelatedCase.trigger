//Test Class : updateDMCRRelatedCaseTest
trigger updateDMCRRelatedCase on Data_Missing_in_Claim_Request__c(after Update){
    
    List<Id> caseIdList = new List<Id>(); 
    
    List<Data_Missing_in_Claim_Request__c> DmcrUpdateList = new List<Data_Missing_in_Claim_Request__c>();
    
    List<Data_Missing_in_Claim_Request__c> DmcrInsertList = new List<Data_Missing_in_Claim_Request__c>();
    List<Insurance_Call_Log__c> IclInsertList = new List<Insurance_Call_Log__c>();
    List<Insurance_Claim_Medical_Records_Request__c > ICMRInsertList = new List<Insurance_Claim_Medical_Records_Request__c>();
    List<Insurance_Appeal_for_Adjustment_Request__c > IAARInsertList = new List<Insurance_Appeal_for_Adjustment_Request__c >();
    List<Documents__c> DAInsertList = new List<Documents__c>();
   
    List<Data_Missing_in_Claim_Request__c> DmcrDeleteList = new List<Data_Missing_in_Claim_Request__c>();
    List<Insurance_Call_Log__c> IclDeleteList = new List<Insurance_Call_Log__c>();
    List<Insurance_Claim_Medical_Records_Request__c > ICMRDeleteList = new List<Insurance_Claim_Medical_Records_Request__c>();
    List<Insurance_Appeal_for_Adjustment_Request__c > IAARDeleteList = new List<Insurance_Appeal_for_Adjustment_Request__c >();
    List<Documents__c> DADeletelist = new List<Documents__c>();
    
    List<Data_Missing_in_Claim_Request__c> dataclaimList = new List<Data_Missing_in_Claim_Request__c>();
    List<Insurance_Call_Log__c> callLogList = new List<Insurance_Call_Log__c>();
    List<Insurance_Claim_Medical_Records_Request__c > medicalRecordsList = new List<Insurance_Claim_Medical_Records_Request__c>();
    List<Insurance_Appeal_for_Adjustment_Request__c > appealForAdjustmentList = new List<Insurance_Appeal_for_Adjustment_Request__c >();
    List<Documents__c> documentsList = new List<Documents__c>();

               
    for(Data_Missing_in_Claim_Request__c dmcr: Trigger.New)
    {
        if(dmcr.Status__c == 'Closed' 
           && dmcr.Status__c != trigger.oldmap.get(dmcr.id).Status__c 
           && dmcr.New_Related_Case__c  != null)
         
                caseIdList.add(dmcr.Related_Case__c);
    } 
    
    if(caseIdList.size()>0){  
        String queryDataClaim = DMCRRelatedCase_SelectAll.SelectAll('Data_Missing_in_Claim_Request__c');
        queryDataClaim = queryDataClaim+' where Related_Case__c IN: caseIdList';
        for(Data_Missing_in_Claim_Request__c dmcr : Database.Query(queryDataClaim)){
            dataclaimList.add(dmcr); 
        }

    
        String queryCallLog = DMCRRelatedCase_SelectAll.SelectAll('Insurance_Call_Log__c');
        queryCallLog = queryCallLog+' where Related_Case__c IN: caseIdList';
        for(Insurance_Call_Log__c icl : Database.Query(queryCallLog)){
            callLogList.add(icl); 
        }
        
        String queryMedicalRecords= DMCRRelatedCase_SelectAll.SelectAll('Insurance_Claim_Medical_Records_Request__c');
        queryMedicalRecords = queryMedicalRecords+' where Related_Case__c IN: caseIdList';
        for(Insurance_Claim_Medical_Records_Request__c icmr : Database.Query(queryMedicalRecords)){
            medicalRecordsList.add(icmr);
        }
        
        String queryAppealForAdjustment= DMCRRelatedCase_SelectAll.SelectAll('Insurance_Appeal_for_Adjustment_Request__c');
        queryAppealForAdjustment = queryAppealForAdjustment+' where Related_Case__c IN: caseIdList';
        for(Insurance_Appeal_for_Adjustment_Request__c iaar : Database.Query(queryAppealForAdjustment)){
            appealForAdjustmentList.add(iaar);      
        }
        
        String queryDocuments= DMCRRelatedCase_SelectAll.SelectAll('Documents__c');
        queryDocuments = queryDocuments+' where Case__c IN: caseIdList';
        for(Documents__c da : Database.Query(queryDocuments)){
            documentsList.add(da); 
        }           
        
        for(Data_Missing_in_Claim_Request__c dmcr : Trigger.New){   
        
        
        Data_Missing_in_Claim_Request__c tempDMCR = new Data_Missing_in_Claim_Request__c(id=dmcr.id, Old_Related_Case__c = dmcr.Related_Case__c, Related_Case__c = dmcr.New_Related_Case__c, New_Related_Case__c = null);
        DmcrUpdateList.add(tempDMCR);
     
        
         if(dataclaimList.size()>0){
                for(Data_Missing_in_Claim_Request__c dmcr1 : dataclaimList){                                       
                    if(dmcr1.Related_Case__c == dmcr.Related_Case__c && 
                        dmcr1.Name !=  dmcr.Name){
                     Data_Missing_in_Claim_Request__c newdmcr = dmcr1.clone(false, false, false, false);
                     newdmcr.Related_Case__c = dmcr.New_Related_Case__c;
                     DmcrInsertList.add(newdmcr);
                     DmcrDeleteList.add(dmcr1);
                     }
                }
            }
            
                    
            if(callLogList.size()>0){
                for(Insurance_Call_Log__c icl : callLogList){                                       
                    if(icl.Related_Case__c == dmcr.Related_Case__c){
                     Insurance_Call_Log__c newicl = icl.clone(false, false, false, false);
                     newicl.Related_Case__c = dmcr.New_Related_Case__c;
                     IclInsertList.add(newicl);
                     IclDeleteList.add(icl);
                    }
                }
            }
            if(medicalRecordsList.size()>0){
                for(Insurance_Claim_Medical_Records_Request__c icmr : medicalRecordsList){                                       
                    if(icmr.Related_Case__c == dmcr.Related_Case__c){
                     Insurance_Claim_Medical_Records_Request__c newicmr = icmr.clone(false, false, false, false);
                     newicmr.Related_Case__c = dmcr.New_Related_Case__c;
                     IcmrInsertList.add(newicmr);
                     IcmrDeleteList.add(icmr);
                     }
                }
            }
            if(appealForAdjustmentList.size()>0){
                for(Insurance_Appeal_for_Adjustment_Request__c iaar : appealForAdjustmentList){                                       
                    if(iaar.Related_Case__c == dmcr.Related_Case__c){
                      Insurance_Appeal_for_Adjustment_Request__c newiaar = iaar.clone(false, false, false, false);
                      newiaar.Related_Case__c = dmcr.New_Related_Case__c;
                      IaarInsertList.add(newiaar);
                      IaarDeleteList.add(iaar);
                     }
                }
            }
            if(documentsList.size()>0){
                for(Documents__c da : documentsList){                                       
                    if(da.Case__c == dmcr.Related_Case__c){
                      Documents__c newda = da.clone(false, false, false, false);
                      newda.Case__c = dmcr.New_Related_Case__c;
                      daInsertList.add(newda);
                      dadeletelist.add(da);
                     }
                }
            }
        }
    }
   
   if(DmcrUpdateList.size()>0){
       Update DmcrUpdateList;
      }
   
   if(DmcrInsertList.size()>0){
       Insert DmcrInsertList;
      }

   if(IclInsertList.size()>0){
       Insert IclInsertList;
      }
       
   if(ICMRInsertList.size()>0){
       Insert ICMRInsertList;
   }
    
   if(IAARInsertList.size()>0){
       Insert IAARInsertList;
   }
     
   if(DAInsertList.size()>0){
       Insert DAInsertList;
   }
   
     if(DmcrDeleteList.size()>0){
       Delete DmcrDeleteList;
   }
   
   if(IclDeleteList.size()>0){
       Delete IclDeleteList;
   }
       
   if(ICMRDeleteList.size()>0){
       Delete ICMRDeleteList;
   }
    
   if(IAARDeleteList.size()>0){
       Delete IAARDeleteList;
   }
     
   if(DADeletelist.size()>0){
       Delete DADeletelist;
   }
  
   
}