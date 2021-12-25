@RestResource(urlMapping='/relapsed/*')
global class Relapsed_Rest {

    @HttpGet
    global static void checkRelapsed(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Map<string,string> mapOfRequest = new Map<string,string>();
        
        try{
            if(!RestContext.request.headers.containsKey('id')){
                mapOfRequest.put('success','false');
                mapOfRequest.put('message','In Valid Request');
                res.responseBody = Blob.valueOf(System.JSON.serialize(mapOfRequest));
                res.statusCode = 500;
                return;
            }
            
            mapOfRequest = new Map<string,string>();
            mapOfRequest.put('success','true');
            mapOfRequest.put('message','Saved Successfully');
            res.responseBody = Blob.valueOf(System.JSON.serialize(mapOfRequest));
            res.statusCode = 200;
            return;
        }
        catch(Exception ex){
            mapOfRequest = new Map<string,string>();
            mapOfRequest.put('success','false');
            mapOfRequest.put('message',ex.getMessage() + ' ' + ex.getLineNumber());
            res.responseBody = Blob.valueOf(System.JSON.serialize(mapOfRequest));
            res.statusCode = 500;
        }
    }
}