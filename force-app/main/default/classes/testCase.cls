public without Sharing class testCase{
    
    public testCase(){
        flag = False;
        loadData();
    }
    
    public boolean flag{get;set;}
    
    Public Case caseRecord{
        get{
            if(caseRecord == null){
                caseRecord = new Case();
            }
            return caseRecord;
        }set;
    }
    
    public void loadData(){
        for(Case c : [Select id, Subject, Status, Owner.Name, RecordType.Name, Origin, CaseNumber, Provider_Dispute_Initiated_Date_Time__c from Case LIMIT 1]){
            flag = True;
            caseRecord = c;
        }
    }
    
    public void updateTime(){
        caseRecord.Provider_Dispute_Initiated_Date_Time__c = dateTime.Now();
        update caseRecord;
    }
    
}