/*
Test Class : Coach_Rest_Test
 */
@RestResource(urlMapping='/learn_home/*')
global class Coach_Rest {
   

    @HttpGet
    global static void showLearningMaterial(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        try{

            if(RestContext.request.params.isEmpty()){
                res.responseBody = Blob.valueOf('Invalid Request');
                res.statusCode = 500;
                return;
            }
            MotivationWrapperRequest motivationObj = new MotivationWrapperRequest(RestContext.request.params.get('max'),
                                                                    RestContext.request.params.get('page'));
            
            if(RestContext.request.params.keySet().contains('tag')){
                motivationObj.tag = RestContext.request.params.get('tag');
            }else{
                motivationObj.tag = '';
            }
            if(RestContext.request.params.keySet().contains('type')){
                motivationObj.type = RestContext.request.params.get('type');
            }else{
                motivationObj.type = '';
            }
                                                                    
            List<Alumni_App_Daily_Content__c> lstMotivation = MotivationSelector.getContentCoach(motivationObj.maxLimit,motivationObj.pageNumber - 1, motivationObj.tag, motivationObj.type);
            List<learn_collection> lstLearnCollection = new List<learn_collection>();
            learn_primary qt;
            MotivationWrapperResponse motivationResponse = new MotivationWrapperResponse();
            integer index = 0;
            for(Alumni_App_Daily_Content__c iApp : lstMotivation){
                    
                if(index++ != 0){
                    learn_collection qc = new learn_collection();
                    qc.id = iApp.Id;
                    qc.name = iApp.Name;
                    qc.text = iApp.Content_Body__c;
                    qc.author = iApp.Author__c;
                    qc.image = iApp.Main_Image_URL__c;
                    qc.image_landscape = iApp.Thumbnail_Image_URL__c;
                    if(iApp.type__c.contains('Video')){
                        qc.type = 'video';
                        qc.resourceUrl=iApp.Resource_URL__c;
                    }
                    if(iApp.type__c.contains('Audio')){
                        qc.type = 'audio';
                        qc.resourceUrl= iApp.Resource_URL__c;
                    }
                    if(iApp.type__c.contains('Articles')){
                        qc.type = 'text';
                        qc.resourceUrl='';
                    }
                    //qc.type = iApp.type__c;
                    lstLearnCollection.add(qc);
                    continue;
                }
                qt = new learn_primary();
                qt.name = iApp.Name;
                qt.text = iApp.Content_Body__c;
                qt.author = iApp.Author__c;
                qt.image_landscape = iApp.Thumbnail_Image_URL__c;    
                //qt.type = iApp.type__c; 
                if(iApp.type__c.contains('Video')){
                    qt.type = 'video';
                    qt.resourceUrl=iApp.Resource_URL__c;
                }
                if(iApp.type__c.contains('Audio')){
                    qt.type = 'audio';
                    qt.resourceUrl= iApp.Resource_URL__c;
                }
                if(iApp.type__c.contains('Articles')){
                    qt.type = 'text';
                    qt.resourceUrl='';
                }   
                motivationResponse.learn_primary =  qt;  
            }
            //Setting the Value of maxLimit variable, The Variable essentially returns, 
            //the number of possible of DB Rows still present in the system, that the mobile App can query.
            if(lstMotivation.size() == motivationObj.maxLimit){
                motivationResponse.maxLimit = motivationObj.maxLimit;
            }else{
                motivationResponse.maxLimit = 0;
            }
            motivationResponse.page = motivationObj.pageNumber;
            motivationResponse.learn_collection = lstLearnCollection;
            
            res.responseBody = Blob.valueOf(System.JSON.serialize(motivationResponse));
            res.statusCode = 200;
            return;
            
        }
        catch(Exception ex){
            res.responseBody = Blob.valueOf(ex.getMessage() + ' ' + ex.getLineNumber());
            res.statusCode = 500;
        }
    }

    public class MotivationWrapperRequest{
        public integer maxLimit;
        public integer pageNumber;
        public string tag;
        public string type;
        
        public MotivationWrapperRequest(string aMaxLimit,string aPageNumber){
            maxLimit = integer.valueOf(aMaxLimit);
            pageNumber = integer.valueOf(aPageNumber);
        }
    }

    public class MotivationWrapperResponse{

        public integer maxLimit;
        public integer page;
        public learn_primary learn_primary;
        public List<learn_collection> learn_collection;

    }

    public class learn_primary{
        public string type;
        public string name;
        public string text;
        public string author;
        public string image_landscape;
        public string resourceUrl;
    }
    public class learn_collection{
      
        public string id;
        public string name;
        public string text;
        public string author;
        public string image;
        public string image_landscape;
        public string type;
        public string resourceUrl;
      
    
    }
}