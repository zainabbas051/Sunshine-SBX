public without sharing class Ctrl_AlumniApp_DailyContent {
public awsBucket__c bucket {get;set;} //Bucket permission set

@AuraEnabled
    public static List<Alumni_App_Daily_Content__c> GetSuccessStories(){
    
    List<Alumni_App_Daily_Content__c> lstSuccessStoriest= new  List<Alumni_App_Daily_Content__c>();
    lstSuccessStoriest= [select Name,Author__c,Type__c,CreatedDate from Alumni_App_Daily_Content__c where Type__c='Success Stories'  order by CreatedDate desc limit 20 ];
    
    return lstSuccessStoriest;
       
       
    } 
    

   @AuraEnabled
    public static List<Alumni_App_Challenges_Configurations__c> GetChallengesConfig(){
    
    List<Alumni_App_Challenges_Configurations__c> lstChallenges= new  List<Alumni_App_Challenges_Configurations__c>();
    lstChallenges= [select Id,Name,Participant__c,Type__c,Streak_Duration__c,CreatedDate from Alumni_App_Challenges_Configurations__c order by CreatedDate ];
    
    return lstChallenges;
       
       
    } 
   
     @AuraEnabled
    public static List<Alumni_App_Daily_Content__c> GetMotivationalQoutes(){
    
    List<Alumni_App_Daily_Content__c> lstSuccessStoriest= new  List<Alumni_App_Daily_Content__c>();
    lstSuccessStoriest= [select Name,Author__c,Type__c,CreatedDate from Alumni_App_Daily_Content__c  where Type__c='Motivational Quotes' order by CreatedDate desc limit 20 ];
    
    return lstSuccessStoriest;
       
       
    } 
    
     @AuraEnabled
    public static List<Alumni_App_Daily_Content__c> GetClinicalQoutes(){
    
    List<Alumni_App_Daily_Content__c> lstSuccessStoriest= new  List<Alumni_App_Daily_Content__c>();
    lstSuccessStoriest= [select Name,Author__c,Type__c,CreatedDate from Alumni_App_Daily_Content__c  where Type__c NOT IN ('Motivational Quotes','Success Stories') order by CreatedDate desc limit 20 ];
    
    return lstSuccessStoriest;
       
       
    }
     @AuraEnabled
    public static awsBucket__c getAWSSetting(){
        return awsBucket__c.getInstance('salesforce');
    }
    
   /* @AuraEnabled
    public static String uploadFileToAWS(
                                        String strfileName, String fileType,
                                        String fileContent){
        //System.debug('parentId=' + parentId);
        System.debug('strfileName=' + strfileName);
        System.debug('fileType=' + fileType);
        HttpRequest req = new HttpRequest();

        Blob base64Content = EncodingUtil.base64Decode(EncodingUtil.urlDecode(fileContent, 'UTF-8'));
        String attachmentBody =  fileContent;           
        String formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
        String dateString = Datetime.now().format('ddMMYYYYHHmmss');        
        String filename = dateString + '_' + strfileName;
        
         awsBucket__c bucket = new awsBucket__c();
         bucket = awsBucket__c.getInstance('AllumniApp');
        //AWS specific information
        String key = bucket.accessKeyId__c; //AWS key
        String secret = bucket.secretAccessKey__c; //AWS Secret key
        String bucketname = bucket.Bucket__c; //AWS bucket name
        String host = 's3.amazonaws.com'; //'s3.amazonaws.com:443'
       // host = 's3.us-east-2.amazonaws.com';
       
        String method = 'PUT';
       // String endPoint = 'https://' + bucketname + '.' + host +'/'+label.Production_or_Sanbox +'/' + filename;
       // String endPoint = 'http://revenuecollections.s3.amazonaws.com/Sandbox/Willow%20Springs/' + filename;
        String endPoint = 'https://' + bucketname + '.' + host +'/' + filename;
        req.setMethod(method);
        req.setEndpoint(endPoint);

        system.debug('Endpoint='+endPoint);
        //create header information
        req.setHeader('Host', bucketname + '.' + host);
        req.setHeader('Access-Control-Allow-Origin', '*');
        req.setHeader('Content-Length', String.valueOf(attachmentBody.length()));
        req.setHeader('Content-Encoding', 'UTF-8');
        req.setHeader('Content-type', fileType);
        req.setHeader('Connection', 'keep-alive');
        req.setHeader('Date', formattedDateString); 
        req.setHeader('ACL', 'public-read-write');
        //store file as blob       
        req.setBodyAsBlob(base64Content);
        
        //prepare for signing information
        String stringToSign = 'PUT\n\n' +
        fileType + '\n' +
        formattedDateString + '\n' + '/' + bucketname + '/' + filename;

        String encodedStringToSign = EncodingUtil.urlEncode(stringToSign, 'UTF-8');
        Blob mac = Crypto.generateMac('HMACSHA1', blob.valueof(stringToSign),blob.valueof(secret));
        String signedKey  = EncodingUtil.base64Encode(mac);

        //assign Authorization information
        String authHeader = 'AWS' + ' ' + key + ':' + signedKey;                    
        req.setHeader('Authorization',authHeader);

        //finally send information to AWS        
        Http http = new Http();
        HTTPResponse res = http.send(req);

        System.debug('*Resp:' + String.ValueOF(res.getBody()));
        System.debug('RESPONSE STRING: ' + res.toString());
        System.debug('RESPONSE STATUS: ' + res.getStatus());
        System.debug('STATUS_CODE: ' + res.getStatusCode());

        if(res.getStatusCode() == 200){
           // insertAttachmentRecord (parentId,strfileName,endPoint);
            return endpoint;
        }
        return '';
    }
    
  */  
   
}