@isTest
global class HTTPMockCallout implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        string jsonResBody = '{ "label": "Spring \'17",  "url": "/services/data/v39.0","version": "39.0"}';
        res.setBody(jsonResBody);
        res.setStatusCode(200);
        return res;
    }
}