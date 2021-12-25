//Test Class : monthlyCommissionsCalculatorERPTest
Public without sharing class monthlyCommissionsCalculatorERP{
    
    public monthlyCommissionsCalculatorERP(){
    
    }
    
    public static void commissionCalculator(){
        
        Map<Integer,String> monthMap = new Map<Integer,String>();
        monthMap.put(1,'January');
        monthMap.put(2,'February');
        monthMap.put(3,'March');
        monthMap.put(4,'April');
        monthMap.put(5,'May');
        monthMap.put(6,'June');
        monthMap.put(7,'July');
        monthMap.put(8,'August');
        monthMap.put(9,'September');
        monthMap.put(10,'October');
        monthMap.put(11,'November');
        monthMap.put(12,'December');
        
        List<Monthly_Commisions__c> deleteList = new List<Monthly_Commisions__c>();
        List<Monthly_Commisions__c> insertList = new List<Monthly_Commisions__c>();
        String previousMonth='';
        String currentMonth='';
        Integer previousYear;
        Integer currentYear;
        
        
        
        if(date.today().month()!=1){
            previousMonth = monthMap.get(date.today().addMonths(-1).month());
            currentMonth = monthMap.get(date.Today().month());
            previousYear = date.today().year();
            currentYear = date.today().year();
            
        }else{
            previousMonth = monthMap.get(12);
            currentMonth=monthMap.get(1);
            previousYear = date.today().addYears(-1).year();
            currentYear = date.today().year();
           
        }
        For(Monthly_Commisions__c mc : [Select id, Month__c, Year__c, Total_Number_of_Rescued_Opportunities__c,
                                        Total_Rescued_Commision__c, Type_of_User__c, User__c 
                                        from Monthly_Commisions__c
                                        where (Month__c =: previousMonth AND Year__c =: string.valueOf(previousYear)) OR (Month__c =: currentMonth AND Year__c =: string.valueOf(currentYear))]){
            deleteList.add(mc);//We delete all present records for the current and previous month before a fresh calculation is created
                                           
        }
        
        
        Date queryStartDate;
        Date queryEndDate;
        
        if(date.today().month()!=1){
            queryStartDate = date.newInstance(date.today().year(),date.today().addMonths(-1).month(),1);
            queryEndDate = date.newInstance(date.today().year(),date.today().month(),date.daysInMonth(date.today().year(),date.today().month()));
        }else{
            queryStartDate = date.newInstance(date.today().addYears(-1).year(),12,1);
            queryEndDate = date.newInstance(date.today().year(),1,31);
        }
        
        system.debug('queryStartDate ::::'+queryStartDate);
        system.debug('queryEndDate ::::'+queryEndDate);
        
        Map<Id,Monthly_Commisions__c> currentMonthCommissionCSRMap = new Map<Id,Monthly_Commisions__c>();
        Map<Id,Monthly_Commisions__c> currentMonthCommissionSCMap = new Map<Id,Monthly_Commisions__c>();
        Map<Id,Monthly_Commisions__c> previousMonthCommissionCSRMap = new Map<Id,Monthly_Commisions__c>();
        Map<Id,Monthly_Commisions__c> previousMonthCommissionSCMap = new Map<Id,Monthly_Commisions__c>();
        List<Opportunity> oppList = new List<Opportunity>();
        Set<id> profileIdList = new Set<Id>();
        Map<Id,String> profileIdNameMap = new Map<Id,String>();
        
        List<Opportunity> previousMonthOpps = new List<Opportunity>();
        List<Opportunity> currentMonthOpps = new List<Opportunity>();
        
        for(Opportunity opp : [select id, CloseDate, OwnerId, Opening_Agent__c, Opening_Agent__r.ProfileId, Personal_Referral_Commissions__c, Rescued_Commission__c, Repeat_Business_Commissions__c, 
                               Referral_Agent__c, Referral_Agent__r.ProfileId, Referral_Verified__c, Commission_Tier__c, Commission_Reduced__c,LeadSource, Smile_and_Dial__c from Opportunity where CloseDate >=: queryStartDate AND CloseDate <=: queryEndDate AND StageName=:'Rescued']){
            oppList.add(opp);
            profileIdList.add(opp.Referral_Agent__r.ProfileId);
            profileIdList.add(opp.Opening_Agent__r.ProfileId);
            if(opp.CloseDate.month()==date.Today().month()){
                currentMonthOpps.add(opp);
            }else{
                previousMonthOpps.add(opp);
            }
        }
        
        if(profileIdList.size()!=null){
            for(Profile p : [Select id, Name from Profile where Id IN: profileIdList])
                profileIdNameMap.put(p.id,p.name);
        }
        
        system.debug('todaye month :::'+date.Today().month());
        system.debug('current month opp list :::'+currentMonthOpps.size());
        system.debug('previous month opp list :::'+previousMonthOpps.size());
        system.debug('oppList size:::'+oppList.Size());
        
        
        
        if(currentMonthOpps.size()>=139){
            for(Monthly_Commissiona_Management_Users__c mcmu : Monthly_Commissiona_Management_Users__c.getall().values()){
                Monthly_Commisions__c mc = new Monthly_Commisions__c(Type_of_User__c = 'Management User',User__c = mcmu.User_Id__c,Month__c = monthMap.get(queryEndDate.month()),
                                                                 Year__c = String.valueOf(queryEndDate.year()),Total_Rescued_Commision__c = 1000, Reduced_Commission__c=0,
                                                                 Tier_1_Personal_Referral__c=0,Tier_2_Personal_Referral__c=0,Tier_1_Repeat_Business__c=0,Total_Number_of_Rescued_Opportunities__c = currentMonthOpps.size(),
                                                                 Tier_2_Repeat_Business__c=0, Tier_1_Rescued__c=0,Tier_2_Rescued__c=0, Total_Number_of_Smile_and_Dial_Opps__c=0);
                insertList.add(mc);
            }
            
        }
        
        if(previousMonthOpps.size()>=139){
            for(Monthly_Commissiona_Management_Users__c mcmu : Monthly_Commissiona_Management_Users__c.getall().values()){
                Monthly_Commisions__c mc = new Monthly_Commisions__c(Type_of_User__c = 'Management User',User__c = mcmu.User_Id__c,Month__c = monthMap.get(queryStartDate.month()),
                                                                 Year__c = String.valueOf(queryStartDate.year()),Total_Rescued_Commision__c = 1000, Reduced_Commission__c=0,
                                                                 Tier_1_Personal_Referral__c=0,Tier_2_Personal_Referral__c=0,Tier_1_Repeat_Business__c=0,Total_Number_of_Rescued_Opportunities__c = previousMonthOpps.size(),
                                                                 Tier_2_Repeat_Business__c=0, Tier_1_Rescued__c=0,Tier_2_Rescued__c=0, Total_Number_of_Smile_and_Dial_Opps__c=0);
                insertList.add(mc);
            }
            
        }
        
        Map<Id,List<Opportunity>> scRescuedMap = new Map<Id,List<Opportunity>>();
        Map<Id,List<Opportunity>> csrRescuedMap = new Map<Id,List<Opportunity>>();
        
        for(Opportunity opp : currentMonthOpps){
            if(scRescuedMap.containsKey(opp.OwnerId)){
                List<Opportunity> tempList = new List<Opportunity>();
                tempList = scRescuedMap.get(opp.OwnerId);
                tempList.add(opp);
                scRescuedMap.put(opp.OwnerId,tempList);
            }else{
                List<Opportunity> tempList = new List<Opportunity>();
                tempList.add(opp);
                scRescuedMap.put(opp.OwnerId,tempList);
            }
            if(opp.Opening_Agent__c != null && (profileIdNameMap.get(opp.Opening_Agent__r.ProfileId)=='Custom - CSR' || profileIdNameMap.get(opp.Opening_Agent__r.ProfileId)=='Custom - Quality Control')){
                if(csrRescuedMap.containsKey(opp.Opening_Agent__c)){
                    List<Opportunity> tempList = new List<Opportunity>();
                    tempList = csrRescuedMap.get(opp.Opening_Agent__c );
                    tempList.add(opp);
                    csrRescuedMap.put(opp.Opening_Agent__c ,tempList);
                }else{
                    List<Opportunity> tempList = new List<Opportunity>();
                    tempList.add(opp);
                    csrRescuedMap.put(opp.Opening_Agent__c ,tempList);
                }
            }
        }
        
        for(Id userId : scRescuedMap.keyset()){
            system.debug('oppId ::: '+userId +' ::: list size ::::'+scRescuedMap.get(userId ).size());
            Monthly_Commisions__c mc = new Monthly_Commisions__c(Type_of_User__c = 'Senior Counselor',User__c = userId ,Month__c = monthMap.get(queryEndDate.month()),
                                                                 Year__c = String.valueOf(queryEndDate.year()),Total_Rescued_Commision__c = 0, Reduced_Commission__c=0,
                                                                 Tier_1_Personal_Referral__c=0,Tier_2_Personal_Referral__c=0,Tier_1_Repeat_Business__c=0,
                                                                 Tier_2_Repeat_Business__c=0, Tier_1_Rescued__c=0,Tier_2_Rescued__c=0,Total_Number_of_Smile_and_Dial_Opps__c=0);
            for(Opportunity opp : scRescuedMap.get(userId )){
                mc.Total_Rescued_Commision__c = mc.Total_Rescued_Commision__c + opp.Rescued_Commission__c;
                if(opp.Commission_Tier__c == 'Tier 1')
                    mc.Tier_1_Rescued__c = mc.Tier_1_Rescued__c+1;
                if(opp.Commission_Tier__c == 'Tier 2')
                    mc.Tier_2_Rescued__c = mc.Tier_2_Rescued__c+1;
                if(opp.Commission_Reduced__c == True)
                    mc.Reduced_Commission__c = mc.Reduced_Commission__c+1;
            }
            currentMonthCommissionSCMap.put(userId ,mc);
        } 
        
        system.debug('currentMonthCommissionSCMap ::'+currentMonthCommissionSCMap);
        for(Id userId : csrRescuedMap.keyset()){
            system.debug('oppId ::: '+userId +' ::: list size ::::'+csrRescuedMap.get(userId ).size());
            Monthly_Commisions__c mc = new Monthly_Commisions__c(Type_of_User__c = 'CSR',User__c = userId ,Month__c = monthMap.get(queryEndDate.month()),
                                                                 Year__c = String.valueOf(queryEndDate.year()),Total_Rescued_Commision__c = 0,
                                                                 Tier_1_Personal_Referral__c=0,Tier_2_Personal_Referral__c=0,Tier_1_Repeat_Business__c=0,
                                                                 Tier_2_Repeat_Business__c=0, Tier_1_Rescued__c=0,Tier_2_Rescued__c=0,Total_Number_of_Smile_and_Dial_Opps__c=0);
            for(Opportunity opp : csrRescuedMap.get(userId )){
                mc.Total_Rescued_Commision__c = mc.Total_Rescued_Commision__c + opp.Rescued_Commission__c;
                if(opp.Commission_Tier__c == 'Tier 1')
                    mc.Tier_1_Rescued__c = mc.Tier_1_Rescued__c+1;
                if(opp.Commission_Tier__c == 'Tier 2')
                    mc.Tier_2_Rescued__c = mc.Tier_2_Rescued__c+1;
                if(opp.Smile_and_Dial__c == True)
                    mc.Total_Number_of_Smile_and_Dial_Opps__c = mc.Total_Number_of_Smile_and_Dial_Opps__c +1;
                
                if((mc.Tier_1_Rescued__c + mc.Tier_2_Rescued__c) <=9)
                    mc.Total_Rescued_Commision__c = (mc.Tier_1_Rescued__c + mc.Tier_2_Rescued__c)*50;
                else if((mc.Tier_1_Rescued__c + mc.Tier_2_Rescued__c) >9 && (mc.Tier_1_Rescued__c + mc.Tier_2_Rescued__c) <=14)
                    mc.Total_Rescued_Commision__c = (mc.Tier_1_Rescued__c + mc.Tier_2_Rescued__c)*100;
                else
                    mc.Total_Rescued_Commision__c = (mc.Tier_1_Rescued__c + mc.Tier_2_Rescued__c)*150;
                
                if(mc.Total_Number_of_Smile_and_Dial_Opps__c > 0)
                    mc.Total_Rescued_Commision__c = mc.Total_Rescued_Commision__c + (mc.Total_Number_of_Smile_and_Dial_Opps__c * 500);
            }
            currentMonthCommissionCSRMap.put(userId ,mc);
        }
        system.debug('currentMonthCommissionCSRMap ::'+currentMonthCommissionCSRMap);
        
        
        Map<Id,List<Opportunity>> scRescuedPreviousMap = new Map<Id,List<Opportunity>>();
        Map<Id,List<Opportunity>> csrRescuedPreviousMap = new Map<Id,List<Opportunity>>();
        
        for(Opportunity opp : previousMonthOpps){
            if(scRescuedPreviousMap.containsKey(opp.OwnerId)){
                List<Opportunity> tempList = new List<Opportunity>();
                tempList = scRescuedPreviousMap.get(opp.OwnerId);
                tempList.add(opp);
                scRescuedPreviousMap.put(opp.OwnerId,tempList);
            }else{
                List<Opportunity> tempList = new List<Opportunity>();
                tempList.add(opp);
                scRescuedPreviousMap.put(opp.OwnerId,tempList);
            }
            if(opp.Opening_Agent__c != null && (profileIdNameMap.get(opp.Opening_Agent__r.ProfileId)=='Custom - CSR' || profileIdNameMap.get(opp.Opening_Agent__r.ProfileId)=='Custom - Quality Control')){
                if(csrRescuedPreviousMap.containsKey(opp.Opening_Agent__c)){
                    List<Opportunity> tempList = new List<Opportunity>();
                    tempList = csrRescuedPreviousMap.get(opp.Opening_Agent__c );
                    tempList.add(opp);
                    csrRescuedPreviousMap.put(opp.Opening_Agent__c ,tempList);
                }else{
                    List<Opportunity> tempList = new List<Opportunity>();
                    tempList.add(opp);
                    csrRescuedPreviousMap.put(opp.Opening_Agent__c ,tempList);
                }
            }
        }
        
        for(Id userId : scRescuedPreviousMap.keyset()){
            system.debug('oppId ::: '+userId +' ::: list size ::::'+scRescuedPreviousMap.get(userId ).size());
            Monthly_Commisions__c mc = new Monthly_Commisions__c(Type_of_User__c = 'Senior Counselor',User__c = userId ,Month__c = monthMap.get(queryStartDate.month()),
                                                                 Year__c = String.valueOf(queryStartDate.year()),Total_Rescued_Commision__c = 0,Reduced_Commission__c=0,
                                                                 Tier_1_Personal_Referral__c=0,Tier_2_Personal_Referral__c=0,Tier_1_Repeat_Business__c=0,
                                                                 Tier_2_Repeat_Business__c=0, Tier_1_Rescued__c=0,Tier_2_Rescued__c=0,Total_Number_of_Smile_and_Dial_Opps__c=0);
            for(Opportunity opp : scRescuedPreviousMap.get(userId )){
                mc.Total_Rescued_Commision__c = mc.Total_Rescued_Commision__c + opp.Rescued_Commission__c;
                if(opp.Commission_Tier__c == 'Tier 1')
                    mc.Tier_1_Rescued__c = mc.Tier_1_Rescued__c+1;
                if(opp.Commission_Tier__c == 'Tier 2')
                    mc.Tier_2_Rescued__c = mc.Tier_2_Rescued__c+1;
                if(opp.Commission_Reduced__c == True)
                    mc.Reduced_Commission__c = mc.Reduced_Commission__c+1;
            }
            previousMonthCommissionSCMap.put(userId ,mc);
        } 
        
        system.debug('previousMonthCommissionSCMap ::'+previousMonthCommissionSCMap);
        for(Id userId : csrRescuedPreviousMap.keyset()){
            system.debug('oppId ::: '+userId +' ::: list size ::::'+csrRescuedPreviousMap.get(userId ).size());
            Monthly_Commisions__c mc = new Monthly_Commisions__c(Type_of_User__c = 'CSR',User__c = userId ,Month__c = monthMap.get(queryStartDate.month()),
                                                                 Year__c = String.valueOf(queryStartDate.year()),Total_Rescued_Commision__c = 0,
                                                                 Tier_1_Personal_Referral__c=0,Tier_2_Personal_Referral__c=0,Tier_1_Repeat_Business__c=0,
                                                                 Tier_2_Repeat_Business__c=0, Tier_1_Rescued__c=0,Tier_2_Rescued__c=0,Total_Number_of_Smile_and_Dial_Opps__c=0);
            for(Opportunity opp : csrRescuedPreviousMap.get(userId )){
                mc.Total_Rescued_Commision__c = mc.Total_Rescued_Commision__c + opp.Rescued_Commission__c;
                if(opp.Commission_Tier__c == 'Tier 1')
                    mc.Tier_1_Rescued__c = mc.Tier_1_Rescued__c+1;
                if(opp.Commission_Tier__c == 'Tier 2')
                    mc.Tier_2_Rescued__c = mc.Tier_2_Rescued__c+1;
                if(opp.Smile_and_Dial__c == True)
                    mc.Total_Number_of_Smile_and_Dial_Opps__c = mc.Total_Number_of_Smile_and_Dial_Opps__c +1;
                
                if((mc.Tier_1_Rescued__c + mc.Tier_2_Rescued__c) <=9)
                    mc.Total_Rescued_Commision__c = (mc.Tier_1_Rescued__c + mc.Tier_2_Rescued__c)*50;
                else if((mc.Tier_1_Rescued__c + mc.Tier_2_Rescued__c) >9 && (mc.Tier_1_Rescued__c + mc.Tier_2_Rescued__c) <=14)
                    mc.Total_Rescued_Commision__c = (mc.Tier_1_Rescued__c + mc.Tier_2_Rescued__c)*100;
                else
                    mc.Total_Rescued_Commision__c = (mc.Tier_1_Rescued__c + mc.Tier_2_Rescued__c)*150;
                
                if(mc.Total_Number_of_Smile_and_Dial_Opps__c > 0)
                    mc.Total_Rescued_Commision__c = mc.Total_Rescued_Commision__c + (mc.Total_Number_of_Smile_and_Dial_Opps__c * 500);
            }
            previousMonthCommissionCSRMap.put(userId ,mc);
        }
        system.debug('previousMonthCommissionCSRMap ::'+previousMonthCommissionCSRMap);
        
        for(Opportunity opp : currentMonthOpps){
            if(opp.Referral_Agent__c != null && opp.Referral_Verified__c == True){
                boolean userFound = False;
                if(currentMonthCommissionCSRMap.containsKey(opp.Referral_Agent__c)){
                    userFound = True;
                    Monthly_Commisions__c tempMC = currentMonthCommissionCSRMap.get(opp.Referral_Agent__c);
                    if(opp.Commission_Tier__c == 'Tier 1' && opp.LeadSource=='Personal Referral'){
                        tempMC.Tier_1_Personal_Referral__c = tempMC.Tier_1_Personal_Referral__c+1;
                    }
                    else if(opp.Commission_Tier__c == 'Tier 1' && opp.LeadSource=='Repeat Business'){
                        tempMC.Tier_1_Repeat_Business__c = tempMC.Tier_1_Repeat_Business__c +1;
                    }
                    else if(opp.Commission_Tier__c == 'Tier 2' && opp.LeadSource=='Personal Referral'){
                        tempMC.Tier_2_Personal_Referral__c= tempMC.Tier_2_Personal_Referral__c+1;
                    }
                    else if(opp.Commission_Tier__c == 'Tier 2' && opp.LeadSource=='Repeat Business'){
                        tempMC.Tier_2_Repeat_Business__c = tempMC.Tier_2_Repeat_Business__c +1;
                    }
                    currentMonthCommissionCSRMap.put(opp.Referral_Agent__c,tempMC);
                }
                if(userFound == False){
                    if(currentMonthCommissionSCMap.containsKey(opp.Referral_Agent__c)){
                        userFound = True;
                        Monthly_Commisions__c tempMC = currentMonthCommissionSCMap.get(opp.Referral_Agent__c);
                        if(opp.Commission_Tier__c == 'Tier 1' && opp.LeadSource=='Personal Referral'){
                            tempMC.Tier_1_Personal_Referral__c = tempMC.Tier_1_Personal_Referral__c+1;
                        }
                        else if(opp.Commission_Tier__c == 'Tier 1' && opp.LeadSource=='Repeat Business'){
                            tempMC.Tier_1_Repeat_Business__c = tempMC.Tier_1_Repeat_Business__c +1;
                        }
                        else if(opp.Commission_Tier__c == 'Tier 2' && opp.LeadSource=='Personal Referral'){
                            tempMC.Tier_2_Personal_Referral__c= tempMC.Tier_2_Personal_Referral__c+1;
                        }
                        else if(opp.Commission_Tier__c == 'Tier 2' && opp.LeadSource=='Repeat Business'){
                            tempMC.Tier_2_Repeat_Business__c = tempMC.Tier_2_Repeat_Business__c +1;
                        }
                        currentMonthCommissionSCMap.put(opp.Referral_Agent__c,tempMC);
                    }    
                }
                if(userFound == False){
                     Monthly_Commisions__c mc = new Monthly_Commisions__c(User__c = opp.Referral_Agent__c,Month__c = monthMap.get(queryEndDate.month()),
                                                                 Year__c = String.valueOf(queryEndDate.year()),Total_Rescued_Commision__c = 0,
                                                                 Tier_1_Personal_Referral__c=0,Tier_2_Personal_Referral__c=0,Tier_1_Repeat_Business__c=0,
                                                                 Tier_2_Repeat_Business__c=0, Tier_1_Rescued__c=0,Tier_2_Rescued__c=0);
                    if(opp.Commission_Tier__c == 'Tier 1' && opp.LeadSource=='Personal Referral'){
                        mc.Tier_1_Personal_Referral__c = mc.Tier_1_Personal_Referral__c+1;
                    }
                    else if(opp.Commission_Tier__c == 'Tier 1' && opp.LeadSource=='Repeat Business'){
                        mc.Tier_1_Repeat_Business__c = mc.Tier_1_Repeat_Business__c +1;
                    }
                    else if(opp.Commission_Tier__c == 'Tier 2' && opp.LeadSource=='Personal Referral'){
                        mc.Tier_2_Personal_Referral__c= mc.Tier_2_Personal_Referral__c+1;
                    }
                    else if(opp.Commission_Tier__c == 'Tier 2' && opp.LeadSource=='Repeat Business'){
                        mc.Tier_2_Repeat_Business__c = mc.Tier_2_Repeat_Business__c +1;
                    }
                    
                    if(profileIdNameMap.get(opp.Referral_Agent__r.ProfileId)=='Custom - CSR' || profileIdNameMap.get(opp.Referral_Agent__r.ProfileId)=='Custom - Quality Control'){
                        mc.Type_of_User__c = 'CSR';
                        currentMonthCommissionCSRMap.put(opp.Referral_Agent__c,mc);
                    }else{
                        mc.Type_of_User__c = 'Senior Counselor';
                        currentMonthCommissionSCMap.put(opp.Referral_Agent__c,mc);
                    }   
                }
            }
        }
        
       
        for(Opportunity opp : previousMonthOpps){
            if(opp.Referral_Agent__c != null && opp.Referral_Verified__c == True){
                boolean userFound = False;
                if(previousMonthCommissionCSRMap.containsKey(opp.Referral_Agent__c)){
                    userFound = True;
                    Monthly_Commisions__c tempMC = previousMonthCommissionCSRMap.get(opp.Referral_Agent__c);
                    if(opp.Commission_Tier__c == 'Tier 1' && opp.LeadSource=='Personal Referral'){
                        tempMC.Tier_1_Personal_Referral__c = tempMC.Tier_1_Personal_Referral__c+1;
                    }
                    else if(opp.Commission_Tier__c == 'Tier 1' && opp.LeadSource=='Repeat Business'){
                        tempMC.Tier_1_Repeat_Business__c = tempMC.Tier_1_Repeat_Business__c +1;
                    }
                    else if(opp.Commission_Tier__c == 'Tier 2' && opp.LeadSource=='Personal Referral'){
                        tempMC.Tier_2_Personal_Referral__c= tempMC.Tier_2_Personal_Referral__c+1;
                    }
                    else if(opp.Commission_Tier__c == 'Tier 2' && opp.LeadSource=='Repeat Business'){
                        tempMC.Tier_2_Repeat_Business__c = tempMC.Tier_2_Repeat_Business__c +1;
                    }
                    previousMonthCommissionCSRMap.put(opp.Referral_Agent__c,tempMC);
                }
                if(userFound == False){
                    if(previousMonthCommissionSCMap.containsKey(opp.Referral_Agent__c)){
                        userFound = True;
                        Monthly_Commisions__c tempMC = previousMonthCommissionSCMap.get(opp.Referral_Agent__c);
                        if(opp.Commission_Tier__c == 'Tier 1' && opp.LeadSource=='Personal Referral'){
                            tempMC.Tier_1_Personal_Referral__c = tempMC.Tier_1_Personal_Referral__c+1;
                        }
                        else if(opp.Commission_Tier__c == 'Tier 1' && opp.LeadSource=='Repeat Business'){
                            tempMC.Tier_1_Repeat_Business__c = tempMC.Tier_1_Repeat_Business__c +1;
                        }
                        else if(opp.Commission_Tier__c == 'Tier 2' && opp.LeadSource=='Personal Referral'){
                            tempMC.Tier_2_Personal_Referral__c= tempMC.Tier_2_Personal_Referral__c+1;
                        }
                        else if(opp.Commission_Tier__c == 'Tier 2' && opp.LeadSource=='Repeat Business'){
                            tempMC.Tier_2_Repeat_Business__c = tempMC.Tier_2_Repeat_Business__c +1;
                        }
                        previousMonthCommissionSCMap.put(opp.Referral_Agent__c,tempMC);
                    }    
                }
                if(userFound == False){
                     Monthly_Commisions__c mc = new Monthly_Commisions__c(User__c = opp.Referral_Agent__c,Month__c = monthMap.get(queryStartDate.month()),
                                                                 Year__c = String.valueOf(queryStartDate.year()),Total_Rescued_Commision__c = 0,
                                                                 Tier_1_Personal_Referral__c=0,Tier_2_Personal_Referral__c=0,Tier_1_Repeat_Business__c=0,
                                                                 Tier_2_Repeat_Business__c=0, Tier_1_Rescued__c=0,Tier_2_Rescued__c=0);
                    if(opp.Commission_Tier__c == 'Tier 1' && opp.LeadSource=='Personal Referral'){
                        mc.Tier_1_Personal_Referral__c = mc.Tier_1_Personal_Referral__c+1;
                    }
                    else if(opp.Commission_Tier__c == 'Tier 1' && opp.LeadSource=='Repeat Business'){
                        mc.Tier_1_Repeat_Business__c = mc.Tier_1_Repeat_Business__c +1;
                    }
                    else if(opp.Commission_Tier__c == 'Tier 2' && opp.LeadSource=='Personal Referral'){
                        mc.Tier_2_Personal_Referral__c= mc.Tier_2_Personal_Referral__c+1;
                    }
                    else if(opp.Commission_Tier__c == 'Tier 2' && opp.LeadSource=='Repeat Business'){
                        mc.Tier_2_Repeat_Business__c = mc.Tier_2_Repeat_Business__c +1;
                    }
                    
                    if(profileIdNameMap.get(opp.Referral_Agent__r.ProfileId)=='Custom - CSR' || profileIdNameMap.get(opp.Referral_Agent__r.ProfileId)=='Custom - Quality Control'){
                        mc.Type_of_User__c = 'CSR';
                        previousMonthCommissionCSRMap.put(opp.Referral_Agent__c,mc);
                    }else{
                        mc.Type_of_User__c = 'Senior Counselor';
                        previousMonthCommissionSCMap.put(opp.Referral_Agent__c,mc);
                    }   
                }
            }
        }
        
        if(previousMonthCommissionSCMap.size()>0){
            for(Id cwid : previousMonthCommissionSCMap.keySet()){
                insertList.add(previousMonthCommissionSCMap.get(cwid));
            }    
        }
        if(previousMonthCommissionCSRMap.size()>0){
            for(Id cwid : previousMonthCommissionCSRMap.keySet()){
                insertList.add(previousMonthCommissionCSRMap.get(cwid));
            }    
        }
        if(currentMonthCommissionSCMap.size()>0){
            for(Id cwid : currentMonthCommissionSCMap.keySet()){
                insertList.add(currentMonthCommissionSCMap.get(cwid));
            }    
        }
        if(currentMonthCommissionCSRMap.size()>0){
            for(Id cwid : currentMonthCommissionCSRMap.keySet()){
                insertList.add(currentMonthCommissionCSRMap.get(cwid));
            }    
        }
        
        system.debug('insertList ::::'+insertList);
        try{
            if(deleteList.size()!=null)
                delete deleteList;
            if(insertList.size()!=null)
                insert insertList;
        }catch(exception e){
                
        }  
    }
        
}