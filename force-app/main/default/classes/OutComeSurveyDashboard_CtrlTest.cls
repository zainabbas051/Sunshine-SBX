@isTest(seeAllData=false)
public class OutComeSurveyDashboard_CtrlTest {
       
        static final string DOCUMENTDEVNAME = 'dash_31';
    static final string DOCUMENTNAME = 'dash_31';

     static testMethod void unitTest(){
         
           Document newDocument =getDocument('Some Text',
                'application/pdf',DOCUMENTDEVNAME,true,
                DOCUMENTNAME,UserInfo.getUserId());

        //will added in My Personal Documents folder
        insert newDocument;
        
        newDocument =getDocument('Some Text',
                'application/pdf',DOCUMENTDEVNAME+1,true,
                DOCUMENTNAME+1,UserInfo.getUserId());

        //will added in My Personal Documents folder
        insert newDocument;
        
        newDocument =getDocument('Some Text',
                'application/pdf',DOCUMENTDEVNAME+2,true,
                DOCUMENTNAME+2,UserInfo.getUserId());

        //will added in My Personal Documents folder
        insert newDocument;
         OutComeSurveyDashboard_Ctrl ctrl = new OutComeSurveyDashboard_Ctrl();

     
     }
     
      static testMethod void unitTest1(){
         
           Document newDocument =getDocument('Some Text',
                'application/pdf',DOCUMENTDEVNAME,true,
                DOCUMENTNAME,UserInfo.getUserId());

        //will added in My Personal Documents folder
        insert newDocument;
        
        newDocument =getDocument('Some Text',
                'application/pdf',DOCUMENTDEVNAME+1,true,
                DOCUMENTNAME+1,UserInfo.getUserId());

        //will added in My Personal Documents folder
        insert newDocument;
        
     
         OutComeSurveyDashboard_Ctrl ctrl = new OutComeSurveyDashboard_Ctrl();

     
     }
     
       public static Document getDocument(String body, String contentType, String developerName, Boolean isPublic, String name, String folderId ){
       
        Document document = new Document();
        document.Body = Blob.valueOf(body);
        document.ContentType = contentType;
        document.DeveloperName = developerName;
        document.IsPublic = isPublic;
        document.Name = name;
        document.FolderId = folderId;
        return document;
    }

}