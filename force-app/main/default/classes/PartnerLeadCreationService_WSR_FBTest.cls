@istest
public class PartnerLeadCreationService_WSR_FBTest{
    
    static testMethod void  testPartnerLeadCreationService(){
        Test.startTest();
       
       Facebook_Graph_API_Credential__c fb_api = new Facebook_Graph_API_Credential__c();
       fb_api.name = 'willow_springs';
       fb_api.End_Point_URL__c = 'https://graph.facebook.com/';
       fb_api.Long_Living_Access_Token__c = '123456789';
       insert fb_api;
       
       //As Per Best Practice it is important to instantiate the Rest Context 
       
       
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
            gen.writeStringField('leadgen_id','123456');
        gen.writeEndObject();
       
       
       RestRequest req = new RestRequest(); 
       RestResponse res = new RestResponse();
       
       req.requestURI = '/services/apexrest/lead_ms_fb';  //Request URL
       req.httpMethod = 'POST';//HTTP Request Type
       RestContext.request = req;
       RestContext.response= res;
       
       req.requestBody = blob.valueOf(gen.getAsString());
       
       req.params.put('hub.challenge','JD57154BC2A4E7');
       req.params.put('hub.verify_token','abc@123');
       
       PartnerLeadCreationService_WSR_FaceBook.setupSubscription(); 
       
       PartnerLeadCreationService_WSR_FaceBook.listenForLeadGen();

       
       Test.stopTest();
   }

}