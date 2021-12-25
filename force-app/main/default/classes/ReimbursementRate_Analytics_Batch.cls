//Test Class : ReimbursementRate_Batches_Test
global class ReimbursementRate_Analytics_Batch implements Database.Batchable<sObject>{
    
    string query;
    
    global ReimbursementRate_Analytics_Batch(){
        query = 'select id, Alpha_Prefix_Based_Insurance__c from Account where Reimbursement_Rate_Temp_Flag__c = False AND Type = \'Insurance Provider\'';
        if(Test.isRunningTest())
            query += ' limit 200';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        system.debug('test');
        
        List<Id> accIdList = new List<Id>();
        Map<Id,Boolean> accIdAlphaPrefixMap = new Map<Id,Boolean>();
        Set<Id> accIdSet = new Set<Id>();
        List<Id> oppListId = new List<Id>();
        Map<Id,List<Case>> accountIdCaseListMap = new Map<Id,List<Case>>();
        List<Account> accUpdateList = new List<Account>();
        Map<Id,List<Alpha_Prefix_Allowable_Rates__c>> accAlphaPrefixListMap = new Map<Id,List<Alpha_Prefix_Allowable_Rates__c>>();
        List<Alpha_Prefix_Allowable_Rates__c> aprUpdateList = new List<Alpha_Prefix_Allowable_Rates__c>();
        List<Alpha_Prefix_Allowable_Rates__c> aprInsertList = new List<Alpha_Prefix_Allowable_Rates__c>();
        
        for(Account acc : (list<Account>) scope){
            accIdList.add(acc.id);
            accIdAlphaPrefixMap.put(acc.id,acc.Alpha_Prefix_Based_Insurance__c);
        }
        
        for(Alpha_Prefix_Allowable_Rates__c apr : [Select id, Related_Insurance_Account__c, Alpha_Prefix__c, CC_Detox_Allowable_Amount__c, MS_Detox_Allowable_Amount__c, WS_Detox_Allowable_Amount__c, MSR_Detox_Allowable_Amount__c, 
                                                   CC_Residential_Allowable_Amount__c, MS_Residential_Allowable_Amount__c, WS_Residential_Allowable_Amount__c, MSR_Residential_Allowable_Amount__c, CC_PHP_Allowable_Amount__c, 
                                                   MS_PHP_Allowable_Amount__c, WS_PHP_Allowable_Amount__c, MSR_PHP_Allowable_Amount__c, CC_IOP_Allowable_Amount__c, MS_IOP_Allowable_Amount__c, WS_IOP_Allowable_Amount__c, 
                                                   MSR_IOP_Allowable_Amount__c, CC_OP_Allowable_Amount__c, MS_OP_Allowable_Amount__c, WS_OP_Allowable_Amount__c, MSR_OP_Allowable_Amount__c, CC_Labs_Allowable_Amount__c, 
                                                   MS_Labs_Allowable_Amount__c, WS_Labs_Allowable_Amount__c, MSR_Labs_Allowable_Amount__c from Alpha_Prefix_Allowable_Rates__c where Related_Insurance_Account__c IN: accIdList]){
                                                   
            if(accAlphaPrefixListMap.containsKey(apr.Related_Insurance_Account__c)){
                List<Alpha_Prefix_Allowable_Rates__c> tempList = new List<Alpha_Prefix_Allowable_Rates__c>();
                tempList = accAlphaPrefixListMap.get(apr.Related_Insurance_Account__c);
                tempList.add(apr);
                accAlphaPrefixListMap.put(apr.Related_Insurance_Account__c,tempList);
            }else{
                List<Alpha_Prefix_Allowable_Rates__c> tempList = new List<Alpha_Prefix_Allowable_Rates__c>();
                tempList.add(apr);
                accAlphaPrefixListMap.put(apr.Related_Insurance_Account__c,tempList);
            }
        }
        
        
        
        for(Opportunity opp : [Select id from Opportunity where Insurance_Provider__c IN: accIdList]){
            oppListId.add(opp.id);
        }
        
        if(oppListId.size()>0){
            Date sixMonthsOldDate = date.Today().addMonths(-6);
            for(Case c : [Select id, Total_Allowable_Amount__c, Opportunity__r.Insurance_Provider__c, Opportunity__r.Insurance_Provider__r.Alpha_Prefix_Based_Insurance__c, Insurance_Information__r.Insurance_Policy__c, Sunshine_Center__c, isClosed, Level_of_Care__c from Case where Opportunity__c IN: oppListId AND Bill_From_Date__c >=: sixMonthsOldDate]){
                if(c.Opportunity__r.Insurance_Provider__c!=null){
                    if(accountIdCaseListMap.containsKey(c.Opportunity__r.Insurance_Provider__c)){
                        List<Case> tempList = new List<Case>();
                        tempList = accountIdCaseListMap.get(c.Opportunity__r.Insurance_Provider__c);
                        tempList.add(c);
                        accountIdCaseListMap.put(c.Opportunity__r.Insurance_Provider__c,tempList);
                    }else{
                        List<Case> tempList = new List<Case>();
                        tempList.add(c);
                        accountIdCaseListMap.put(c.Opportunity__r.Insurance_Provider__c,tempList);
                    }
                }
            } 
            if(accountIdCaseListMap.keySet().size()>0){
                
                for(id accId : accountIdCaseListMap.keySet()){
                    if(accIdAlphaPrefixMap.containsKey(accId)){
                        
                        if(accIdAlphaPrefixMap.get(accId)==False){//The Insurance is Not an Alpha Prefix Enabled Insurance
                            double ccDetoxAmount=0.0;
                            double ccResidentialAmount=0.0;
                            double ccPHPAmount=0.0;
                            double ccIOPAmount=0.0;
                            double ccOPAmount=0.0;
                            double ccLabsAmount=0.0;
                            
                            double msDetoxAmount=0.0;
                            double msResidentialAmount=0.0;
                            double msPHPAmount=0.0;
                            double msIOPAmount=0.0;
                            double msOPAmount=0.0;
                            double msLabsAmount=0.0;
                            
                            double wsDetoxAmount=0.0;
                            double wsResidentialAmount=0.0;
                            double wsPHPAmount=0.0;
                            double wsIOPAmount=0.0;
                            double wsOPAmount=0.0;
                            double wsLabsAmount=0.0;
                            
                            double msrDetoxAmount=0.0;
                            double msrResidentialAmount=0.0;
                            double msrPHPAmount=0.0;
                            double msrIOPAmount=0.0;
                            double msrOPAmount=0.0;
                            double msrLabsAmount=0.0;
                            
                            for(Case c : accountIdCaseListMap.get(accId)){
                                if(c.Sunshine_Center__c.contains('Chapter') && c.Total_Allowable_Amount__c != null){
                                    if(c.Level_of_Care__c == 'Detox'){
                                        ccDetoxAmount = ccDetoxAmount+c.Total_Allowable_Amount__c;
                                    }else if(c.Level_of_Care__c == 'Residential'){
                                        ccResidentialAmount = ccResidentialAmount+c.Total_Allowable_Amount__c;
                                    }else if(c.Level_of_Care__c == 'PHP'){
                                        ccPHPAmount = ccPHPAmount+c.Total_Allowable_Amount__c;
                                    }else if(c.Level_of_Care__c == 'IOP'){
                                        ccIOPAmount = ccIOPAmount+c.Total_Allowable_Amount__c;
                                    }else if(c.Level_of_Care__c == 'OP'){
                                        ccOPAmount = ccOPAmount+c.Total_Allowable_Amount__c;
                                    }else if(c.Level_of_Care__c == 'Lab Requests'){
                                        ccLabsAmount = ccLabsAmount+c.Total_Allowable_Amount__c;
                                    }
                                }
                                if(c.Sunshine_Center__c.contains('Monarch') && c.Total_Allowable_Amount__c != null){
                                    if(c.Level_of_Care__c == 'Detox'){
                                        msDetoxAmount = msDetoxAmount+c.Total_Allowable_Amount__c;
                                    }else if(c.Level_of_Care__c == 'Residential'){
                                        msResidentialAmount = msResidentialAmount+c.Total_Allowable_Amount__c;
                                    }else if(c.Level_of_Care__c == 'PHP'){
                                        msPHPAmount = msPHPAmount+c.Total_Allowable_Amount__c;
                                    }else if(c.Level_of_Care__c == 'IOP'){
                                        msIOPAmount = msIOPAmount+c.Total_Allowable_Amount__c;
                                    }else if(c.Level_of_Care__c == 'OP'){
                                        msOPAmount = msOPAmount+c.Total_Allowable_Amount__c;
                                    }else if(c.Level_of_Care__c == 'Lab Requests'){
                                        msLabsAmount = msLabsAmount+c.Total_Allowable_Amount__c;
                                    }
                                }
                                if(c.Sunshine_Center__c.contains('Willow') && c.Total_Allowable_Amount__c != null){
                                    if(c.Level_of_Care__c == 'Detox'){
                                        wsDetoxAmount = wsDetoxAmount+c.Total_Allowable_Amount__c;
                                    }else if(c.Level_of_Care__c == 'Residential'){
                                        wsResidentialAmount = wsResidentialAmount+c.Total_Allowable_Amount__c;
                                    }else if(c.Level_of_Care__c == 'PHP'){
                                        wsPHPAmount = wsPHPAmount+c.Total_Allowable_Amount__c;
                                    }else if(c.Level_of_Care__c == 'IOP'){
                                        wsIOPAmount = wsIOPAmount+c.Total_Allowable_Amount__c;
                                    }else if(c.Level_of_Care__c == 'OP'){
                                        wsOPAmount = wsOPAmount+c.Total_Allowable_Amount__c;
                                    }else if(c.Level_of_Care__c == 'Lab Requests'){
                                        wsLabsAmount = wsLabsAmount+c.Total_Allowable_Amount__c;
                                    }
                                }
                                if(c.Sunshine_Center__c.contains('Mountain') && c.Total_Allowable_Amount__c != null){
                                    if(c.Level_of_Care__c == 'Detox'){
                                        msrDetoxAmount = msrDetoxAmount+c.Total_Allowable_Amount__c;
                                    }else if(c.Level_of_Care__c == 'Residential'){
                                        msrResidentialAmount = msrResidentialAmount+c.Total_Allowable_Amount__c;
                                    }else if(c.Level_of_Care__c == 'PHP'){
                                        msrPHPAmount = msrPHPAmount+c.Total_Allowable_Amount__c;
                                    }else if(c.Level_of_Care__c == 'IOP'){
                                        msrIOPAmount = msrIOPAmount+c.Total_Allowable_Amount__c;
                                    }else if(c.Level_of_Care__c == 'OP'){
                                        msrOPAmount = msrOPAmount+c.Total_Allowable_Amount__c;
                                    }else if(c.Level_of_Care__c == 'Lab Requests'){
                                        msrLabsAmount = msrLabsAmount+c.Total_Allowable_Amount__c;
                                    }
                                }             
                            }
                            
                            if(accAlphaPrefixListMap.containsKey(accId)){
                                for(Alpha_Prefix_Allowable_Rates__c apr : accAlphaPrefixListMap.get(accId)){
                                    apr.CC_Detox_Allowable_Amount__c = ccDetoxAmount;
                                    apr.MS_Detox_Allowable_Amount__c = msDetoxAmount;
                                    apr.WS_Detox_Allowable_Amount__c = wsDetoxAmount;
                                    apr.MSR_Detox_Allowable_Amount__c = msrDetoxAmount;
                                    
                                    apr.CC_Residential_Allowable_Amount__c = ccResidentialAmount;
                                    apr.MS_Residential_Allowable_Amount__c = msResidentialAmount;
                                    apr.WS_Residential_Allowable_Amount__c = wsResidentialAmount;
                                    apr.MSR_Residential_Allowable_Amount__c = msrResidentialAmount;
                                    
                                    apr.CC_PHP_Allowable_Amount__c = ccPHPAmount;
                                    apr.MS_PHP_Allowable_Amount__c = msPHPAmount;
                                    apr.WS_PHP_Allowable_Amount__c = wsPHPAmount;
                                    apr.MSR_PHP_Allowable_Amount__c = msrPHPAmount;
                                    
                                    apr.CC_IOP_Allowable_Amount__c = ccIOPAmount;
                                    apr.MS_IOP_Allowable_Amount__c = msIOPAmount;
                                    apr.WS_IOP_Allowable_Amount__c = wsIOPAmount;
                                    apr.MSR_IOP_Allowable_Amount__c = msrIOPAmount;
                                    
                                    apr.CC_OP_Allowable_Amount__c = ccOPAmount;
                                    apr.MS_OP_Allowable_Amount__c = msOPAmount;
                                    apr.WS_OP_Allowable_Amount__c = wsOPAmount;
                                    apr.MSR_OP_Allowable_Amount__c = msrOPAmount;
                                    
                                    apr.CC_Labs_Allowable_Amount__c = ccLabsAmount;
                                    apr.MS_Labs_Allowable_Amount__c = msLabsAmount;
                                    apr.WS_Labs_Allowable_Amount__c = wsLabsAmount;
                                    apr.MSR_Labs_Allowable_Amount__c = msrLabsAmount;
                                    
                                    aprUpdateList.add(apr);
                                }
                            }else{
                                Alpha_Prefix_Allowable_Rates__c apr = new Alpha_Prefix_Allowable_Rates__c();
                                apr.Related_Insurance_Account__c= accId;
                                
                                apr.CC_Detox_Allowable_Amount__c = ccDetoxAmount;
                                apr.MS_Detox_Allowable_Amount__c = msDetoxAmount;
                                apr.WS_Detox_Allowable_Amount__c = wsDetoxAmount;
                                apr.MSR_Detox_Allowable_Amount__c = msrDetoxAmount;
                                
                                apr.CC_Residential_Allowable_Amount__c = ccResidentialAmount;
                                apr.MS_Residential_Allowable_Amount__c = msResidentialAmount;
                                apr.WS_Residential_Allowable_Amount__c = wsResidentialAmount;
                                apr.MSR_Residential_Allowable_Amount__c = msrResidentialAmount;
                                
                                apr.CC_PHP_Allowable_Amount__c = ccPHPAmount;
                                apr.MS_PHP_Allowable_Amount__c = msPHPAmount;
                                apr.WS_PHP_Allowable_Amount__c = wsPHPAmount;
                                apr.MSR_PHP_Allowable_Amount__c = msrPHPAmount;
                                
                                apr.CC_IOP_Allowable_Amount__c = ccIOPAmount;
                                apr.MS_IOP_Allowable_Amount__c = msIOPAmount;
                                apr.WS_IOP_Allowable_Amount__c = wsIOPAmount;
                                apr.MSR_IOP_Allowable_Amount__c = msrIOPAmount;
                                
                                apr.CC_OP_Allowable_Amount__c = ccOPAmount;
                                apr.MS_OP_Allowable_Amount__c = msOPAmount;
                                apr.WS_OP_Allowable_Amount__c = wsOPAmount;
                                apr.MSR_OP_Allowable_Amount__c = msrOPAmount;
                                
                                apr.CC_Labs_Allowable_Amount__c = ccLabsAmount;
                                apr.MS_Labs_Allowable_Amount__c = msLabsAmount;
                                apr.WS_Labs_Allowable_Amount__c = wsLabsAmount;
                                apr.MSR_Labs_Allowable_Amount__c = msrLabsAmount;
                                
                                aprInsertList.add(apr);
                            }
                            
                            
                        }else{//The Insurance is an Alpha Prefix Enabled Insurance
                            Map<String,List<Case>> alphaPrefixCaseListMap = new Map<String,List<Case>>();
                            
                            for(Case c : accountIdCaseListMap.get(accId)){
                                if(c.Insurance_Information__r.Insurance_Policy__c != null){
                                    if(alphaPrefixCaseListMap.containsKey(c.Insurance_Information__r.Insurance_Policy__c.substring(0,2))){
                                        List<Case> tempList = new List<Case>();
                                        tempList = alphaPrefixCaseListMap.get(c.Insurance_Information__r.Insurance_Policy__c.substring(0,2));
                                        tempList.add(c);
                                        alphaPrefixCaseListMap.put(c.Insurance_Information__r.Insurance_Policy__c.substring(0,2),tempList);
                                    }else{
                                        List<Case> tempList = new List<Case>();
                                        tempList.add(c);
                                        alphaPrefixCaseListMap.put(c.Insurance_Information__r.Insurance_Policy__c.substring(0,2),tempList);
                                    }
                                }
                            }
                            if(alphaPrefixCaseListMap.keySet().isEmpty() == False){
                                for(String alphaPrefix : alphaPrefixCaseListMap.KeySet()){
                                    double ccDetoxAmount=0.0;
                                    double ccResidentialAmount=0.0;
                                    double ccPHPAmount=0.0;
                                    double ccIOPAmount=0.0;
                                    double ccOPAmount=0.0;
                                    double ccLabsAmount=0.0;
                                    
                                    double msDetoxAmount=0.0;
                                    double msResidentialAmount=0.0;
                                    double msPHPAmount=0.0;
                                    double msIOPAmount=0.0;
                                    double msOPAmount=0.0;
                                    double msLabsAmount=0.0;
                                    
                                    double wsDetoxAmount=0.0;
                                    double wsResidentialAmount=0.0;
                                    double wsPHPAmount=0.0;
                                    double wsIOPAmount=0.0;
                                    double wsOPAmount=0.0;
                                    double wsLabsAmount=0.0;
                                    
                                    double msrDetoxAmount=0.0;
                                    double msrResidentialAmount=0.0;
                                    double msrPHPAmount=0.0;
                                    double msrIOPAmount=0.0;
                                    double msrOPAmount=0.0;
                                    double msrLabsAmount=0.0;
                                    for(Case c : alphaPrefixCaseListMap.get(alphaPrefix)){
                                        if(c.Sunshine_Center__c.contains('Chapter') && c.Total_Allowable_Amount__c != null){
                                            if(c.Level_of_Care__c == 'Detox'){
                                                ccDetoxAmount = ccDetoxAmount+c.Total_Allowable_Amount__c;
                                            }else if(c.Level_of_Care__c == 'Residential'){
                                                ccResidentialAmount = ccResidentialAmount+c.Total_Allowable_Amount__c;
                                            }else if(c.Level_of_Care__c == 'PHP'){
                                                ccPHPAmount = ccPHPAmount+c.Total_Allowable_Amount__c;
                                            }else if(c.Level_of_Care__c == 'IOP'){
                                                ccIOPAmount = ccIOPAmount+c.Total_Allowable_Amount__c;
                                            }else if(c.Level_of_Care__c == 'OP'){
                                                ccOPAmount = ccOPAmount+c.Total_Allowable_Amount__c;
                                            }else if(c.Level_of_Care__c == 'Lab Requests'){
                                                ccLabsAmount = ccLabsAmount+c.Total_Allowable_Amount__c;
                                            }
                                        }
                                        if(c.Sunshine_Center__c.contains('Monarch') && c.Total_Allowable_Amount__c != null){
                                            if(c.Level_of_Care__c == 'Detox'){
                                                msDetoxAmount = msDetoxAmount+c.Total_Allowable_Amount__c;
                                            }else if(c.Level_of_Care__c == 'Residential'){
                                                msResidentialAmount = msResidentialAmount+c.Total_Allowable_Amount__c;
                                            }else if(c.Level_of_Care__c == 'PHP'){
                                                msPHPAmount = msPHPAmount+c.Total_Allowable_Amount__c;
                                            }else if(c.Level_of_Care__c == 'IOP'){
                                                msIOPAmount = msIOPAmount+c.Total_Allowable_Amount__c;
                                            }else if(c.Level_of_Care__c == 'OP'){
                                                msOPAmount = msOPAmount+c.Total_Allowable_Amount__c;
                                            }else if(c.Level_of_Care__c == 'Lab Requests'){
                                                msLabsAmount = msLabsAmount+c.Total_Allowable_Amount__c;
                                            }
                                        }
                                        if(c.Sunshine_Center__c.contains('Willow') && c.Total_Allowable_Amount__c != null){
                                            if(c.Level_of_Care__c == 'Detox'){
                                                wsDetoxAmount = wsDetoxAmount+c.Total_Allowable_Amount__c;
                                            }else if(c.Level_of_Care__c == 'Residential'){
                                                wsResidentialAmount = wsResidentialAmount+c.Total_Allowable_Amount__c;
                                            }else if(c.Level_of_Care__c == 'PHP'){
                                                wsPHPAmount = wsPHPAmount+c.Total_Allowable_Amount__c;
                                            }else if(c.Level_of_Care__c == 'IOP'){
                                                wsIOPAmount = wsIOPAmount+c.Total_Allowable_Amount__c;
                                            }else if(c.Level_of_Care__c == 'OP'){
                                                wsOPAmount = wsOPAmount+c.Total_Allowable_Amount__c;
                                            }else if(c.Level_of_Care__c == 'Lab Requests'){
                                                wsLabsAmount = wsLabsAmount+c.Total_Allowable_Amount__c;
                                            }
                                        }
                                        if(c.Sunshine_Center__c.contains('Mountain') && c.Total_Allowable_Amount__c != null){
                                            if(c.Level_of_Care__c == 'Detox'){
                                                msrDetoxAmount = msrDetoxAmount+c.Total_Allowable_Amount__c;
                                            }else if(c.Level_of_Care__c == 'Residential'){
                                                msrResidentialAmount = msrResidentialAmount+c.Total_Allowable_Amount__c;
                                            }else if(c.Level_of_Care__c == 'PHP'){
                                                msrPHPAmount = msrPHPAmount+c.Total_Allowable_Amount__c;
                                            }else if(c.Level_of_Care__c == 'IOP'){
                                                msrIOPAmount = msrIOPAmount+c.Total_Allowable_Amount__c;
                                            }else if(c.Level_of_Care__c == 'OP'){
                                                msrOPAmount = msrOPAmount+c.Total_Allowable_Amount__c;
                                            }else if(c.Level_of_Care__c == 'Lab Requests'){
                                                msrLabsAmount = msrLabsAmount+c.Total_Allowable_Amount__c;
                                            }
                                        }
                                    }
                                    if(accAlphaPrefixListMap.containsKey(accId)){
                                        Boolean flag = False;
                                        for(Alpha_Prefix_Allowable_Rates__c apr : accAlphaPrefixListMap.get(accId)){
                                            if(apr.Alpha_Prefix__c == alphaPrefix){
                                                flag = True;
                                                apr.CC_Detox_Allowable_Amount__c = ccDetoxAmount;
                                                apr.MS_Detox_Allowable_Amount__c = msDetoxAmount;
                                                apr.WS_Detox_Allowable_Amount__c = wsDetoxAmount;
                                                apr.MSR_Detox_Allowable_Amount__c = msrDetoxAmount;
                                                
                                                apr.CC_Residential_Allowable_Amount__c = ccResidentialAmount;
                                                apr.MS_Residential_Allowable_Amount__c = msResidentialAmount;
                                                apr.WS_Residential_Allowable_Amount__c = wsResidentialAmount;
                                                apr.MSR_Residential_Allowable_Amount__c = msrResidentialAmount;
                                                
                                                apr.CC_PHP_Allowable_Amount__c = ccPHPAmount;
                                                apr.MS_PHP_Allowable_Amount__c = msPHPAmount;
                                                apr.WS_PHP_Allowable_Amount__c = wsPHPAmount;
                                                apr.MSR_PHP_Allowable_Amount__c = msrPHPAmount;
                                                
                                                apr.CC_IOP_Allowable_Amount__c = ccIOPAmount;
                                                apr.MS_IOP_Allowable_Amount__c = msIOPAmount;
                                                apr.WS_IOP_Allowable_Amount__c = wsIOPAmount;
                                                apr.MSR_IOP_Allowable_Amount__c = msrIOPAmount;
                                                
                                                apr.CC_OP_Allowable_Amount__c = ccOPAmount;
                                                apr.MS_OP_Allowable_Amount__c = msOPAmount;
                                                apr.WS_OP_Allowable_Amount__c = wsOPAmount;
                                                apr.MSR_OP_Allowable_Amount__c = msrOPAmount;
                                                
                                                apr.CC_Labs_Allowable_Amount__c = ccLabsAmount;
                                                apr.MS_Labs_Allowable_Amount__c = msLabsAmount;
                                                apr.WS_Labs_Allowable_Amount__c = wsLabsAmount;
                                                apr.MSR_Labs_Allowable_Amount__c = msrLabsAmount;
                                                
                                                aprUpdateList.add(apr);
                                            }
                                        }
                                        if(flag==false){
                                            Alpha_Prefix_Allowable_Rates__c apr = new Alpha_Prefix_Allowable_Rates__c();
                                            apr.Related_Insurance_Account__c= accId;
                                            apr.Alpha_Prefix__c = alphaPrefix;
                                            
                                            apr.CC_Detox_Allowable_Amount__c = ccDetoxAmount;
                                                apr.MS_Detox_Allowable_Amount__c = msDetoxAmount;
                                                apr.WS_Detox_Allowable_Amount__c = wsDetoxAmount;
                                                apr.MSR_Detox_Allowable_Amount__c = msrDetoxAmount;
                                                
                                                apr.CC_Residential_Allowable_Amount__c = ccResidentialAmount;
                                                apr.MS_Residential_Allowable_Amount__c = msResidentialAmount;
                                                apr.WS_Residential_Allowable_Amount__c = wsResidentialAmount;
                                                apr.MSR_Residential_Allowable_Amount__c = msrResidentialAmount;
                                                
                                                apr.CC_PHP_Allowable_Amount__c = ccPHPAmount;
                                                apr.MS_PHP_Allowable_Amount__c = msPHPAmount;
                                                apr.WS_PHP_Allowable_Amount__c = wsPHPAmount;
                                                apr.MSR_PHP_Allowable_Amount__c = msrPHPAmount;
                                                
                                                apr.CC_IOP_Allowable_Amount__c = ccIOPAmount;
                                                apr.MS_IOP_Allowable_Amount__c = msIOPAmount;
                                                apr.WS_IOP_Allowable_Amount__c = wsIOPAmount;
                                                apr.MSR_IOP_Allowable_Amount__c = msrIOPAmount;
                                                
                                                apr.CC_OP_Allowable_Amount__c = ccOPAmount;
                                                apr.MS_OP_Allowable_Amount__c = msOPAmount;
                                                apr.WS_OP_Allowable_Amount__c = wsOPAmount;
                                                apr.MSR_OP_Allowable_Amount__c = msrOPAmount;
                                                
                                                apr.CC_Labs_Allowable_Amount__c = ccLabsAmount;
                                                apr.MS_Labs_Allowable_Amount__c = msLabsAmount;
                                                apr.WS_Labs_Allowable_Amount__c = wsLabsAmount;
                                                apr.MSR_Labs_Allowable_Amount__c = msrLabsAmount;
                                                
                                                aprInsertList.add(apr);
                                        }
                                    }else{
                                        Alpha_Prefix_Allowable_Rates__c apr = new Alpha_Prefix_Allowable_Rates__c();
                                        apr.Related_Insurance_Account__c= accId;
                                        apr.Alpha_Prefix__c = alphaPrefix;
                                        
                                        apr.CC_Detox_Allowable_Amount__c = ccDetoxAmount;
                                        apr.MS_Detox_Allowable_Amount__c = msDetoxAmount;
                                        apr.WS_Detox_Allowable_Amount__c = wsDetoxAmount;
                                        apr.MSR_Detox_Allowable_Amount__c = msrDetoxAmount;
                                        
                                        apr.CC_Residential_Allowable_Amount__c = ccResidentialAmount;
                                        apr.MS_Residential_Allowable_Amount__c = msResidentialAmount;
                                        apr.WS_Residential_Allowable_Amount__c = wsResidentialAmount;
                                        apr.MSR_Residential_Allowable_Amount__c = msrResidentialAmount;
                                        
                                        apr.CC_PHP_Allowable_Amount__c = ccPHPAmount;
                                        apr.MS_PHP_Allowable_Amount__c = msPHPAmount;
                                        apr.WS_PHP_Allowable_Amount__c = wsPHPAmount;
                                        apr.MSR_PHP_Allowable_Amount__c = msrPHPAmount;
                                        
                                        apr.CC_IOP_Allowable_Amount__c = ccIOPAmount;
                                        apr.MS_IOP_Allowable_Amount__c = msIOPAmount;
                                        apr.WS_IOP_Allowable_Amount__c = wsIOPAmount;
                                        apr.MSR_IOP_Allowable_Amount__c = msrIOPAmount;
                                        
                                        apr.CC_OP_Allowable_Amount__c = ccOPAmount;
                                        apr.MS_OP_Allowable_Amount__c = msOPAmount;
                                        apr.WS_OP_Allowable_Amount__c = wsOPAmount;
                                        apr.MSR_OP_Allowable_Amount__c = msrOPAmount;
                                        
                                        apr.CC_Labs_Allowable_Amount__c = ccLabsAmount;
                                        apr.MS_Labs_Allowable_Amount__c = msLabsAmount;
                                        apr.WS_Labs_Allowable_Amount__c = wsLabsAmount;
                                        apr.MSR_Labs_Allowable_Amount__c = msrLabsAmount;
                                        
                                        aprInsertList.add(apr);
                                    }
                                }
                            }
                            
                        }
                    }
                        
                    Account acc = new Account(id=accId, Reimbursement_Rate_Temp_Flag__c = True);
                    accUpdateList.add(acc); 
                    accIdSet.add(acc.id);
                
                }
            }
        }
        
        for(Id accId : accIdList){
            if(!accIdSet.contains(accId)){
                Account acc = new Account(id=accId, Reimbursement_Rate_Temp_Flag__c = True);
                accUpdateList.add(acc); 
            }
        }
        if(accUpdateList.size()>0)
            update accUpdateList;
        
        if(aprInsertList.isEmpty()==False)
            insert aprInsertList;
            
        if(aprUpdateList.isEmpty()==False)
            update aprUpdateList;
    
    }
    
    global void finish(Database.BatchableContext BC){
        ReimbursementRate_Analytics_HelperBatch b = new ReimbursementRate_Analytics_HelperBatch();
        database.executebatch(b,200);
    }
}