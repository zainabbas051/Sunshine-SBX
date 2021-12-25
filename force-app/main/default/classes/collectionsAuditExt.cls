//Test Class : insuranceCaseViewExtTest
public with sharing class collectionsAuditExt{
    
    private final Opportunity oppRecord;
    public id oppRecordId;
    public integer indexVal{get;set;}
    
    public collectionsAuditExt(ApexPages.StandardController stdController) {
        this.oppRecord = (Opportunity)stdController.getRecord();
        oppRecordId = ApexPages.currentPage().getParameters().get('id');
        
        loadData();
    }
    
    public void showEditCase(){
        for(caseWrapper cw: caseWrapperList){
            system.debug(indexVal);//this gives us the index of the record we are trying to edit from the UI
            system.debug(cw.rowNumber);
            if(indexVal == cw.rowNumber){
                cw.displayFlag = True;
            }
        }    
    }
    
    public void saveCase(){
        for(caseWrapper cw: caseWrapperList){
            system.debug(indexVal);//this gives us the index of the record we are trying to edit from the UI
            system.debug(cw.rowNumber);
            if(indexVal == cw.rowNumber){
                cw.displayFlag = False;
                case tempCase = new Case();
                tempCase = cw.caseRecord;
                try{
                    if(tempCase.id != null)
                        update tempCase;
                    else
                        insert tempCase;
                }catch(exception e){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
                }
            }
        }    
    }
    
    
    public void addCase(){
        case tempCase = new Case();
        tempCase.Opportunity__c = oppRecordId;
        caseWrapperList.add(new caseWrapper(tempCase,False,caseWrapperList.size()));
    }
    
    Public List<caseWrapper> caseWrapperList{
        get{
            if(caseWrapperList == null){
                caseWrapperList = new List<caseWrapper>();
            }
            return caseWrapperList;
        }set;
    }
    
    public void loadData(){
        if(oppRecordId != null){
            List<Case> caseList = new List<Case>();
            Integer count=0;
            for(Case c : [Select id, Bill_Date__c, Bill_From_Date__c, Bill_To_Date__c, Billed_Amount__c, Level_Of_Care__C, Pricing_Type__c, Claim_Type__c, 
                          Collected_Amount__c, Collection_Date__c, Mode_of_Collection__c, Collection_Reference__c, Co_Pay_Amount__c, Deductible_Amount__c,
                          Write_Off_Reason__c, Audit_Status__c, Status, KIPU_MRN__c, Days_Taken_to_Collect__c 
                          from Case Where Opportunity__c =: oppRecordId AND RecordTypeId =: Constants.insuranceClaimRecordTypeId]){
                caseWrapperList.add(new caseWrapper(c,False,count));
                count++;
            }
        }
    }
    
    public class caseWrapper {
        public case caseRecord {get;set;}
        public boolean displayFlag{get;set;}
        public integer rowNumber{get;set;}
        public caseWrapper(case c, Boolean flag, integer rowNumber)
        {
            this.caseRecord = c;
            this.displayFlag = flag;
            this.rowNumber = rowNumber;
        }
    } 
  
  
}