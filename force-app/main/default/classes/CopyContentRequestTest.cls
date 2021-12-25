@isTest
private class CopyContentRequestTest {

	static Content_Request__c cr;
	static OUTREACH_ACCOUNT__c oa;
	static OUTREACH_ACCOUNT__c floatingOA;

	private static void CreateSampleData() {
		cr = new Content_Request__c();
		insert cr;

		oa = new OUTREACH_ACCOUNT__c();
		insert oa;
		
		floatingOA = new OUTREACH_ACCOUNT__c();
		floatingOA.IsFloating__c = true;
		insert floatingOA;
	}

	@isTest static void testController() {
		// Create OutreachAccount and put its id in ContentRequest.Related_Outreach_Account__c
		CreateSampleData();

		ApexPages.currentPage().getParameters().put('id', cr.Id + '');
		ApexPages.currentPage().getParameters().put('isFloating', 'false');
		CopyContentRequestController controller = new CopyContentRequestController();
		controller.ContentRequest.Related_Outreach_Account__c = oa.Id;
		controller.Save();
	}

	@isTest static void testFloatingController() {
		// Create OutreachAccount and put its id in ContentRequest.Related_Outreach_Account__c
		CreateSampleData();

		ApexPages.currentPage().getParameters().put('id', cr.Id + '');
		ApexPages.currentPage().getParameters().put('isFloating', 'true');
		
		CopyContentRequestController controller = new CopyContentRequestController();
		controller.ContentRequest.Related_Outreach_Account__c = floatingOA.Id;
		controller.Save();
	}
}