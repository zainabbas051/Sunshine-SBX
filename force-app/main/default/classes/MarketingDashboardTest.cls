@isTest(seeAllData=True)
private class MarketingDashboardTest{
    
    public Static testmethod void MarketingDashboardTest(){
        test.startTest();
        
            MarketingDashboard md = new MarketingDashboard();         
            String[] returnString = md.getStrings();
        
        test.StopTest();
    }
}