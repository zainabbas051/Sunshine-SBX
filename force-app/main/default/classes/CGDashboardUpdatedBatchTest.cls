@isTest(seeAllData=True)
private class CGDashboardUpdatedBatchTest{
  public Static List<Dashboard> dashid;
    
    public Static testmethod void CGDashboardUpdatedBatchTest(){
        
          CreateSampleData();
           test.startTest();
            
            CGDashboardUpdatedBatch cg = new CGDashboardUpdatedBatch('123');         
            cg.RefreshDashboard('123');
            cg.CreateImageFromDashboard('123');
        
        test.StopTest(); 
            
    }
    
     public static void CreateSampleData(){
        
            }
}