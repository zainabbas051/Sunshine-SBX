/* 
Test Class : MotivationQuotes_Rest_Test
*/
@RestResource(urlMapping='/motivation_home/*')
global class MotivationQuotes_Rest {
   

    @HttpGet
    global static void showQuotes(){
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

            List<Alumni_App_Daily_Content__c> lstMotivation = MotivationSelector.getContentMotivation(motivationObj.maxLimit,motivationObj.pageNumber - 1);
            List<quote_collection> lstQuoteCollection = new List<quote_collection>();
            quote_today qt;
            MotivationWrapperResponse motivationResponse = new MotivationWrapperResponse();

            for(Alumni_App_Daily_Content__c iApp : lstMotivation){

                motivationResponse.maxLimit = lstMotivation.size();
                motivationResponse.page = motivationObj.pageNumber;
                motivationResponse.quote_collection = lstQuoteCollection;

                if(iApp.Published_Date__c != Date.Today()){
                    quote_collection qc = new quote_collection();
                    qc.id = iApp.Id;
                    qc.name = iApp.Name;
                    qc.text = iApp.Content_Body__c;
                    qc.author = iApp.Author__c;
                    qc.image = iApp.Main_Image_URL__c;
                    qc.image_landscape = iApp.Thumbnail_Image_URL__c;
                    lstQuoteCollection.add(qc);
                    continue;
                }
                qt = new quote_today();
                qt.text = iApp.Content_Body__c;
                qt.author = iApp.Author__c;
                qt.image_landscape = iApp.Thumbnail_Image_URL__c;    
                motivationResponse.quote_today =  qt;  
            }
           
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

        public MotivationWrapperRequest(string aMaxLimit,string aPageNumber){
            maxLimit = integer.valueOf(aMaxLimit);
            pageNumber = integer.valueOf(aPageNumber);
        }
    }

    public class MotivationWrapperResponse{

        public integer maxLimit;
        public integer page;
        public quote_today quote_today;
        public List<quote_collection> quote_collection;

    }

    public class quote_today{
        public string text;
        public string author;
        public string image_landscape;
    }
    public class quote_collection{
      
        public string id;
        public string name;
        public string text;
        public string author;
        public string image;
        public string image_landscape;
      
    
    }
}