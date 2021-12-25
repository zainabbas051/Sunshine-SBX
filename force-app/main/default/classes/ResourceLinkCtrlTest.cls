//test class for ResourceLinkCtrl
@isTest
public class ResourceLinkCtrlTest{
    
    static testmethod void ResourceLinkCtrlTest(){
        
        test.startTest();
        
        OUTREACH_ACCOUNT__c OA = new OUTREACH_ACCOUNT__c();
        OA.Status__c = 'Content Requested';
        insert OA;
        
        Test.setCurrentPageReference(Page.ContentRequest);

        System.currentPageReference().getParameters().put('id', OA.id);
        
        ResourceLinkCtrl CRC = new ResourceLinkCtrl();
        CRC.SaveRecord();
        CRC.cancel();
        CRC.getStatusOptions();
        
        test.stopTest();
    }
}