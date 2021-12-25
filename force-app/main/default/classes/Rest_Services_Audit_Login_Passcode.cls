//Test Clas :: 
@RestResource(urlMapping='/audit_login_passcode/*')
global class Rest_Services_Audit_Login_Passcode {
    
    @HttpGet
    global static void getPasscode() {
        
        wrapper_data wd = new wrapper_data();
        if(RestContext.request.params.get('Integration_Support_Record_Id') != null){
            id supportId = RestContext.request.params.get('Integration_Support_Record_Id');
            KIPU_Integration_Support_Object__c kiso = [Select id, KIPU_Passcode__c from KIPU_Integration_Support_Object__c where id =: supportId];
            
            if(kiso.KIPU_Passcode__c != null){
                wd.message = 'Passcode Retrieve Successfull!!';
                wd.code = '200';
                wd.passcode = integer.valueOf(kiso.KIPU_Passcode__c); 
            }else{
                wd.message = 'Passcode Not Present!!';
                wd.code = '210';
                wd.passcode = null; 
            }
            RestContext.response.addHeader('Content-Type','application/json');
            RestContext.response.responseBody = blob.valueof(System.JSON.serialize(wd));
        }else{
            wd.message = 'Required parameter Integration_Support_Record_Id Missing!!';
            wd.code = '220';
            wd.passcode = null; 
            RestContext.response.addHeader('Content-Type','application/json');
            RestContext.response.responseBody = blob.valueof(System.JSON.serialize(wd));
        }
    }
    
    class wrapper_data {
        public String message{get;set;}
        public String code{get;set;}
        public integer passcode{get;set;}
        
        public wrapper_data(){
            
        }        
    } 
    
}