public class AuthorizeNetJsonRequest {
    
    public createTransactionRequest createTransactionRequestObj{get;set;}
    public class userFields{
        public list<userField> userField{get;set;}
    }
    public class userField{
        public String value{get;set;}
        public String name{get;set;}
    }
    public class transactionSettings{
        public setting setting{get;set;}
    }
    public class transactionRequest{
       // public String poNumber{get;set;}
       // public duty duty{get;set;}
       // public tax tax{get;set;}
        //public shipping shipping{get;set;}
        public billTo billTo{get;set;}
        //public customer customer{get;set;}
        //public shipTo shipTo{get;set;}
        //public lineItems lineItems{get;set;}
        //public String customerIP{get;set;}
        public payment payment{get;set;}
        //public transactionSettings transactionSettings{get;set;}
        public String amount{get;set;}
        //public userFields userFields{get;set;}
        public String transactionType{get;set;}
    }
    public class tax{
        public String description{get;set;}
        public String name{get;set;}
        public String amount{get;set;}
    }
    public class shipTo{
        public String lastName{get;set;}
        public String city{get;set;}
        public String state{get;set;}
        public String address{get;set;}
        public String zip{get;set;}
        public String company{get;set;}
        public String country{get;set;}
        public String firstName{get;set;}
    }
    public class shipping{
        public String description{get;set;}
        public String amount{get;set;}
        public String name{get;set;}
    }
    public class setting{
        public String settingValue{get;set;}
        public String settingName{get;set;}
    }
    public class payment{
        public creditCard creditCard{get;set;}
    }
    public class merchantAuthentication{
        public String transactionKey{get;set;}
        public String name{get;set;}
    }
    public class lineItems{
        public lineItem lineItem{get;set;}
    }
    public class lineItem{
        public String unitPrice{get;set;}
        public String description{get;set;}
        public String quantity{get;set;}
        public String name{get;set;}
        public String itemId{get;set;}
    }
    public class duty{
        public String amount{get;set;}
        public String description{get;set;}
        public String name{get;set;}
    }
    public class customer{
        public String id{get;set;}
    }
    public class creditCard{
        public String expirationDate{get;set;}
        public String cardNumber{get;set;}
        public String cardCode{get;set;}
    }
    public class createTransactionRequest{
        public String refId{get;set;}
        public transactionRequest transactionRequest{get;set;}
        public merchantAuthentication merchantAuthentication{get;set;}
    }
    public class billTo{
        public String company{get;set;}
        public String city{get;set;}
        public String state{get;set;}
        public String address{get;set;}
        public String zip{get;set;}
        public String lastName{get;set;}
        public String country{get;set;}
        public String firstName{get;set;}
    }
}