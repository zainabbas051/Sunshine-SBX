public with sharing class EmpowermentSurveyTrigger_Handler {

    static integer distance = 50;
    static  Opportunity oppty;
    static String key = '&key=' + Label.Google_API_Key;  
    public EmpowermentSurveyTrigger_Handler() {

    }
    @future(callOut=true)
    public static  void getGoogleMapLocation( string empowermentJson){
       
        List<Empowerment_Packet_Survey__c> lstEmpowerment = (List<Empowerment_Packet_Survey__c>)JSON.deserialize(empowermentJson,List<Empowerment_Packet_Survey__c>.class);
        string resultMap = '';
        for(Empowerment_Packet_Survey__c empObj : lstEmpowerment){
            
            if(empObj.Status__c == 'Incomplete') continue;
            empObj = updateWorship(empObj);
            empObj = getSupportMeetingFromGeoDirectory(empObj);
            oppty = [Select Email__c, Sunshine_Center_Name__c from Opportunity where Id =: empObj.Related_Opportunity__c];
            empObj.Opportunity_Email__c = oppty.Email__c;
            
            switch on oppty.Sunshine_Center_Name__c {
                when 'Willow Springs' {       // when block 1
                    empObj.Email_Body_End__c = 'Thank you for sharing your time with us at Willow Springs. ';
                    empObj.Email_Body_End__c += 'Please join our Alumni group on Facebook to stay in touch with ';
                    empObj.Email_Body_End__c +=  'all the friends you have made along the way:/n';
                    empObj.Email_Body_End__c +=  '\nhttps://www.facebook.com/willowspringsrecovery/groups/?ref=page_internal';
                }   
                when 'Chapters Capistrano' {       // when block 2
                    empObj.Email_Body_End__c = 'Thank you for sharing your time with us at Chapters Capistrano. ';
                    empObj.Email_Body_End__c += ' Please join our Alumni group on  Facebook to stay in touch with ';
                    empObj.Email_Body_End__c +=  'all the friends you have made along the way:/n';
                    empObj.Email_Body_End__c +=  '\nhttps://www.facebook.com/groups/2662149940506885/?ref=pages_profile_groups_tab&source_id=318335614892282';
                }
               
                when 'Monarch Shores' {       // default block, optional
                    empObj.Email_Body_End__c = 'Thank you for sharing your time with us at Monarch Shores. ';
                    empObj.Email_Body_End__c += 'Please join our Alumni group on Facebook to stay in touch with ';
                    empObj.Email_Body_End__c +=  'all the friends you have made along the way:</n>';
                    empObj.Email_Body_End__c +=  '\nhttps://www.facebook.com/monarchshoresrecovery/groups/?ref=page_internal';
                }
                 when else {       // default block, optional
                    empObj.Email_Body_End__c = 'Thank you for sharing your time with us at Mountain Springs Recovery. ';
                    empObj.Email_Body_End__c += 'Please join our Alumni group on Facebook to stay in touch with ';
                    empObj.Email_Body_End__c +=  'all the friends you have made along the way:</n>';
                    empObj.Email_Body_End__c +=  '\nhttps://www.facebook.com/groups/534949307260294?ref=pages_profile_groups_tab&source_id=367024773852720';
                }
            }
          
        }

        update lstEmpowerment;
          
    }

    private static Empowerment_Packet_Survey__c updateWorship(Empowerment_Packet_Survey__c empObj){

        Http http = new Http();  
        HttpRequest request = new HttpRequest();
        HTTPResponse response = new HTTPResponse();
        request.setMethod('GET');
        String address = '';
        system.debug('$$$$' + empObj.Zip_Code__c);
        String zip  = String.valueOf(Double.valueOf(empObj.Zip_Code__c).intValue());
    
        empObj.Google_Map_API_response_for_Worship__c = '';
        empObj.Google_Map_API_result_for_Worship__c  = '';
        
        if(empObj.What_Kind_of_Religious_Services__c == 'Other'){
            address = empObj.Other_Religious_Service__c + ' Worship place near ';
        }
        if(empObj.What_Kind_of_Religious_Services__c=='Islamic' && !test.isRunningTest()){
        address = 'Mosque near ';
        }
        
         if(empObj.What_Kind_of_Religious_Services__c=='Jewish' && !test.isRunningTest()){
        address = 'Synagogues near ';
        }
        
        if(empObj.What_Kind_of_Religious_Services__c!='Islamic' && empObj.What_Kind_of_Religious_Services__c!='Jewish' && empObj.What_Kind_of_Religious_Services__c!='Other')
        {
            address = empObj.What_Kind_of_Religious_Services__c + ' Church near ';
        }
        
        if(string.isNotBlank(empObj.City__c)){
            address += 'city ' +empObj.City__c;
        }
                
        if(string.isNotBlank(zip)){
            address += ' state ' + empObj.State__c + ' Zip code ' + zip;
        }
        address = EncodingUtil.urlEncode(address, 'UTF-8');
             
        string endPoint = 'https://maps.googleapis.com/maps/api/place/textsearch/json?query=' + address;
        endPoint += '&radius=40233.6';
        request.setEndpoint(endPoint + key); 
         
        string jsonbody = response.getBody();
        if(!test.isRunningTest()){
            response = http.send(request); 
            jsonbody = response.getBody();

        }
        else{
            jsonbody = '{ "html_attributions":[ ], "results":[ { "business_status":"OPERATIONAL", "formatted_address":"13845 22 Mile Rd, Shelby Charter Twp, MI 48315, United States", "name":"Macomb Christian Church", "place_id":"ChIJE-azFq3gJIgRf3iWOXBwvvA" } ], "status":"OK" }';
        }
       
        GoogleMAPAPIWrapper wrapperObj = (GoogleMAPAPIWrapper)JSON.deserialize(jsonbody, GoogleMAPAPIWrapper.class);
        string resultMap = '';
        if(wrapperObj != null && wrapperObj.status == 'OK' && wrapperObj.results.size() > 0){
           for(GoogleMAPAPIWrapper.cls_results clsReult : wrapperObj.results){
                resultMap += 'Name : ' + clsReult.Name + ' \n';
                resultMap += 'Address : ' + clsReult.formatted_address +'\n';
                resultMap += getContactDetailsFromGoogleAPI(clsReult.place_id);
              
            }
        } 
        empObj.Google_Map_API_response_for_Worship__c = address;
        
       // empObj.Google_Map_API_result_for_Worship__c='You also indicated that you are interested in attending a place of '+empObj.What_Kind_of_Religious_Services__c+' worship.\n';
        System.debug('resultMap+++'+resultMap);
        if(resultMap!=null && resultMap!=''){
       // empObj.Google_Map_API_result_for_Worship__c  +='Here are some worship place(s) in your area\n';
        empObj.Google_Map_API_result_for_Worship__c  += resultMap;
        }
        else if(resultMap==null || resultMap=='')
        empObj.Google_Map_API_result_for_Worship__c  += 'But, Unfortunately there is no religious place of such kind found in your area';
        
         
        return  empObj;

    }
    
    private static string getContactDetailsFromGoogleAPI(string placeId){
       
         string endPoint = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=' + placeId;
         endPoint += '&fields=name,website,url,formatted_phone_number' + key;
         
         Http http = new Http();  
         HttpRequest request = new HttpRequest();
         HTTPResponse response = new HTTPResponse();
         request.setMethod('GET');
         request.setEndpoint(endPoint); 
          string jsonResp = ''; 
         if(!test.isRunningTest()){
             response = http.send(request);
             jsonResp = response.getbody();
         }
         else{
             jsonResp = '{ "html_attributions" : [], "result" : { "formatted_phone_number" : "(586) 465-2828", "name" : "Central Baptist Church" }, "status" : "OK" }';
         }
       
        
         GoogleContactApiWrapper  wrapperObj = (GoogleContactApiWrapper)JSON.deserialize(jsonResp, GoogleContactApiWrapper.class);
         string phoneData = 'Contact : ' + wrapperObj.result.formatted_phone_number+'\n';
         phoneData += 'URL : ' + wrapperObj.result.url +'\n\n';
         return phoneData;
         
    }

    private static Empowerment_Packet_Survey__c getSupportMeetingFromGeoDirectory(Empowerment_Packet_Survey__c empObj){


        String zip  = String.valueOf(Double.valueOf(empObj.Zip_Code__c).intValue());
        string responseReq = 'city%20'+empObj.City__c+'%20zip%20'+zip+'&distance='+distance+'&orderby=distance&order=asc';
        List<GeoDirectoryWrapper> lstOfGeoDirectoryWrapper = getDataFromGeoDrictory(responseReq);
        string resultMap = '';
        if(string.isBlank(empObj.Support_Meetings_Interested_In__c)){
            return empObj;
        }
        List<string> lstOfMeetings = empObj.Support_Meetings_Interested_In__c.split(';');
        for(GeoDirectoryWrapper giWrapper : lstOfGeoDirectoryWrapper){

            for(string iMeeting : lstOfMeetings){
                if(!giWrapper.title.raw.contains(iMeeting)){
                    continue;
                }                       
                resultMap += '\nName : ' + giWrapper.title.raw + ' \n';
                resultMap += 'Address : ' + giWrapper.street + ', ';
                  
                resultMap += giWrapper.region + '\n';
                if(!string.isBlank(giWrapper.phone)){
                    resultMap += 'Phone : ' + giWrapper.phone + '\n';
                }
                if(!string.isBlank(giWrapper.email)){
                    resultMap += 'Email : ' + giWrapper.email + '\n';
                }
                if(!string.isBlank(giWrapper.website)){
                    resultMap += 'Website : ' + giWrapper.website + '\n';
                }
                 if(!string.isBlank(giWrapper.link)){
                    resultMap += 'Link : ' + giWrapper.link + '\n';
                }

            /*    if(!string.isBlank(giWrapper.latitude)){
                    resultMap += 'latitude : ' + giWrapper.latitude + '\n';
                }
                if(!string.isBlank(giWrapper.longitude)){
                    resultMap += 'longitude : ' + giWrapper.longitude + '\n';
                } 
                */
            }
        }
        empObj.Google_MAP_API_Response__c = responseReq;
        empObj.Google_MAP_API_Result__c = resultMap;
        return empObj;

    }

    private static  List<GeoDirectoryWrapper> getDataFromGeoDrictory(string requestStr){



        String endPoint = 'https://www.sunshinebehavioralhealth.com/dir/wp-json/geodir/v2/free?near=' + requestStr;
        system.debug(endPoint);
        HTTP h = new HTTP();
        HTTPRequest req = new HTTPRequest();
        req.setEndPoint(endpoint);
        req.setMethod('GET');
        HTTPResponse res;
       
        string jsonString ;
        if(!test.isRunningTest()){
           
           res = h.send(req);
           jsonString = res.getBody();
        }
        else{
            jsonString = '[ { "id":32063, "title":{ "raw":"Al-Anon", "rendered":"Detroit &#8211; Alcoholics Anonymous" }, "slug":"detroit-alcoholics-anonymous"}]';
        }
      
        List<GeoDirectoryWrapper> lstOfGeoDirectoryWrapper = new List<GeoDirectoryWrapper>();
        lstOfGeoDirectoryWrapper = (List<GeoDirectoryWrapper>) Json.deserialize(jsonString,List<GeoDirectoryWrapper>.class);
        return lstOfGeoDirectoryWrapper;

    }

    public class GeoDirectoryWrapper{
        
        public String slug{get;set;}
        public String zip{get;set;}
        public title title{get;set;}
        public distance distance{get;set;}
        public String street {get;set;}
        public String region {get;set;}
        public String latitude {get;set;}
        public String longitude {get;set;}
        public String phone {get;set;}
        public String email {get;set;}
        public String website {get;set;}
        public String link {get;set;}
    
    }
    public class title{
        public String rendered{get;set;}
        public String raw{get;set;}
    }
    
     public class distance{
        public String rendered{get;set;}
        public String raw{get;set;}
    }
    
    
    public class GoogleContactApiWrapper{
        public result result{get;set;}
        public String status{get;set;}
        public list<String> html_attributions{get;set;}
        
        }
    public class result{
        public String url{get;set;}
        public String name{get;set;}
        public String formatted_phone_number{get;set;}
    }

}