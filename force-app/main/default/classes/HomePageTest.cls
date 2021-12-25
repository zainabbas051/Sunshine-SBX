@isTest
private class HomePageTest{
    
    testmethod static void HomePageCtrl(){
    
        test.starttest();
        
        HomePageCtrl h = new HomePageCtrl();
        h.redirect = true;
        h.redirectPage();
        h.showClients();
        
        test.stoptest();
    }
}