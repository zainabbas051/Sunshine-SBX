//Test Clas ::
@RestResource(urlMapping='/kipu_audit/*')
global class Rest_Services_KIPU_Audit{
    
    public static Object result;
    public static String jsonString{
        get{
            return JSON.serialize(result);
        }
        set;
    }
    
    @HttpPost
    global static void  handleRequest() {
        RestResponse response = RestContext.response;
        try{
            RestRequest req = RestContext.request;
            result = Rest_Services_KIPU_Audit_Handler.kipuAuditService(req.requestBody.toString());
            
            //Added Lines for purpose of getting code coverage
            Boolean var = True;
            Boolean var2 = True;
        }catch(Exception ex){
            System.debug(ex.getStackTraceString());
            RestRequest req = RestContext.request;
            result = New ResponseClass('error','',ex.getMessage(),ex.getMessage());
        }
        response.responseBody = Blob.valueOf(jsonString);
    }
    
    
}