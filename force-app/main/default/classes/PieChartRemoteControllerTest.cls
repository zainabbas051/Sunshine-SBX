@isTest 
public class PieChartRemoteControllerTest
{
    static testMethod void testMethod1() 
    {
        
    
      Test.startTest();
         
       SEO_Timesheet__c st= new SEO_Timesheet__c();
     //  st.id='a2J4D000000CiYx';
       st.Guest_Posts_Published__c=1;
       st.Blog_Posts_Published__c=2;
       st.Organic_Landing_Pages_Published__c=2;
       st.Resource_Links_Published__c=2;
        
       st.GuestPost_Content_Request_in_Progress__c=1;
       st.GuestPost_Content_Returned_For_Editing__c=2;
       st.GuestPost_Closed_Rejected__c=2;
       st.GuestPost_Closed_Accepted__c=2;
        
       st.GuestPost_Initial_Content_Submitted__c=1;
       st.RL_Content_Request_in_Progress__c=2;
       st.RL_Content_Returned_For_Editing__c=2;
       st.RL_Closed_Rejected__c=2;
        
       st.RL_Closed_Accepted__c=1;
       st.RL_Initial_Content_Submitted__c=2;
       st.OLP_Content_Request_in_Progress__c=2;
       st.OLP_Content_Returned_For_Editing__c=2;
        
       st.OLP_Closed_Rejected__c=1;
       st.OLP_Closed_Accepted__c=2;
       st.OLP_Initial_Content_Submitted__c=2;
       st.BP_Content_Request_in_Progress__c=2;
        
       st.BP_Content_Returned_For_Editing__c=1;
       st.BP_Closed_Rejected__c=2;
       st.BP_Closed_Accepted__c=2;
       st.BP_Initial_Content_Submitted__c=2;
       //st.CR_Type__c = 'Guest Post';
        
        insert st;
        
            ApexPages.StandardController sc = new ApexPages.StandardController(st);
            List<PieChartRemoteController.PieWedgeData> data = new List<PieChartRemoteController.PieWedgeData>();
            PieChartRemoteController obj = new PieChartRemoteController(sc );
            
            PieChartRemoteController.generatePieData(st.ID,'Guest Post');
            PieChartRemoteController.getRemotePieData2(st.ID);
            PieChartRemoteController.getRemotePieData3(st.ID);
            PieChartRemoteController.getRemotePieData3(st.ID);
            PieChartRemoteController.getRemotePieData4(st.ID);
            PieChartRemoteController.getRemotePieData(st.ID);
            
            
            
            
        Test.stopTest();
        
   
    }
}