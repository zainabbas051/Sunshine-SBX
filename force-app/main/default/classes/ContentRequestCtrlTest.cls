//test class for ContentRequestCtrl
@isTest
public class ContentRequestCtrlTest{
    
    static testmethod void ContentRequestCtrl(){
        
        test.startTest();
        
        OUTREACH_ACCOUNT__c OA = new OUTREACH_ACCOUNT__c();
        OA.Status__c = 'Content Requested';
        insert OA;
        
        Test.setCurrentPageReference(Page.ContentRequest);

        System.currentPageReference().getParameters().put('id', OA.id);
        
        ContentRequestCtrl CRC = new ContentRequestCtrl();
        CRC.SaveRecord();
        CRC.cancel();
        
        test.stopTest();
    }
}