@isTest
private class CollectorDashboardTest {

	static List<User> users;



	private static void CreateSampleData() {
		Profile adminProfile = [Select Id, Name From Profile where name = 'System Administrator' limit 1];
		User user1 = new user (Username = ' test@key.net', FirstName = 'FirstTest', LastName = 'LastTest', alias = 'FLast',
		                       email = 'test@key.net', communityNickname = 'test0101019', TimeZoneSidKey = 'America/New_York',
		                       LocaleSidKey = 'en_US', EmailEncodingKey = 'ISO-8859-1', ProfileId = adminProfile.Id ,
		                       LanguageLocaleKey = 'en_US');

		User user2 = new user (Username = ' test2@key.net', FirstName = 'FirstTest', LastName = 'LastTest', alias = 'FLast',
		                       email = 'test@key.net', communityNickname = 'test0101020', TimeZoneSidKey = 'America/New_York',
		                       LocaleSidKey = 'en_US', EmailEncodingKey = 'ISO-8859-1', ProfileId = adminProfile.Id ,
		                       LanguageLocaleKey = 'en_US');

		insert user1;
		insert user2;
		
		users = new List<User>();
		users.add(user1);
		users.add(user2);
	}

	@isTest
	static void testDashboard() {

		CreateSampleData();
		CollectorDashboardController dashboard = new CollectorDashboardController();

		dashboard.MakeNewCollectorItem();
		ApexPages.currentPage().getParameters().put('itemPositionToDelete', '0');
		dashboard.DeleteCollectorItem(); // Deleting NewCollector

		dashboard.MakeNewCollectorItem();
		dashboard.NewCollectorItem.User.Collector_Holder__c = users.get(0).id;
		dashboard.SaveNewCollectorItem();
		ApexPages.currentPage().getParameters().put('itemPositionToDelete', '0');
		dashboard.DeleteCollectorItem(); // Deleting when only 1 collector in the list

		ApexPages.currentPage().getParameters().put('itemPositionToDelete', '1');
		dashboard.MakeNewCollectorItem();
		dashboard.NewCollectorItem.User.Collector_Holder__c = users.get(1).id;
		dashboard.SaveNewCollectorItem();
		dashboard.DeleteCollectorItem(); // Deleting when only 2 collectors in the list

		ApexPages.currentPage().getParameters().put('itemPositionToDelete', '0');
		dashboard.MakeNewCollectorItem();
		dashboard.NewCollectorItem.User.Collector_Holder__c = users.get(1).id;
		dashboard.SaveNewCollectorItem();
		dashboard.DeleteCollectorItem(); // Deleting LastAssigned collector

	}
}