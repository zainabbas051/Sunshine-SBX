public with sharing class AlumniAppDetail_NotificationUtil {
    
    private static string authorizationKey = '';
    final static string AUTHORINZATION = 'Authorization';
    final static string CONTENT_TYPE = 'Content-Type';
    static {
        authorizationKey = string.format('key={0}',new List<string> { Label.AlumniApp_Notification_Key});
    }

     /**
    * @description: Send the notification device Ids
    * @params List<string> deviceIds
    * @params string notifcationTitle
    * @params string notificationBody
    * @return Status Code
    */
    public static integer sendNotification(List<string> deviceIds,string notifcationTitle,string notificationBody){

        Map<String, String> headerMap = new Map<String, String>();
        headerMap.put(AUTHORINZATION, authorizationKey);   
        headerMap.put(CONTENT_TYPE, 'application/json');   
        string jsonBody = generateNotificationBody(deviceIds,notifcationTitle,notificationBody);
        HttpRequest httpReq = prepareHttpRequest(headerMap,jsonBody);
        Http httpObj = new Http();
        HttpResponse httpResp =  httpObj.send(httpReq);
        system.debug(httpResp.getBody());
        return httpResp.getStatusCode();
    }

    private static HttpRequest prepareHttpRequest(Map<String, String> headerMap,string jsonBody){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Alumni_App_Notification');
        req.setMethod('POST');
        req.setBody(jsonBody);
        req = setRequestHeaders(req, headerMap);
        return req;
       
    }

    private static string generateNotificationBody(List<string> deviceIds,string notifcationTitle,string notificationBody){

        NotificationBody notficationBody = new NotificationBody();
        notficationBody.registration_ids = deviceIds;
        notficationBody.notification = new cls_notification();
        notficationBody.notification.body = notificationBody;
        notficationBody.notification.title = notifcationTitle;
        return JSON.serialize(notficationBody);
    }

     /**
    * @description: Prepare the Http request Header
    * @params HttpRequest Request 
    * @params headerMap header configuration related to each country
    * @return HttpRequest
    */
    private static HttpRequest setRequestHeaders(HttpRequest req, Map<String, String> headerMap) {
        for (String key : headerMap.keySet()) {
            req.setHeader(key, headerMap.get(key));
        }
        return req;
    }

    public class NotificationBody{

        public List<string> registration_ids;
        public cls_Notification notification;
    }
    
    class cls_notification {
        public String body;	//Body of Your Notification
        public String title;	//Title of Your Notification
    }
}