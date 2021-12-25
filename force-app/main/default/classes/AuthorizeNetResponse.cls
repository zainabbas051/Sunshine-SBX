public class AuthorizeNetResponse{
        public transactionResponse transactionResponse{get;set;}
        public messages messages{get;set;}
        public String refId{get;set;}
    public class userFields{
        public String value{get;set;}
        public String name{get;set;}
    }
    public class transactionResponse{
        public list<errors> errors{get;set;}
        public String accountType{get;set;}
        public list<userFields> userFields{get;set;}
        public String accountNumber{get;set;}
        public String transHashSha2{get;set;}
        public String testRequest{get;set;}
        public Integer SupplementalDataQualificationIndicator{get;set;}
        public String transHash{get;set;}
        public String transId{get;set;}
        public String refTransID{get;set;}
        public String cavvResultCode{get;set;}
        public String avsResultCode{get;set;}
        public String authCode{get;set;}
        public String cvvResultCode{get;set;}
        public String responseCode{get;set;}
    }
    public class messages{
        public String resultCode{get;set;}
        public list<message> message{get;set;}
    }
    public class message{
        public String text{get;set;}
        public String code{get;set;}
    }
    public class errors{
        public String errorCode{get;set;}
        public String errorText{get;set;}
    }

    public static AuthorizeNetResponse parse(String json){
        return (AuthorizeNetResponse) System.JSON.deserialize(json, AuthorizeNetResponse.class);
    }
}