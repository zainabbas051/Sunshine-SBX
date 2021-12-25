/*
Test Class : ChangesCollection_Rest_Test
*/
@RestResource(urlMapping='/challenges/*')
global without sharing class ChangesCollection_Rest {
    public ChangesCollection_Rest() {

    }

    @HttpGet
    global static void showChallengesCollection(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        try{

            if(RestContext.request.params.isEmpty()){
                res.responseBody = Blob.valueOf('Invalid Request');
                res.statusCode = 500;
                return;
            }
            ChallengesCollectionWrapperReq challengeObj = new ChallengesCollectionWrapperReq(RestContext.request.params.get('max'),
                                                                    RestContext.request.params.get('page'));

            List<Alumni_App_Challenges_Configurations__c> lstChallenges = ChallengesSelector.getChallengesConfig(challengeObj.maxLimit,challengeObj.pageNumber - 1);
            List<challenges_collection> lstChallengeCollection = new List<challenges_collection>();
            ChallengesWrapperResponse challengeResponse = new ChallengesWrapperResponse();
            challengeResponse.maxLimit = lstChallenges.size();
            challengeResponse.page = challengeObj.pageNumber;
            challengeResponse.challenges_collection = lstChallengeCollection;

            for(Alumni_App_Challenges_Configurations__c iApp : lstChallenges){

                    challenges_collection challengeCollection = new challenges_collection();
                    challengeCollection.id = iApp.Id;
                    challengeCollection.name = iApp.Name;
                    challengeCollection.text = iApp.Challenge_Description__c;
                    challengeCollection.image = iApp.Challenge_Landscape_Image__c;
                    challengeCollection.image_landscape = iApp.Challenge_Thumbnail_Image__c;
                    lstChallengeCollection.add(challengeCollection);
            }
           
            res.responseBody = Blob.valueOf(System.JSON.serialize(challengeResponse));
            res.statusCode = 200;
            return;
            
        }
        catch(Exception ex){
            res.responseBody = Blob.valueOf(ex.getMessage() + ' ' + ex.getLineNumber());
            res.statusCode = 500;
        }
    }

    public class ChallengesCollectionWrapperReq{
        public integer maxLimit;
        public integer pageNumber;

        public ChallengesCollectionWrapperReq(string aMaxLimit,string aPageNumber){
            maxLimit = integer.valueOf(aMaxLimit);
            pageNumber = integer.valueOf(aPageNumber);
        }
    }

    public class ChallengesWrapperResponse{

        public integer maxLimit;
        public integer page;
        public List<challenges_collection> challenges_collection;

    }

    public class challenges_collection{
      
        public string id;
        public string name;
        public string text;
        public string image;
        public string image_landscape;
        public integer participant;
        public integer duration;  
    }
}