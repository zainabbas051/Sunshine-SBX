//Test Class : caseViewExtTest
public without sharing class caseViewExt{
    
    private final Case caseRecord;
    public id caseRecordId;
    
    public caseViewExt(ApexPages.StandardController controller) {
        this.caseRecord = (Case)controller.getRecord();
        caseRecordId = ApexPages.currentPage().getParameters().get('id');
        //pageRedirect();
    }
    
    public pageReference pageRedirect(){
        Case tempCase= new Case();
        tempCase = [Select id, RecordTypeId from case where id =: caseRecordId];
        if(tempCase.RecordTypeId == Constants.sfSupportCaseRecordTypeId){
            PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/sfSupportCaseView?id='+tempCase.id);
            return pr;
        }
        else{
            PageReference pr = new PageReference(URL.getSalesforceBaseUrl().toExternalForm()+'/apex/insuranceCaseViewPage?id='+tempCase.id);
            return pr;
        }
    }
    
}