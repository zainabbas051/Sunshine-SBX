@isTest(seeAlldata = true)

public class MarketingGoalsClsTest {
    
    private testmethod static void validateMAG(){
        Test.startTest();
        Test.setCurrentPage(Page.MarketingGoals);
        MarketingGoalsCls mgc = new MarketingGoalsCls();
        mgc.getDataMAG();
       
        Test.stopTest();
    }
    
    private testmethod static void validateMOG(){
        Test.startTest();
        Test.setCurrentPage(Page.MarketingGoals);
        MarketingGoalsCls mgc = new MarketingGoalsCls();
        mgc.getDataMOG();
       
        Test.stopTest();
    }
    
    private testmethod static void validateDDG(){
        Test.startTest();
        Test.setCurrentPage(Page.MarketingGoals);
        MarketingGoalsCls mgc = new MarketingGoalsCls();
        mgc.getDataDDG();
       
        Test.stopTest();
    }
}