@isTest(SeeAllData=True)
private class cntplacementCenterTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Test.StartTest();
        
        cntplacementCenter cnt=new cntplacementCenter();
        
        Placement_Center__c placeCent=new Placement_Center__c();
        placeCent.Name='Testing';
        placeCent.Active__c=true;
        placeCent.Email__c='test@teston.com;test@test4.com;test@test1.com';
        
        upsert placeCent;
        
        cnt.placementId=placeCent.id;
        cnt.editAddplacement();
        cnt.closeInfo();
        cnt.addPlacement();
        cnt.savePlacement();

        cnt.addPlacement();
        cnt.placementCenter.Name='teting';
        cnt.placementCenter.Active__c=true;
        cnt.addRow();
        cnt.addRow();
        cnt.addRow();
        cnt.numberOfRowToRemove=1;
        cnt.delemailRow();
        cnt.delPlacementRecordRow();
        cnt.savePlacement();
        
                
        Test.StopTest();
    }
}