@isTest
private class MarkContentRequestFloatingTest {
	
	static Content_Request__c cr;
	static OUTREACH_ACCOUNT__c oa;
	
	private static void CreateSampleData() {
		oa = new OUTREACH_ACCOUNT__c();
		oa.IsFloating__c = true;
		insert oa;
		
		cr = new Content_Request__c();
		cr.Related_Outreach_Account__c=oa.id;
		insert cr;
		
	

	
	}

	@isTest static void testController() {
		CreateSampleData();

		ApexPages.currentPage().getParameters().put('id', cr.Id + '');
		MarkContentRequestFloatingController controller = new MarkContentRequestFloatingController();

		ApexPages.currentPage().getParameters().put('confirm', true + '');
		controller.MarkFloating();
	}
	
}