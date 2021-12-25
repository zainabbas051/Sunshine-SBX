public class GeoDirectory{
    
    public static void consumeApi(string country,string region, string city,string zipCode,string meetingName){
        
        String endPoint = 'https://www.sunshinebehavioralhealth.com/dir/wp-json/geodir/v2/free?near=city%'+city+'%20zip%20'+zipCode+'&distance=25&orderby=distance&order=asc';
        HTTP h = new HTTP();
        HTTPRequest req = new HTTPRequest();
        req.setEndPoint(endpoint);
        req.setMethod('GET');
        HTTPResponse res = h.send(req);
        string jsonString = res.getBody();
        List<GeoDirectoryWrapper> lstOfGeoDirectoryWrapper = (List<GeoDirectoryWrapper>) Json.deserialize(jsonString,List<GeoDirectoryWrapper>.class);
        for(GeoDirectoryWrapper giWrapper : lstOfGeoDirectoryWrapper){
            
              system.debug('$$$$' + giWrapper.title.rendered);
             system.debug('$$$$$' + giWrapper.zip);
            if(!giWrapper.title.rendered.contains(meetingName)){
                continue;
            }
          
            system.debug('%%%%' + giWrapper.title.rendered);
             system.debug('%%%%' + giWrapper.zip);
        }
    
    }
    
    public class GeoDirectoryWrapper{
        
        public String slug{get;set;}
        public String zip{get;set;}
        public title title{get;set;}
    
    }
    public class title{
        public String rendered{get;set;}
        public String raw{get;set;}
    }
}