public class SendEmailToSubscribersCntrl {
	public List<WrapperDashBoard> lstWrapperDashBoard {get;set;}
    public string dashName {get; set;}
    public SendEmailToSubscribersCntrl(){
        
        String dashId = ApexPages.currentPage().getParameters().get('dashid');
        string qryWhere = 'dash_' + dashId +'%';
        dashName = [select id, title from dashboard where id=: dashId].Title;
        List<Document> lstDoc = [Select ID,Description from Document where Name like: qryWhere];
        integer index = 0;
        List<WrapperDashBoardInner> lstWrapper = new List<WrapperDashBoardInner>();
        lstWrapperDashBoard = new List<WrapperDashBoard> ();
        
        
        
        for(Document iDoc : lstDoc){
            
            index ++;
            lstWrapper.add(new WrapperDashBoardInner(iDoc.Id,iDoc.Description));
            if(math.mod(index,3) == 0){
                lstWrapperDashBoard.add(new WrapperDashBoard(lstWrapper));
                 lstWrapper = new List<WrapperDashBoardInner>();
                
            }
        }
        
        if(!lstWrapper.isEmpty()){
             lstWrapperDashBoard.add(new WrapperDashBoard(lstWrapper));
                 lstWrapper = new List<WrapperDashBoardInner>();
        }
        
    }
    
    
    
    public class WrapperDashBoard{
        
        public List<WrapperDashBoardInner> lstDashBoard {get;set;}
         public WrapperDashBoard(List<WrapperDashBoardInner> aLstDashBoard){
            lstDashBoard = aLstDashBoard;
        }
    
    }
    
    public class WrapperDashBoardInner{
        
        public string docId {get;set;}
        public string description {get;set;}
        public WrapperDashBoardInner(string aDocId,string aDesc){
            docId = aDocId;
            description = aDesc;
        }
    
    }
}