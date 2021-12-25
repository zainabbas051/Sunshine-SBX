public with sharing class MarkContentRequestFloatingController {

    public MarkContentRequestFloatingController() {

    }

    public PageReference MarkFloating() {
        String result = ApexPages.currentPage().getParameters().get('confirm');
        String sObjId = ApexPages.currentPage().getParameters().get('id');
        list <OUTREACH_ACCOUNT__c> acc;
        Boolean res = Boolean.valueOf(result);
        if(res) {
           
            acc = [select id,name from OUTREACH_ACCOUNT__c where isfloating__c=true];
            Content_Request__c cr = [select id, Related_Outreach_Account__c,IsFloating__c from Content_Request__c where id = :sObjId];
           
            if(acc.IsEmpty()){
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'There is no Floating Outreach Account in the system');
                    ApexPages.addMessage(myMsg);
                    return null;
            }
            cr.Related_Outreach_Account__c=acc[0].id;
            
            update cr;
        }
        PageReference yourPage;
        
       
        yourPage = new PageReference('/' + sObjId );
        yourPage.setRedirect(true);
        return yourPage;
    }
}