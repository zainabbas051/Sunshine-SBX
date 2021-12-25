@IsTest
public class AlumniApp_ChangePasswordTest{

    
    @testSetup
    static void setup() {
        
        Alumni_App_Detail__c app = new Alumni_App_Detail__c();
        app.Username__c = 'test@test.com';
        app.Password__c = '123';
        app.User_Email__c = 'test@test.com';
        insert app;
    
    }
    
    @IsTest
    static void testGetDetail() {
        
        test.startTest();
        
        Alumni_App_Detail__c app = [Select Id,User_Email__c,Password__c
                                     from Alumni_App_Detail__c limit 1];
        AlumniApp_ChangePassword.EmaiWrapper emailWrapper = new AlumniApp_ChangePassword.EmaiWrapper();
        emailWrapper.email = app.User_Email__c;
        emailWrapper.newPassword = '123';
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueof(JSON.serialize(emailWrapper));
        RestContext.request = request;
        RestContext.response = response;
        Test.setMock(HttpCalloutMock.class, new MockAlumniAppResponse());
        AlumniApp_ChangePassword.changePassword();
        test.stopTest();
    }
    
     @IsTest
    static void testGetNegative() {
        
        test.startTest();
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        RestContext.request = request;
        RestContext.response = response;
        //Test.setMock(HttpCalloutMock.class, new MockAlumniAppResponse());
        AlumniApp_ChangePassword.changePassword();
        test.stopTest();
    }
    
    public class MockAlumniAppResponse implements HttpCalloutMock {
         
       
         public HTTPResponse respond(HTTPRequest req) {

            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"success":true,"isEditable":false,"inTake":true,"days_sober":166,"app_detail_Id":"a373C000000CZMjQAO"}');
            res.setStatusCode(200);
            return res;
        }
    }
}