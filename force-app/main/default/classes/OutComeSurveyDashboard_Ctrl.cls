public class OutComeSurveyDashboard_Ctrl{

    public List<WrapperDashBoard> lstWrapperDashBoard {get;set;}
    
    public OutComeSurveyDashboard_Ctrl(){
        
        List<Document> lstDoc = [Select ID,Description from Document where Name like 'dash_3%'];
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