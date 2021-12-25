public with sharing class ResponseClass {
    public String status{get;set;}
    public Object result{get;set;}
    public String message{get;set;}
    public String debugMessage{get;set;}
    public ResponseClass(){
        
    }
    public ResponseClass(String status,Object result,String message,String debugMessage) {
        this.status = status;
        this.result = result;
        this.message = message;
        this.debugMessage = debugMessage;
    }
}