public class PaymentAuthorization{

        string refID;
        string cardNumber;
        string monthYear;
        decimal cvcNumber;
        decimal amount;
        string sunshinecenter;
        string firstName;
        string lastName;
        string billingAddress;
        string billingCity;
        string billingState;
        string billingZip;
        string billingCountry;
        public string jsonReq;
        public string transID;
         public string jsonReq_TransactionDetail;
        static AdminApiSettings__mdt apiSetting ;
        
        public string GetPaymentAuthorization(){
        
                string nameCredentialType = (sunshinecenter == 'Willowsprings Recovery') ? 'callout:WillowSpring_CreditCard_Payment' : (sunshinecenter == 'Chapters Capistrano') ? 'callout:Chapter_CreditCardPayment' : (sunshinecenter == 'Mountain Springs Recovery') ? 'callout:MountainSpringsRecovery_CreditCardPayment' : 'callout:MonarchShores_Credit_Card_Payment';
                HttpRequest req = new HttpRequest();
                req.setEndpoint(nameCredentialType);
                req.setMethod('POST');
                req.SETBody(jsonReq);
                 Http http = new Http();
                HTTPResponse res;
                string responseText;
                if(test.isRunningTest() == false){
                    res= http.send(req);
                    responseText = res.getBody();
                }
                else
                    responseText = '{"transactionResponse":{"responseCode":"1","authCode":"BU4YS5","avsResultCode":"Y","cvvResultCode":"P","cavvResultCode":"2","transId":"40044648740","refTransID":"","transHash":"","testRequest":"0","accountNumber":"XXXX0015","accountType":"MasterCard","messages":[{"code":"1","description":"This transaction has been approved."}],"transHashSha2":"","SupplementalDataQualificationIndicator":0},"refId":"a0C3C00000543YqUAI","messages":{"resultCode":"Ok","message":[{"code":"I00001","text":"Successful."}]}}';
              
               
                responseText = responseText.trim().replace('\uFEFF', '');
                System.debug(responseText);
                return responseText;
        }
        
        
 
       
       public PaymentAuthorization(string aRefId,Card_Information__c ci,decimal aamount,string aSunshinecenter){
            
          
            refID=aRefId;
            cardNumber = ci.Card_Number__c;
            String str = ci.Expiration_Year__c;
            if(str.length()==2){
            str='20'+ci.Expiration_Year__c;
            }
            monthYear = str+'-'+ci.Expiration_Month__c;
            cvcNumber = ci.CVV__c;
            firstName=ci.Name_on_Card__c;
            lastName=ci.Name_on_Card__c;
            billingAddress=ci.Billing_Address__c;
            billingCity=ci.Billing_City__c;
            billingState=ci.Billing_State__c;
            billingZip=ci.Billing_Zip__c;
            
            amount = aamount;
            
            sunshinecenter= aSunshinecenter;
            jsonReq = CreateJSON();
            
        }
    
     
        public PaymentAuthorization(string aSunshinecenter,string aTransId){
    
            sunshinecenter= aSunshinecenter;
            transID=aTransId;
            jsonReq_TransactionDetail = CreateJSON_TransactionDetail();
            
        }
        
        
        
       public string getTransactionDetail(){
            
    
                string nameCredentialType = (sunshinecenter == 'Willowsprings Recovery') ? 'callout:WillowSpring_CreditCard_Payment' : (sunshinecenter == 'Chapters Capistrano') ? 'callout:Chapter_CreditCardPayment' : (sunshinecenter == 'Mountain Springs Recovery') ? 'callout:MountainSpringsRecovery_CreditCardPayment': 'callout:MonarchShores_Credit_Card_Payment';
                HttpRequest req = new HttpRequest();
                req.setEndpoint(nameCredentialType);
                req.setMethod('POST');
                req.SETBody(jsonReq_TransactionDetail);  
                Http http = new Http();
                HTTPResponse res;
                string responseText;
                if(test.isRunningTest() == false){
                    res= http.send(req);
                    responseText = res.getBody();
                }
                else
                    responseText = '{"transaction":{"responseCode":"1","authCode":"BU4YS5","avsResultCode":"Y","cvvResultCode":"P","cavvResultCode":"2","transId":"40044648740","refTransID":"","transHash":"","testRequest":"0","accountNumber":"XXXX0015","accountType":"MasterCard","messages":[{"code":"1","description":"This transaction has been approved."}],"transHashSha2":"","SupplementalDataQualificationIndicator":0},"refId":"a0C3C00000543YqUAI","messages":{"resultCode":"Ok","message":[{"code":"I00001","text":"Successful."}]}}';
              
                

                
                responseText = responseText.trim().replace('\uFEFF', '');
                System.debug(responseText);
                return responseText;
            
        }
        
