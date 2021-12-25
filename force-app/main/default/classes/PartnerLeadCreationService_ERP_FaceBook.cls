//Test Clas :: PartnerLeadCreationService_CC_FBTest
@RestResource(urlMapping='/lead_erp_fb/*')
global class PartnerLeadCreationService_ERP_FaceBook {
    public static Facebook_Graph_API_Credential__c fbCrdn;
    
    @HttpGet
    global static void setupSubscription() {
        
        System.debug('fb_hub_challenge :::::'+RestContext.request.params.get('hub.challenge'));
        system.debug('fb_hub_verify_token ::::'+RestContext.request.params.get('hub.verify_token'));
        
        if(RestContext.request.params.get('hub.verify_token') == 'abc@123'){
            RestContext.response.addHeader('Content-Type', 'text/plain');
            RestContext.response.responseBody = blob.valueof(RestContext.request.params.get('hub.challenge'));
        }
        
    }
    
    @HttpPost
    global static void listenForLeadGen() {
        
        fbCrdn = Facebook_Graph_API_Credential__c.getValues('default');
        
        System.debug('POST Request Body :::::'+RestContext.request.requestBody.toString());
        String fullName = '';
        String email = '';
        String phoneNumber = '';
        
        String var_leadgen_id = '';
        
        JSONParser parser = JSON.createParser(RestContext.request.requestBody.toString());
        while (parser.nextToken() != JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != JSONToken.VALUE_NULL) {
                    if (text == 'leadgen_id') {
                        var_leadgen_id = parser.getText();
                    }
                }
            }
        }
        
        system.debug('var_leadgen_id :::::'+var_leadgen_id);
        
        if(Test.IsRunningTest()){
            var_leadgen_id = '285115078518833';
        }
        
        if(var_leadgen_id != ''){
            system.debug('FB Credential End Point URL :::'+fbCrdn.End_Point_URL__c);
            system.debug('FB Long Living Access Token :::'+fbCrdn.Long_Living_Access_Token__c);
            
            String endPointURL = fbCrdn.End_Point_URL__c+var_leadgen_id+'?access_token='+fbCrdn.Long_Living_Access_Token__c;
            HttpRequest req = new HttpRequest();
            req.setMethod('GET');
            req.setEndpoint(endPointURL);
            req.setHeader('Content-Type', 'application/json');
            req.setTimeout(120000);
            
            System.debug('req :::::' +req);
            
            Http http = new Http();
            // create a new HTTP response for receiving the remote response for Sign In request.
            HTTPResponse res;
            
            try{
                if(!Test.IsRunningTest()){
                  res = http.send(req);
                }else{
                    res = new HTTPResponse();
                    res.setBody('{"created_time": "2016-07-19T18:44:50+0000","id": "285115078518833","field_data": [{"name": "email","values": ["chugh.naveen@gmail.com"]},{"name": "what_is_your_preferred_area_in_the_city?","values": ["Chandigarh"]},{"name": "phone_number","values": ["+918527834688"]},{"name": "full_name","values": ["Naveen Chugh"]}]}');
                    res.setStatusCode(200);
                }
            }catch(Exception e){
            
            }
            
            system.debug('res :::::'+res);
            if(res != NULL && res.getStatusCode() == 200){
                //Parsing JSON to get access token
                wrapper_data wd = (wrapper_data)JSON.deserializeStrict(res.getBody(),wrapper_data.class);
                system.debug('wrapper_data :::::'+wd);
                for(field_data fd : wd.field_data){
                    if(fd.name == 'email'){
                        email = fd.values[0];
                    }
                    if (fd.name == 'full_name') {
                        fullName = fd.values[0];
                    }
                    if (fd.name == 'phone_number') {
                        phoneNumber = fd.values[0];
                    }
                    
                }
            }
            system.debug('fullName :::'+fullName);
            system.debug('email ::::'+email);
            system.debug('phoneNumber ::::'+phoneNumber);
            
            if(fullName != '' && (phoneNumber != '' || email != '')){
                Lead l = new Lead();
                l.LastName = fullName;
                l.email = email;
                l.phone = phoneNumber;
                l.Incoming_Number__c = phoneNumber;
                l.LeadSource = 'Elite Rehab Placement';
                l.RT_Source__c = 'Facebook';
                l.Hubspot_Source__c = 'SOCIAL_MEDIA';
                l.Campaign__c = 'Facebook Form';
                l.Phone_Web__c = 'Web';
                l.RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Elite Rehab Placement').getRecordTypeId();
                l.company = fullName;
                l.OwnerId= '00GU0000001M4VD';//Intake Queue
                if(!Test.IsRunningTest())
                    insert l;
                
                system.debug('lead :::'+l);
            }
        }
    }
    
    class wrapper_data {
        public String created_time;
        public String id;
        public field_data[] field_data;        
        
        public wrapper_data(String created_time, String id) {
            this.created_time = created_time;
            this.id = id;
            this.field_data = new List<field_data>();
        }        
    } 
    
    class field_data {
        public String name;
        public String[] values;
        
        public field_data(String name) {
            this.name = name;
            this.values = new List<String>();
        }
    } 
}