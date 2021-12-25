//Test Class : MarketingDashboardTest
public class MarketingDashboard{

    
    public String[] getStrings() {
      
      List<string> imgUrls = new list<string>(); 
     for(Attachment att : [select ID from attachment where parentid =: Label.MarketingDashboardRecordID])
      {
         imgUrls.add('/servlet/servlet.FileDownload?file='+att.id);
      }
     
      return imgUrls;

    }
      
      


}