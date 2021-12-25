@isTest
private class urLOCUpdateOnClientChartTest{
    
    public static event ev2;
     
     public Static void createSampleData(){
        
        ev2 = new Event();
        ev2.DurationInMinutes = 0;
        ev2.ActivityDateTime = dateTime.Now();
        insert ev2;
     }
     
     public Static testmethod void UtilizationReviewHomeControllerTest(){
     
         test.startTest();
       
             createSampleData();
          
          test.StopTest();                                        
                             
      }       
    

}