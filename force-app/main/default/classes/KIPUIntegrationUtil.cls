public class KIPUIntegrationUtil{
    
    public static string getAuthorization(string sunshineCenterName, string contentType, string contentMD5, string apiURI, string dt){
        
        Sunshine_Center_Id__c SC = Sunshine_Center_Id__c.getValues(sunshineCenterName);
        
        string kipu_sandboxAccessID  = SC.KIPU_Access_ID__c;
        string kipu_salesforceAccessID = SC.SFDC_API_ID__c;
       
        system.debug('kipu_sandboxAccessID ::::'+kipu_sandboxAccessID );
        system.debug('kipu_salesforceAccessID ::::'+kipu_salesforceAccessID );
        
        
        //apiURI = apiURI+kipu_sandboxAccessID ;
        
        string canonicalString = contentType+','+contentMD5+','+apiURI+','+dt+' GMT';
        system.debug('canonicalString :::'+canonicalString);
        
        String key = SC.Secret_Key__c;
        
        Blob data = crypto.generateMac('hmacSHA1',Blob.valueOf(canonicalString), Blob.valueOf(key));
        
        string signature = EncodingUtil.base64Encode(data);//base64
        system.debug('signature ::::'+signature);
        
        string authorization = 'APIAuth '+kipu_salesforceAccessID+':'+signature;
        system.debug('authorization ::::'+authorization);
        
        return authorization;
        
    }
    
    public static HttpResponse callKIPUAPI(string apiURi, string contentType , string JSONString , string sunshinecenter, string method  ){
        
        string dt = datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss');               
        
        string contentMD5 ='';
        if(JSONString !=null && JSONString !=''){
            Blob requestBlob = Blob.valueOf(JSONString );
            Blob hash = Crypto.generateDigest('MD5', requestBlob);
            
            contentMD5 = EncodingUtil.base64Encode(hash );
        }
        system.debug(contentMD5 +' :MD5');
        string authorization = KIPUIntegrationUtil.getAuthorization(sunshinecenter, contentType  , contentMD5 ,apiURi  , dt);
        
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        req.setHeader('Authorization',authorization);
        
        if(method == 'POST'){
            req.setHeader('Content-Type',contentType );//Not Required for GET
            req.setHeader('Content_MD5',contentMD5 );//Not Required for GET
        }
        req.setHeader('Date',dt+' GMT');
        req.setHeader('Accept','application/vnd.kipusystems+json; version=1');
        req.setMethod(method  );
        req.setEndpoint('https://kipuapi.kipuworks.com'+apiURi ); 
    
        if(method == 'POST')
            req.setBody (JSONString );
        
        system.debug('request Authorization Header ::::'+req.getheader('Authorization'));
        system.debug('request Date Header ::::'+req.getheader('Date'));
        system.debug('request Accept Header ::::'+req.getheader('Accept'));
        system.debug('request ::::'+req);
        system.debug('request Body ::::'+req.getBody());
        if(!Test.isRunningTest()){
            HTTPResponse res = http.send(req);
            System.debug('MYDEBUG: RESPONSE STRING: ' + res.toString());
            System.debug('MYDEBUG: RESPONSE STATUS: '+res.getStatus());
            System.debug('MYDEBUG: STATUS_CODE:'+res.getStatusCode());
            System.debug('MYDEBUG: BODY:'+res.getBody());
            return res ;
        }
        return null;
    }
}