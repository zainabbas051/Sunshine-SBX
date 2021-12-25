public without sharing class PaymentCollection_Cntr {
    public PaymentCollection_Cntr() {

    }

    public static map<string, Card_Information__c> mapOfCards = new map<string, Card_Information__c>();

    @AuraEnabled
    public static string returnPaymentData(string OppId){
        
        try {
            Decimal totalAmt = 0.0;
            PaymentWrapper pwrap = new PaymentWrapper();
            
            for(Payment_Plan_Line_Items__c ppli : getPaymentLineItem(OppId)){
                totalAmt += ppli.Amount_For_Collection__c;
                pwrap.ClientName = ppli.Payment_Plan__r.Opportunity__r.Name;
            }
            List<Card_Information__c> cards = getCardInfoList(OppId);
            list<CardWrapper> ListOfCards = new list<CardWrapper>();
            if(cards != null && cards.size() > 0)
            {
                for(Card_Information__c cr : cards)
                {
                    CardWrapper cw = new CardWrapper();
                    cw.CardHolderName = cr.Name_On_Card__c;
                    cw.CardNumber = cr.Card_Number__c;
                    cw.ExpMonth = integer.valueOf(cr.Expiration_Month__c);
                    if(!string.isBlank(cr.Expiration_Year__c) && cr.Expiration_Year__c.length() == 2)
                    {
                        cw.ExpYear = Integer.valueOf('20'+cr.Expiration_Year__c);
                    }
                    cw.CVV = string.valueOf(cr.CVV__c);

                    ListOfCards.add(cw);
                }
            }
            
            pwrap.TotalAmount = totalAmt;
            pwrap.ListCards = ListOfCards;
            string JsonStr = JSON.serialize(pwrap);
            return JsonStr;

            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string returnSelectedCard(string cardNum, string OppId)
    {
        CardWrapper cw = new CardWrapper();
        string jsonString = '';

        map<string,Card_Information__c> mapOfAllCards = returnCardsMap(OppId);

        if(mapOfAllCards.containsKey(cardNum))
        {
            Card_Information__c card = mapOfAllCards.get(cardNum);
            cw.CardHolderName = card.Name_On_Card__c;
            cw.CardNumber = cardNum;
            cw.ExpMonth = integer.valueOf(card.Expiration_Month__c);
            if(!string.isBlank(card.Expiration_Year__c) && card.Expiration_Year__c.length() == 2)
            {
                cw.ExpYear = Integer.valueOf('20'+card.Expiration_Year__c);
            }
            cw.CVV = string.valueOf(card.CVV__c);
            jsonString = JSON.serialize(cw);
        }
        return jsonString;
    }

    public static List<Payment_Plan_Line_Items__c> getPaymentLineItem(string OppId){

        
        List<Payment_Plan_Line_Items__c> ppLineItem = [Select Name,Payment_Plan__c,Payment_Plan__r.Name,Due_Date__c,Sunshine_Center__c,
                                                        Amount_For_Collection__c,Status__c,Closed_Date__c ,
                                                        Payment_Receipt_URL__c, Date_of_Cash_Collection__c,
                                                        Payment_Plan__r.Opportunity__c, Payment_Plan__r.Opportunity__r.Name
                                                        FROM 
                                                        Payment_Plan_Line_Items__c WHERE 
                                                        Type_of_Collection__c = 'Housing' and Opportunity__c =: OppId and 
                                                        (Status__c ='Open' OR Status__c ='Card Declined')];
        
       
        return ppLineItem;
    }



    public static List<Card_Information__c> getCardInfoList(string OppId){
    
        mapOfCards = new map<string,Card_Information__c>();

        List<Card_Information__c> cl=[select id,Card_Number__c, 
                                        Name_on_Card__c, CVV__c, 
                                        Expiration_Month__c, 
                                        Expiration_Year__c 
                                        from Card_Information__c 
                                        where Payment_Plan__r.Opportunity__c =:OppId];
        for(Card_Information__c cr: cl)
        {
            mapOfCards.put(cr.Card_Number__c,cr);
        }
        return cl;
        
    }
    
    public static map<string,Card_Information__c> returnCardsMap(string OppId){
    
        map<string,Card_Information__c> mapOfAllCards = new map<string,Card_Information__c>();

        List<Card_Information__c> cl=[select id,Card_Number__c, 
                                        Name_on_Card__c, CVV__c, 
                                        Expiration_Month__c, 
                                        Expiration_Year__c 
                                        from Card_Information__c 
                                        where Payment_Plan__r.Opportunity__c =:OppId];
        for(Card_Information__c cr: cl)
        {
            mapOfAllCards.put(cr.Card_Number__c,cr);
        }
        return mapOfAllCards;
        
    }


    public class PaymentWrapper{

        @AuraEnabled
        public string ClientName {get; set;}
        @AuraEnabled
        public decimal TotalAmount {get; set;}
        @AuraEnabled
        public string CardHolderName {get; set;}
        @AuraEnabled
        public string CardNumber {get; set;}
        @AuraEnabled
        public integer ExpMonth {get; set;}
        @AuraEnabled
        public integer ExpYear {get; set;}
        @AuraEnabled
        public string CVV {get; set;}
        @AuraEnabled
        public list<CardWrapper> ListCards {get; set;}

    }

    public class CardWrapper
    {
        @AuraEnabled
        public string CardHolderName {get; set;}
        @AuraEnabled
        public string CardNumber {get; set;}
        @AuraEnabled
        public integer ExpMonth {get; set;}
        @AuraEnabled
        public integer ExpYear {get; set;}
        @AuraEnabled
        public string CVV {get; set;}
    }
}