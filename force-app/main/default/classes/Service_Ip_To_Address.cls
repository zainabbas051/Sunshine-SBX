//Test Class : Service_Ip_To_AddressTest
global class Service_Ip_To_Address{
    
    public static String recrdId;
    public static Lead leadRecord;
    
    @future (callout=true)
    Webservice static void ipToAdressAPICall(String ipAdress, ID recordID){
        if(ipAdress != null && ipAdress != ''){
            
            String zip_code='';
            String state='';
            String city='';
            String endPointURL='';
            String query = 'SELECT Id, IP_Address_Integration_Message__c, Zip_Code__c, State__c, City__c FROM Lead WHERE Id=:recordID';
            
            System.debug('Query ::::::::::::::'+ query);
            leadRecord = Database.Query(query);
            
            endPointURL = 'http://ipinfo.io/'+ipAdress+'/json';
            system.debug('end point url:::'+endPointURL);
            
            HttpRequest req = new HttpRequest();
            req.setMethod('GET');
            req.setEndpoint(endPointURL);
            req.setTimeout(120000);
            
            System.debug('req :::::' +req);
            leadRecord.IP_Address_Integration_Message__c= leadRecord.IP_Address_Integration_Message__c+'\n\n'+DateTime.Now()+'--'+req; 
            
            Http http = new Http();
            HTTPResponse res;
            try{
                if(!Test.IsRunningTest()){
                    res = http.send(req);
                }else{
                    res = new HTTPResponse();
                    res.setBody('{"ip": "68.34.253.80","hostname": "c-68-34-253-80.hsd1.mi.comcast.net","city": "Charter Township of Clinton","region": "Michigan","country": "US","loc": "42.5991,-82.9312","org": "AS7922 Comcast Cable Communications, LLC","postal": "48038"}');
                    res.setStatusCode(200);
                }
            }catch(Exception e){
                system.debug('Exception caught ::'+e.getMessage());
                leadRecord.IP_Address_Integration_Message__c= leadRecord.IP_Address_Integration_Message__c+'\n\n Error :'+e.getMessage();
                update leadRecord;
                return;
            }
            
            system.debug('Response Code ::'+res.getStatusCode());
            system.debug('Response Body ::'+res.getBody());
            
            if(res != NULL && res.getStatusCode() == 200){
                leadRecord.IP_Address_Integration_Message__c= leadRecord.IP_Address_Integration_Message__c+'\n\n Response :'+res.getBody();
                response_wrapper rw = (response_wrapper)JSON.deserializeStrict(res.getBody(),response_wrapper.class);
                zip_code = rw.postal;
                state=rw.region;
                city=rw.city;
            }else{
                 leadRecord.IP_Address_Integration_Message__c= leadRecord.IP_Address_Integration_Message__c+'\n\n Response :'+res.getBody()+'\n\n response code :'+res.getStatusCode();
            }
            
            system.debug('zip code :'+zip_code); 
            if(zip_code != null && zip_code !='')
                leadRecord.Zip_Code__c = zip_code;
            if(leadRecord.State__c == null && state!=null && state!='')
                leadRecord.State__c = state;
            if(leadRecord.City__c== null && city!=null && city!='')
                leadRecord.City__c= state; 
            update leadRecord;   
                
        }
    }
    public class response_wrapper{
        public String ip;
        public String hostname;
        public String city;
        public String region;
        public String country;
        public String loc;
        public String org;
        public String postal;      
        
           
        public response_wrapper(String ip, String hostname, String city, String region, String country, String loc, String org, String postal) {
            this.ip = ip;
            this.hostname= hostname;
            this.city = city;
            this.region = region;
            this.country = country;
            this.loc = loc;
            this.org = org;
            this.postal = postal;
        }        
    }
}