        string CreateJSON(){
            
                
              //  AuthorizeNetJsonRequest jsonRequest = new AuthorizeNetJsonRequest();
                
                if(apiSetting  == null){
                             if(sunshinecenter == null || sunshinecenter == '') sunshinecenter = 'Willowsprings Recovery';
                             apiSetting = [Select API_Login_ID__c,Key__c,Transaction_KEY__c FROM
                                                        
                                                        AdminApiSettings__mdt where Label =: sunshinecenter ];
                }
                   
             
             /*   
            AuthorizeNetJsonRequest.createTransactionRequest jsonRequest = new AuthorizeNetJsonRequest.createTransactionRequest();
            jsonRequest.refId = refID;
            jsonRequest.transactionRequest  = new AuthorizeNetJsonRequest.transactionRequest();
            jsonRequest.merchantAuthentication  = new AuthorizeNetJsonRequest.merchantAuthentication();
            
            jsonRequest.merchantAuthentication.transactionKey = apiSetting.API_Login_ID__c;
            jsonRequest.merchantAuthentication.name = apiSetting.API_Login_ID__c;
            
            
            
            jsonRequest.transactionRequest.transactionType = 'authCaptureTransaction';
            jsonRequest.transactionRequest.amount = string.valueOf(amount);
            jsonRequest.transactionRequest.payment = new AuthorizeNetJsonRequest.payment();
            jsonRequest.transactionRequest.payment.creditCard = new AuthorizeNetJsonRequest.creditCard();
            jsonRequest.transactionRequest.payment.creditCard.cardNumber = cardNumber;
            jsonRequest.transactionRequest.payment.creditCard.expirationDate = monthYear;
            jsonRequest.transactionRequest.payment.creditCard.cardCode = string.valueOf(cvcNumber);
            
         
            jsonRequest.transactionRequest.billTo = new AuthorizeNetJsonRequest.BillTo();
            jsonRequest.transactionRequest.billTo.firstName = 'Ellen';
            jsonRequest.transactionRequest.billTo.lastName = 'Johnson';
            jsonRequest.transactionRequest.billTo.company = 'Souveniropolis';
            jsonRequest.transactionRequest.billTo.address = '14 Main Street';
            jsonRequest.transactionRequest.billTo.city = 'Pecan Springs';
            jsonRequest.transactionRequest.billTo.state = 'TX';
            jsonRequest.transactionRequest.billTo.zip = '44628';
            jsonRequest.transactionRequest.billTo.country = 'USA';
            
            
            string json = JSON.serialize(jsonRequest);
            system.debug('GGGGGjson' + json );
            return json;
            */
           
           String cvcNum_str = String.valueOf(cvcNumber); 
           if(cardNumber.length() == 16){
               cvcNum_str =   cvcNum_str.leftPad(3, '0'); 
           }
           if(cardNumber.length() == 15){
               cvcNum_str =   cvcNum_str.leftPad(4, '0'); 
           }    
        
            
            String json=        '{'+
        '    "createTransactionRequest": {'+
        '        "merchantAuthentication": {'+
        '            "name": "'+apiSetting.API_Login_ID__c+'",'+
        '            "transactionKey": "'+apiSetting.Transaction_KEY__c+'",'+
        '        },'+
        '        "refId": "'+refID+'",'+
        '        "transactionRequest": {'+
        '            "transactionType": "'+Label.AuthorizeNet_TransactionType+'",'+
        '            "amount": "'+amount+'",'+
        '            "payment": {'+
        '                "creditCard": {'+
        '                    "cardNumber": "'+cardNumber+'",'+
        '                    "expirationDate": "'+monthYear+'",'+
        '                    "cardCode": "'+cvcNum_str +'"'+
        '                }'+
        '            },"transactionSettings": { "setting": { "settingName": "duplicateWindow", "settingValue": "0.1" } }'+              
        '        } '+
        '    }'+
        '}';
        
        system.debug('===>' + json);
        return json;
                
          
        }
        
        
        
        
        string CreateJSON_TransactionDetail(){
            
                
                if(apiSetting  == null){
                             if(sunshinecenter == null || sunshinecenter == '') sunshinecenter = 'Willowsprings Recovery';
                             apiSetting = [Select API_Login_ID__c,Key__c,Transaction_KEY__c FROM
                                                        
                                                        AdminApiSettings__mdt where Label =: sunshinecenter ];
                }
                   
             
             
          
            String json=        '{'+
        '    "getTransactionDetailsRequest": {'+
        '        "merchantAuthentication": {'+
        '            "name": "'+apiSetting.API_Login_ID__c+'",'+
        '            "transactionKey": "'+apiSetting.Transaction_KEY__c+'",'+
        '        },'+
        '        "transId": "'+transID+'"'+
        '    }'+
        '}';   
            
        
        return json;
                
       
               
                
            
        }
    }