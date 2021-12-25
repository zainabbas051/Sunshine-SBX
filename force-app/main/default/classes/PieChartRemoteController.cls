//TestClass PieChartRemoteControllerTest
global class PieChartRemoteController {


    
     global static SEO_Timesheet__c ST;


     public PieChartRemoteController(ApexPages.StandardController stdController) {
     PieChartRemoteController.ST = (SEO_Timesheet__c)stdController.getRecord();

    }

    

    @RemoteAction
    global static List<PieWedgeData> getRemotePieData(String STID) {

       
        return PieChartRemoteController.generatePieData(STID,'Guest Post');
    }
    
    
    @RemoteAction
    global static List<PieWedgeData> getRemotePieData2(String STID) {
       
        return PieChartRemoteController.generatePieData(STID,'RL');
    }

    @RemoteAction
    global static List<PieWedgeData> getRemotePieData3(String STID) {
       
        return PieChartRemoteController.generatePieData(STID,'OLP');
    }
    
    @RemoteAction
    global static List<PieWedgeData> getRemotePieData4(String STID) {
       
        return PieChartRemoteController.generatePieData(STID,'BP');
    }
    // Private data "generator"
    global static List<PieWedgeData> generatePieData(String STID, String CR_Type) {
           
           List<PieWedgeData> data = new List<PieWedgeData>();
           SEO_Timesheet__c st= [select id, Owner.id,Guest_Posts_Published__c,Blog_Posts_Published__c,Organic_Landing_Pages_Published__c,
                                Resource_Links_Published__c,GuestPost_Content_Request_in_Progress__c,GuestPost_Content_Returned_For_Editing__c,GuestPost_Closed_Rejected__c,
                                GuestPost_Closed_Accepted__c,GuestPost_Initial_Content_Submitted__c,RL_Content_Request_in_Progress__c,RL_Content_Returned_For_Editing__c,
                                RL_Closed_Rejected__c,RL_Closed_Accepted__c,RL_Initial_Content_Submitted__c,OLP_Content_Request_in_Progress__c,
                                OLP_Content_Returned_For_Editing__c,OLP_Closed_Rejected__c,OLP_Closed_Accepted__c,OLP_Initial_Content_Submitted__c,BP_Content_Request_in_Progress__c,
                                BP_Content_Returned_For_Editing__c,BP_Closed_Rejected__c,BP_Closed_Accepted__c,BP_Initial_Content_Submitted__c
                                from SEO_Timesheet__c where id=: STID limit 1];
                                
            if(CR_Type=='Guest Post')  {
                
            if(st.Guest_Posts_Published__c>0)
            data.add(new PieWedgeData('Link Published', st.Guest_Posts_Published__c));

            
            if(st.GuestPost_Content_Request_in_Progress__c>0)
            data.add(new PieWedgeData('Content Request In Progress', st.GuestPost_Content_Request_in_Progress__c));

            if(st.GuestPost_Content_Returned_For_Editing__c>0)
            data.add(new PieWedgeData('Content Returned For Editing', st.GuestPost_Content_Returned_For_Editing__c));
            
            if(st.GuestPost_Closed_Rejected__c>0)
            data.add(new PieWedgeData('Closed Rejected', st.GuestPost_Closed_Rejected__c));
           
            if( st.GuestPost_Closed_Accepted__c>0)
            data.add(new PieWedgeData('Closed Accepted', st.GuestPost_Closed_Accepted__c));
           
            if(st.GuestPost_Initial_Content_Submitted__c>0)
            data.add(new PieWedgeData('Initial Content Submitted', st.GuestPost_Initial_Content_Submitted__c));
           
            
                
            }
            
             if(CR_Type=='RL')  {
                
            
            
           if(st.Resource_Links_Published__c>0)
            data.add(new PieWedgeData('Link Published', st.Resource_Links_Published__c));

            
            if(st.RL_Content_Request_in_Progress__c>0)
            data.add(new PieWedgeData('Content Request In Progress', st.RL_Content_Request_in_Progress__c));

            if(st.RL_Content_Returned_For_Editing__c>0)
            data.add(new PieWedgeData('Content Returned For Editing', st.RL_Content_Returned_For_Editing__c));
            
            if(st.RL_Closed_Rejected__c>0)
            data.add(new PieWedgeData('Closed Rejected', st.RL_Closed_Rejected__c));
           
            if( st.RL_Closed_Accepted__c>0)
            data.add(new PieWedgeData('Closed Accepted', st.RL_Closed_Accepted__c));
           
            if(st.RL_Initial_Content_Submitted__c>0)
            data.add(new PieWedgeData('Initial Content Submitted', st.RL_Initial_Content_Submitted__c));
                
            }
            
            if(CR_Type=='OLP')  {
                
             if(st.Organic_Landing_Pages_Published__c>0)
            data.add(new PieWedgeData('Link Published', st.Organic_Landing_Pages_Published__c));

            
            if(st.OLP_Content_Request_in_Progress__c>0)
            data.add(new PieWedgeData('Content Request In Progress', st.OLP_Content_Request_in_Progress__c));

            if(st.OLP_Content_Returned_For_Editing__c>0)
            data.add(new PieWedgeData('Content Returned For Editing', st.OLP_Content_Returned_For_Editing__c));
            
            if(st.OLP_Closed_Rejected__c>0)
            data.add(new PieWedgeData('Closed Rejected', st.OLP_Closed_Rejected__c));
           
            if( st.OLP_Closed_Accepted__c>0)
            data.add(new PieWedgeData('Closed Accepted', st.OLP_Closed_Accepted__c));
           
            if(st.OLP_Initial_Content_Submitted__c>0)
            data.add(new PieWedgeData('Initial Content Submitted', st.OLP_Initial_Content_Submitted__c));
                
            }
            if(CR_Type=='BP')  {
                
       
           if(st.Blog_Posts_Published__c>0)
            data.add(new PieWedgeData('Link Published', st.Blog_Posts_Published__c));

            
            if(st.BP_Content_Request_in_Progress__c>0)
            data.add(new PieWedgeData('Content Request In Progress', st.BP_Content_Request_in_Progress__c));

            if(st.BP_Content_Returned_For_Editing__c>0)
            data.add(new PieWedgeData('Content Returned For Editing', st.BP_Content_Returned_For_Editing__c));
            
            if(st.BP_Closed_Rejected__c>0)
            data.add(new PieWedgeData('Closed Rejected', st.BP_Closed_Rejected__c));
           
            if( st.BP_Closed_Accepted__c>0)
            data.add(new PieWedgeData('Closed Accepted', st.BP_Closed_Accepted__c));
           
            if(st.BP_Initial_Content_Submitted__c>0)
            data.add(new PieWedgeData('Initial Content Submitted', st.BP_Initial_Content_Submitted__c));
                
            }
            system.debug(data);

        return data;
    }
    
  
    // Wrapper class
    global class PieWedgeData {

        public String name { get; set; }
        public Decimal data { get; set; }

        global PieWedgeData(String name, Decimal data) {
            this.name = name;
            this.data = data;
        }
    }
}