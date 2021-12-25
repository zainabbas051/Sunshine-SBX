public class TransactionResponseWrapper{
		public String transrefId{get;set;}
		public messages messages{get;set;}
		public transactionObj transactionObj{get;set;}
	public class transactionObj{
		public String cardCodeResponse{get;set;}
		public String AVSResponse{get;set;}
		public Decimal authAmount{get;set;}
		public String authCode{get;set;}
		public Decimal settleAmount{get;set;}
		public String responseReasonDescription{get;set;}
		public Boolean taxExempt{get;set;}
		public Integer responseReasonCode{get;set;}
		public payment payment{get;set;}
		public Integer responseCode{get;set;}
		public billTo billTo{get;set;}
		public String transactionStatus{get;set;}
		public Boolean recurringBilling{get;set;}
		public String transactionType{get;set;}
		public String customerIP{get;set;}
		public String submitTimeLocal{get;set;}
		public String product{get;set;}
		public String submitTimeUTC{get;set;}
		public String marketType{get;set;}
		public String transId{get;set;}
	}
	public class payment{
		public creditCard creditCard{get;set;}
	}
	public class messages{
		public list<message> message{get;set;}
		public String resultCode{get;set;}
	}
	public class message{
		public String code{get;set;}
		public String text{get;set;}
	}
	public class creditCard{
		public String expirationDate{get;set;}
		public String cardType{get;set;}
		public String cardNumber{get;set;}
	}
	public class billTo{
		public String firstName{get;set;}
		public String city{get;set;}
		public String state{get;set;}
		public String address{get;set;}
		public String zip{get;set;}
		public String company{get;set;}
		public String country{get;set;}
		public String lastName{get;set;}
	}
}