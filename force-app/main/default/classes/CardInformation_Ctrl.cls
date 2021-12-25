public Inherited sharing class CardInformation_Ctrl {

 @AuraEnabled 
    public static string fetchUser(){
       User u = [select id,Name from User where id =: userInfo.getUserId()];
        return u.Name;
    }
    
    @AuraEnabled 
    public static void saveCardInformation(Card_Information__c cardObj){
      cardObj.Payment_Plan__c = 'a0E3C000008T50vUAC';
      insert cardObj;
    }
    }