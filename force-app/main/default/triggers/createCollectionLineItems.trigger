//Test Class : createCollectionLineItemsTest
trigger createCollectionLineItems on Temp_Payment_Line_Items__c (after insert){
    
    list<Id> claimIdList = new List<Id>();
    list<Collection_Line_Item__c> cliInsertList = new List<Collection_Line_Item__c>();
    List<Case> caseUpdateList = new List<Case>();
    Map<String,Case> caseMap = new Map<String,Case>();
    
    Map<String,String> typeOfCollectionMap = new Map<String,String>();
    typeOfCollectionMap.put('A-AA','Appeal for adjustment');
    typeOfCollectionMap.put('A-AR','Applied Recoupment');
    typeOfCollectionMap.put('A-CRX','Collect Rx');
    typeOfCollectionMap.put('A-DC','Duplicate Collection');
    typeOfCollectionMap.put('A-FR','Forwarded Recoupment');
    typeOfCollectionMap.put('A-HSA','HSA-HRA');
    typeOfCollectionMap.put('A-IP','Interest Payments');
    typeOfCollectionMap.put('A-OP','Overpayment');
    typeOfCollectionMap.put('A-PP','Patient Payment');
    typeOfCollectionMap.put('A-RB','Re-bill');
    typeOfCollectionMap.put('A-TR','Total Recoupment');
    //typeOfCollectionMap.put('A-PTM','Paid To Member');
    
    for(Temp_Payment_Line_Items__c pli : Trigger.New){
        if(pli.Case__c != null){
            claimIdList.add(pli.Case__c);
        }
    }
    
    if(claimIdList.size()>0){
        for(Case c : [Select id, Claim_Number__c, Deductible_Amount__c, Non_Covered_Amount__c, Co_Insurance_Amount__c from Case where ID IN: claimIdList]){
            caseMap.put(c.Claim_Number__c,c);
        }
    }
    
    if(caseMap.keySet().size()>0){
        for(Temp_Payment_Line_Items__c pli : Trigger.New){
            if(pli.Charge_Claim_ID__c != null && caseMap.containsKey(pli.Charge_Claim_ID__c)){
                Case tempCase = new Case();
                tempCase = caseMap.get(pli.Charge_Claim_ID__c);
                if(pli.Deductible_Amount__c!=null){
                    if(tempCase.Deductible_Amount__c==null)
                        tempCase.Deductible_Amount__c = pli.Deductible_Amount__c;
                    else
                        tempCase.Deductible_Amount__c = tempCase.Deductible_Amount__c+pli.Deductible_Amount__c;
                }
                if(pli.Co_Insurance__c != null){
                    if(tempCase.Co_Insurance_Amount__c==null)
                        tempCase.Co_Insurance_Amount__c = pli.Co_Insurance__c;
                    else
                        tempCase.Co_Insurance_Amount__c = tempCase.Co_Insurance_Amount__c+pli.Co_Insurance__c;
                }
                if(pli.Payment_Allowed_Amount__c != null && pli.Charge_Amount__c != null){
                    if(tempCase.Non_Covered_Amount__c==null)
                        tempCase.Non_Covered_Amount__c = pli.Charge_Amount__c-pli.Payment_Allowed_Amount__c;
                    else
                        tempCase.Non_Covered_Amount__c = tempCase.Non_Covered_Amount__c+(pli.Charge_Amount__c-pli.Payment_Allowed_Amount__c);
                }
                caseMap.put(pli.Charge_Claim_ID__c,tempCase);
                
                Collection_Line_Item__c cli = new Collection_Line_Item__c();
                cli.Case__c = tempCase.id;
                cli.Temp_Payment_Line_Items__c = pli.id;
                if(pli.Payment_Total_Paid__c!=null)
                    cli.Collection_Amount__c = pli.Payment_Total_Paid__c;
                if(pli.Payment_Received__c != null)
                    cli.Collection_Date__c = pli.Payment_Received__c;
                if(pli.Payment_Check__c != null)
                    cli.Collection_Reference_Number__c = pli.Payment_Check__c;
                if(pli.Payment_Type__c != null)
                    cli.Mode_of_Collection__c = pli.Payment_Type__c;
                if(pli.Remark_Code_s__c == null)
                    cli.Type_of_Collection__c = 'Original bill';
                else if(pli.Remark_Code_s__c != null){
                    if(typeOfCollectionMap.containsKey(pli.Remark_Code_s__c)){
                        cli.Type_of_Collection__c = typeOfCollectionMap.get(pli.Remark_Code_s__c);
                    }else{
                        cli.Type_of_Collection__c = 'Original bill';
                    }
                }
                cliInsertList.add(cli);
                
                
            }
        }
    }
    
    if(cliInsertList.isEmpty()==False){
        insert cliInsertList;
        
        for(String claimId : caseMap.keySet()){
            Case tempCase = caseMap.get(claimId);
            tempCase.Status = 'Closed';
            caseUpdateList.add(tempCase);
        }
        update caseUpdateList;
    }
    
}