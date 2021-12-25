@IsTest
public class AlumniAppUpdate_RestTest{

    
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
        
        Alumni_App_Detail__c app = [Select Id from Alumni_App_Detail__c limit 1];
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.httpMethod = 'GET';
        request.addHeader('Content-Type', 'application/json');
        request.addHeader('id', string.valueOf(app.Id));
        RestContext.request = request;
        RestContext.response = response;
        Test.setMock(HttpCalloutMock.class, new MockAlumniAppResponse());
        AlumniAppUpdate_Rest.getLogin();
        test.stopTest();
    }
    
     @IsTest
    static void testGetNegative() {
        
        test.startTest();
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.httpMethod = 'GET';
        request.addHeader('Content-Type', 'application/json');
        RestContext.request = request;
        RestContext.response = response;
        Test.setMock(HttpCalloutMock.class, new MockAlumniAppResponse());
        AlumniAppUpdate_Rest.getLogin();
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

    public static testMethod void  Test1() {
        
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/GetUser';
        req.addParameter('id','001');
        req.httpMethod = 'Get';
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        AlumniAppUpdate_Rest.getLogin();
        Test.stopTest();
    }

    public static testMethod void  Test2() {
        
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/GetUser';
        req.httpMethod = 'Get';
        req.addHeader('id','001');
        req.addHeader('Content-Type', 'application/json'); 
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        AlumniAppUpdate_Rest.getLogin();
        Test.stopTest();
    }
    
}