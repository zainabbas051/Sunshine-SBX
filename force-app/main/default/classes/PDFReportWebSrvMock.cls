@isTest
global class PDFReportWebSrvMock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req){
    HttpResponse res = new HttpResponse();
    res.setStatus('OK');
    res.setStatusCode(200);
    res.setBody('{"Request_ID":151}');
    return res;
  }
}