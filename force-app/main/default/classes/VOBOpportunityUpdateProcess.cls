global class VOBOpportunityUpdateProcess{
    
     Webservice static void UpdateOpportunities( list<opportunity> lstOpp,list<VOB_Request__c> LstvOB){
         system.debug('Lst Opp:::::'+ LstOpp);
         map<id,id> MapVobToOpp = new map<id,id>();
         boolean displayPrimary;
         boolean displaySecondary;
         Insurance_Information__c insuranceInformation1;
         Insurance_Information__c insuranceInformation2;
         Insurance_Verification__c insuranceVerification1;
         Insurance_Verification__c insuranceVerification2;
         opportunity opp;
         opportunity oppInfo;
         list<opportunity> LstOppUpdate = new list<opportunity>();

   
   


         for(Opportunity OppIns: LstOpp){
             MapVobToOpp.put(OppIns.Latest_VOB_Request__c ,OppIns.id);
             system.debug('MapVobToOppvalues'+MapVobToOpp);
         }

         Map<Id,Opportunity> mapOfOppty = new Map<Id,opportunity>([select id, Latest_VOB_Request__c, 
                                    Latest_VOB_Request__r.VOB_Request_Status__c, Name,
                                     Owner.MobilePhone, Owner.name, insurance_provider__c,
                                      client_dob__c from Opportunity where id IN : MapVobToOpp.values()]);
        
         
         
          for(VOB_Request__c VOBIns : LstvOB){
        
            displayPrimary=false;
        displaySecondary = false;
        List<Insurance_Information__c> insuranceInformationList = new list<Insurance_Information__c>();
        List<Insurance_Verification__c> insuranceVerificationList = new list<Insurance_Verification__c> ();
        insuranceInformation1 = new Insurance_Information__c ();
        insuranceInformation2 = new Insurance_Information__c ();
        insuranceVerification2 = new Insurance_verification__c();
        insuranceVerification1  = new Insurance_verification__c();
        
            string OppId = MapVobToOpp.get(VOBIns.id);
                        system.debug('OppIDValue:::::'+ OPPID);
                                    system.debug('VOBIDValue:::::'+ VOBIns);


            if(OppId != null) {

            //String oppId = VOBIns.Opportunity__c;
            system.debug('OppIDValue:::::'+ OPPID);
            
            opp = mapOfOppty.get(OppId);
            oppInfo = new opportunity();
            oppInfo.Client_DOB__c = opp.client_dob__c;
            oppInfo.Insurance_Provider__c = opp.Insurance_Provider__c;
            oppInfo.Name = opp.Name;
            Map<String,Schema.SObjectField> insuranceInformationfields = Schema.getGlobalDescribe().get('Insurance_Information__c').getDescribe().fields.getMap();
            Map<String,Schema.SObjectField> insuranceVerificationfields = Schema.getGlobalDescribe().get('Insurance_Verification__c').getDescribe().fields.getMap();
            String insuranceInformationQueryString='Select ';
            For(String field : insuranceInformationfields.keySet()){
                if(insuranceInformationQueryString == 'Select ')
                    insuranceInformationQueryString = insuranceInformationQueryString+' '+field;
                else
                    insuranceInformationQueryString = insuranceInformationQueryString+', '+field;
            }
            insuranceInformationQueryString = insuranceInformationQueryString+' FROM Insurance_Information__c WHERE Opportunity__c =: oppId';
        
            String insuranceVerificationQueryString = 'Select ';
            For(String field : insuranceVerificationfields.keySet()){
                if(insuranceVerificationQueryString == 'Select ')
                    insuranceVerificationQueryString = insuranceVerificationQueryString+' '+field;
                else
                    insuranceVerificationQueryString = insuranceVerificationQueryString+', '+field;
            }
            insuranceVerificationQueryString = insuranceVerificationQueryString+' FROM Insurance_Verification__c WHERE Opportunity__c =:oppId';
            
            insuranceInformationList = Database.query(insuranceInformationQueryString);
            insuranceVerificationList = Database.query(insuranceVerificationQueryString);
            for(Insurance_Information__c ii : insuranceInformationList){
            if(ii.Insurance_Status__c == null){
                insuranceInformation1 = ii;
                displayPrimary = True;
            }else if(ii.Insurance_Status__c == null && displayPrimary == True){
                insuranceInformation2 = ii;
                displaySecondary = True;
            }else if(ii.Insurance_Status__c == 'Primary'){
                insuranceInformation1 = ii;
                displayPrimary = True;
            }else if(ii.Insurance_Status__c == 'Secondary'){
                insuranceInformation2 = ii;
                displaySecondary = True;
               }
            for(Insurance_Verification__c iv : insuranceVerificationList){
                if(ii.id  == iv.Related_Insurance_Information__c){
                    if(insuranceInformation1.id == ii.id){
                        insuranceVerification1 = iv;
                    }else{
                        insuranceVerification2 = iv;
                    }
                }
            }
            
        }
        
        if(displayPrimary == null)
            displayPrimary=True;
        if(displaySecondary == null)
            displaySecondary = False;
         if(displayPrimary == True && displaySecondary==False){
        String primaryNotes='';
            
        primaryNotes = 'Primary Insurance Information';
        if(insuranceInformation1.Insurance_Policy__c != null)
            primaryNotes = primaryNotes + '\nInsurance Policy# : '+insuranceInformation1.Insurance_Policy__c;
        if(insuranceInformation1.Insurance_Type__c != null)
            primaryNotes = primaryNotes + '\nInsurance Type : '+insuranceInformation1.Insurance_Type__c;
        if(insuranceVerification1.Effective_Date__c != null)
            primaryNotes = primaryNotes + '\nEffective Date : '+insuranceVerification1.Effective_Date__c;
        if(insuranceVerification1.Termination_Date__c != null)
            primaryNotes = primaryNotes +',\nTermination Date : '+insuranceVerification1.Termination_Date__c;
        if(insuranceVerification1.Calendar_Plan_Year__c != null)
            primaryNotes = primaryNotes +',\n Calendar/Plan Year : '+insuranceVerification1.Calendar_Plan_Year__c;
        if(insuranceVerification1.Rate_Type__c != null)
            primaryNotes = primaryNotes +',\nRate Type : '+insuranceVerification1.Rate_Type__c;
        if(insuranceVerification1.Covered__c != null)
            primaryNotes = primaryNotes +',\n% Covered : '+insuranceVerification1.Covered__c;
        if(insuranceVerification1.State_Lic_Accepted__c != null)
            primaryNotes = primaryNotes +',\nState License Accepted : '+insuranceVerification1.State_Lic_Accepted__c;
        if(insuranceVerification1.JCAHO_CARF_Req_Levels__c != null)
            primaryNotes = primaryNotes +',\nJCAHO/CARF Req (Levels) : '+insuranceVerification1.JCAHO_CARF_Req_Levels__c;
        if(insuranceVerification1.Policy_Exclusions__c != null)    
            primaryNotes = primaryNotes +',\nPolicy Exclusions : '+insuranceVerification1.Policy_Exclusions__c;
        if(insuranceVerification1.Out_of_State_Restrictions__c != null)
            primaryNotes = primaryNotes +',\nOut of State Restrictions : '+insuranceVerification1.Out_of_State_Restrictions__c;
        if(insuranceVerification1.Assignment_of_Benefits_Accepted__c != null)
            primaryNotes = primaryNotes +',\nAssignment of Benefits Accepted : '+insuranceVerification1.Assignment_of_Benefits_Accepted__c;
        if(insuranceVerification1.COB_on_File__c != null)
            primaryNotes = primaryNotes +',\nCOB on File : '+insuranceVerification1.COB_on_File__c;

        if(insuranceVerification1.Precert_Company__c != null)
                primaryNotes = primaryNotes +',\nPrecert Company : '+insuranceVerification1.Precert_Company__c;
        if(insuranceVerification1.Precert_Phone_Number__c != null)
                primaryNotes = primaryNotes +',\nPrecert Phone Number : '+insuranceVerification1.Precert_Phone_Number__c;
        if(insuranceVerification1.Carve_Out_for_Behavioral_Health__c != null)
                primaryNotes = primaryNotes +',\nCarve Out for Behavioral Health : '+insuranceVerification1.Carve_Out_for_Behavioral_Health__c;
        if(insuranceVerification1.Carve_Out_Phone_Number__c!= null)
                primaryNotes = primaryNotes +',\nCarve Out Phone Number : '+insuranceVerification1.Carve_Out_Phone_Number__c; 
        if(insuranceVerification1.Carve_Out_Policy_Number__c!= null)
                primaryNotes = primaryNotes +',\nCarve Out Policy Number : '+insuranceVerification1.Carve_Out_Policy_Number__c; 
        if(insuranceInformation1.Insurance_Policy__c != null && insuranceInformation1.Insurance_Policy__c.length() >= 3)
            primaryNotes = primaryNotes +',\n Policy ID Number : '+insuranceInformation1.Insurance_Policy__c.substring(0,2);
        if(insuranceInformation1.Employer__c != null)
            primaryNotes = primaryNotes +',\nEmployer : '+insuranceInformation1.Employer__c;
        if(insuranceVerification1.Additional_Notes__c != null)    
            primaryNotes = primaryNotes +',\nAdditional Notes : '+insuranceVerification1.Additional_Notes__c+'\n\n'; 
            
            
         if(insuranceVerification1.Detox_Benefits_Covered_INNET__c != null || insuranceVerification1.Residential_Benefits_Covered_INNET__c != null || insuranceVerification1.Part_Hospital_Covered_INNET__c != null ||  insuranceVerification1.IOP_Covered_INNET__c != null || insuranceVerification1.OP_Covered_INNET__c != null)
            primaryNotes = primaryNotes +',\n IN NETWORK BENEFITS'; 
        if(insuranceVerification1.DED_INNET__c != null)
            primaryNotes = primaryNotes + ',\nIN NET DED : '+insuranceVerification1.DED_INNET__c;
        if(insuranceVerification1.DED_met_INNET__c != null)
            primaryNotes = primaryNotes +',\nIN NET DED met : '+insuranceVerification1.DED_met_INNET__c;
        if(insuranceVerification1.OOP_INNET__c != null)
            primaryNotes = primaryNotes +',\nIN NET OOP : '+insuranceVerification1.OOP_INNET__c;
        if(insuranceVerification1.OOP_met_INNET__c != null)
            primaryNotes = primaryNotes +',\nIN NET OOP Met : '+insuranceVerification1.OOP_met_INNET__c;
        if(insuranceVerification1.DED_Apply_to_OOP_INNET__c != null)
            primaryNotes = primaryNotes +',\nIN NET DED apply to OOP : '+insuranceVerification1.DED_Apply_to_OOP_INNET__c;
        if(insuranceVerification1.Individual_or_Family_INNET__c != null)
            primaryNotes = primaryNotes +',\nIN NET Individual/Family : '+insuranceVerification1.Individual_or_Family_INNET__c;
        if(insuranceVerification1.Detox_Benefits_Covered_INNET__c != null)
            primaryNotes = primaryNotes +',\nDetox Coverage % : '+insuranceVerification1.Detox_Benefits_Covered_INNET__c;
        if(insuranceVerification1.Detox_Benefits_Max_Per_Day_INNET__c != null)
            primaryNotes = primaryNotes +',\nDetox Max $ per day : '+insuranceVerification1.Detox_Benefits_Max_Per_Day_INNET__c;
        if(insuranceVerification1.Residential_Benefits_Covered_INNET__c != null)
            primaryNotes = primaryNotes +',\nRTC Coverage % : '+insuranceVerification1.Residential_Benefits_Covered_INNET__c;
        if(insuranceVerification1.Residential_Benefits_Max_Per_Day_INNET__c != null)
            primaryNotes = primaryNotes +',\nRTC Max $ per day : '+insuranceVerification1.Residential_Benefits_Max_Per_Day_INNET__c;
        if(insuranceVerification1.Part_Hospital_Covered_INNET__c != null)
            primaryNotes = primaryNotes +',\nPHP Coverage % : '+insuranceVerification1.Part_Hospital_Covered_INNET__c;
        if(insuranceVerification1.Part_Hospital_Max_Per_Day_INNET__c != null)
            primaryNotes = primaryNotes +',\nPHP Max $ per day : '+insuranceVerification1.Part_Hospital_Max_Per_Day_INNET__c;
        if(insuranceVerification1.IOP_Covered_INNET__c != null)
            primaryNotes = primaryNotes +',\nIOP Coverage % : '+insuranceVerification1.IOP_Covered_INNET__c;
        if(insuranceVerification1.IOP_Max_Per_Day_INNET__c != null)
            primaryNotes = primaryNotes +',\nIOP Max $ per day : '+insuranceVerification1.IOP_Max_Per_Day_INNET__c;
        if(insuranceVerification1.OP_Covered_INNET__c != null)
            primaryNotes = primaryNotes +',\nOP Coverage % : '+insuranceVerification1.OP_Covered_INNET__c;
        if(insuranceVerification1.OP_Max_Per_Day_INNET__c != null)
            primaryNotes = primaryNotes +',\nOP Max $ per day : '+insuranceVerification1.OP_Max_Per_Day_INNET__c;    
            
        if(insuranceVerification1.Detox_Benefits_Covered__c != null || insuranceVerification1.Residential_Benefits_Covered__c != null || insuranceVerification1.Part_Hospital_Covered__c != null ||  insuranceVerification1.IOP_Covered__c != null || insuranceVerification1.OP_Covered__c != null)
            primaryNotes = primaryNotes +',\n OUT OF NETWORK BENEFITS'; 
        if(insuranceVerification1.Substance_Abuse_DED__c != null)
            primaryNotes = primaryNotes + ',\nOON DED : '+insuranceVerification1.Substance_Abuse_DED__c;
        if(insuranceVerification1.Substance_Abuse_DED_met__c != null)
            primaryNotes = primaryNotes +',\nOON DED met : '+insuranceVerification1.Substance_Abuse_DED_met__c;
        if(insuranceVerification1.Substance_Abuse_OOP__c != null)
            primaryNotes = primaryNotes +',\nOON OOP : '+insuranceVerification1.Substance_Abuse_OOP__c;
        if(insuranceVerification1.Substance_Abuse_OOP_met__c != null)
            primaryNotes = primaryNotes +',\nOON OOP Met : '+insuranceVerification1.Substance_Abuse_OOP_met__c;
        if(insuranceVerification1.Substance_Abuse_DED_Apply_to_OOP__c != null)
            primaryNotes = primaryNotes +',\nOON DED apply to OOP : '+insuranceVerification1.Substance_Abuse_DED_Apply_to_OOP__c;
        if(insuranceVerification1.Substance_Abuse_Individual_or_Family__c != null)
            primaryNotes = primaryNotes +',\nOON Individual/Family : '+insuranceVerification1.Substance_Abuse_Individual_or_Family__c;
        if(insuranceVerification1.Detox_Benefits_Covered__c != null)
            primaryNotes = primaryNotes +',\nDetox Coverage % : '+insuranceVerification1.Detox_Benefits_Covered__c;
        if(insuranceVerification1.Detox_Benefits_Max_Per_Day__c != null)
            primaryNotes = primaryNotes +',\nDetox Max $ per day : '+insuranceVerification1.Detox_Benefits_Max_Per_Day__c;
        if(insuranceVerification1.Residential_Benefits_Covered__c != null)
            primaryNotes = primaryNotes +',\nRTC Coverage % : '+insuranceVerification1.Residential_Benefits_Covered__c;
        if(insuranceVerification1.Residential_Benefits_Max_Per_Day__c != null)
            primaryNotes = primaryNotes +',\nRTC Max $ per day : '+insuranceVerification1.Residential_Benefits_Max_Per_Day__c;
        if(insuranceVerification1.Part_Hospital_Covered__c != null)
            primaryNotes = primaryNotes +',\nPHP Coverage % : '+insuranceVerification1.Part_Hospital_Covered__c;
        if(insuranceVerification1.Part_Hospital_Max_Per_Day__c != null)
            primaryNotes = primaryNotes +',\nPHP Max $ per day : '+insuranceVerification1.Part_Hospital_Max_Per_Day__c;
        if(insuranceVerification1.IOP_Covered__c != null)
            primaryNotes = primaryNotes +',\nIOP Coverage % : '+insuranceVerification1.IOP_Covered__c;
        if(insuranceVerification1.IOP_Max_Per_Day__c != null)
            primaryNotes = primaryNotes +',\nIOP Max $ per day : '+insuranceVerification1.IOP_Max_Per_Day__c;
        if(insuranceVerification1.OP_Covered__c != null)
            primaryNotes = primaryNotes +',\nOP Coverage % : '+insuranceVerification1.OP_Covered__c;
        if(insuranceVerification1.OP_Max_Per_Day__c != null)
            primaryNotes = primaryNotes +',\nOP Max $ per day : '+insuranceVerification1.OP_Max_Per_Day__c;
        
       
        
            //Akash Add Begins
            
        
            system.debug('display primary');
            system.debug('primary insurance status ::'+insuranceInformation1.Insurance_Status__c);
            if(insuranceInformation1.Insurance_Status__c != null && insuranceInformation1.Insurance_Provider__c != null){
                system.debug('point update');
               
                
               Opportunity tempOpp = new Opportunity(id = oppId , VOB_Status__c= 'Completed', Insurance_Verified_By__c = UserInfo.getUserId(), 
                                                        Insurance_Verified_Time_Stamp__c = dateTime.Now(), VOB_Completed__c = dateTime.Now(),
                                                        Insurance_Provider__c = insuranceInformation1.Insurance_Provider__c, Insurance_Notes__c = primaryNotes,
                                                        Client_DOB__c = oppInfo.client_dob__c, Name= oppInfo.Name, VOB_Info_Rate_Type__c = insuranceVerification1.Rate_Type__c,
                                                        VOB_Info_Assignment_of_Benefits_Accepted__c = insuranceVerification1.Assignment_of_Benefits_Accepted__c,
                                                     Carve_Out_for_Behavioral_Health__c = insuranceVerification1.Carve_Out_for_Behavioral_Health__c, Carve_Out_Phone_Number__c = insuranceVerification1.Carve_Out_Phone_Number__c,
                                                     Carve_Out_Policy_Number__c = insuranceVerification1.Carve_Out_Policy_Number__c, Insurance_Policy__c = insuranceInformation1.Insurance_Policy__c,
                                                     Covered__c = insuranceVerification1.Covered__c, Month_to_Month__c = insuranceVerification1.Month_to_Month__c,
                                                     Will_Plan_Terminate_when_Client_Turns_26__c = insuranceVerification1.Will_Plan_Terminate_when_Client_Turns_26__c,
                                                     Cobra__c = insuranceVerification1.Cobra__c, COB_on_File__c = insuranceVerification1.COB_on_File__c,
                                                     Substance_Abuse_Copay_Admit_Fee__c = insuranceVerification1.Substance_Abuse_Copay_Admit_Fee__c,
                                                     Substance_Abuse_DED_Apply_to_OOP__c = insuranceVerification1.Substance_Abuse_DED_Apply_to_OOP__c,
                                                     Substance_Abuse_Individual_or_Family__c = insuranceVerification1.Substance_Abuse_Individual_or_Family__c,
                                                     State_Lic_Accepted__c = insuranceVerification1.State_Lic_Accepted__c,
                                                     JCAHO_CARF_Req_Levels__c = insuranceVerification1.JCAHO_CARF_Req_Levels__c,
                                                     Free_Standing__c = insuranceVerification1.Free_Standing_Facility__c,
                                                     Usual_and_Customary__c = insuranceVerification1.Rate_Type__c,
                                                     Assignment_of_Benefits__c = insuranceVerification1.Assignment_of_Benefits_Accepted__c,
                                                     OON_Deductible__c = insuranceVerification1.Substance_Abuse_DED__c,
                                                     OON_Deductible_Met__c = insuranceVerification1.Substance_Abuse_DED_met__c,
                                                     OON_OOP_Max__c = insuranceVerification1.Substance_Abuse_OOP__c,
                                                     OON_OOP_Met__c = insuranceVerification1.Substance_Abuse_OOP_met__c,
                                                      Deductible__c  = insuranceVerification1.DED_INNET__c,
                                                     Deductible_Met__c = insuranceVerification1.DED_met_INNET__c,
                                                     OOP_Max__c = insuranceVerification1.OOP_INNET__c,
                                                     OOP_Met__c = insuranceVerification1.OOP_met_INNET__c);
                LstOppUpdate.add(tempOpp );
                
            }
            
        }
        
        if(displayPrimary == True && displaySecondary==True){
            
            String primaryNotes='';
            String secondaryNotes='';
                  primaryNotes = 'Primary Insurance Information';
            if(insuranceInformation1.Insurance_Policy__c != null)
                primaryNotes = primaryNotes + '\nInsurance Policy# : '+insuranceInformation1.Insurance_Policy__c;
            if(insuranceInformation1.Insurance_Type__c != null)
                primaryNotes = primaryNotes + '\nInsurance Type : '+insuranceInformation1.Insurance_Type__c;
            if(insuranceVerification1.Effective_Date__c != null)
                primaryNotes = primaryNotes + '\nEffective Date : '+insuranceVerification1.Effective_Date__c;
            if(insuranceVerification1.Termination_Date__c != null)
                primaryNotes = primaryNotes +',\nTermination Date : '+insuranceVerification1.Termination_Date__c;
            if(insuranceVerification1.Calendar_Plan_Year__c != null)
                primaryNotes = primaryNotes +',\n Calendar/Plan Year : '+insuranceVerification1.Calendar_Plan_Year__c;
            if(insuranceVerification1.Rate_Type__c != null)
                primaryNotes = primaryNotes +',\nRate Type : '+insuranceVerification1.Rate_Type__c;
            if(insuranceVerification1.Covered__c != null)
                primaryNotes = primaryNotes +',\n% Covered : '+insuranceVerification1.Covered__c;
            if(insuranceVerification1.State_Lic_Accepted__c != null)
                primaryNotes = primaryNotes +',\nState License Accepted : '+insuranceVerification1.State_Lic_Accepted__c;
            if(insuranceVerification1.JCAHO_CARF_Req_Levels__c != null)
                primaryNotes = primaryNotes +',\nJCAHO/CARF Req (Levels) : '+insuranceVerification1.JCAHO_CARF_Req_Levels__c;
            if(insuranceVerification1.Policy_Exclusions__c != null)    
                primaryNotes = primaryNotes +',\nPolicy Exclusions : '+insuranceVerification1.Policy_Exclusions__c;
            if(insuranceVerification1.Out_of_State_Restrictions__c != null)
                primaryNotes = primaryNotes +',\nOut of State Restrictions : '+insuranceVerification1.Out_of_State_Restrictions__c;
            if(insuranceVerification1.Assignment_of_Benefits_Accepted__c != null)
                primaryNotes = primaryNotes +',\nAssignment of Benefits Accepted : '+insuranceVerification1.Assignment_of_Benefits_Accepted__c;
            if(insuranceVerification1.COB_on_File__c != null)
                primaryNotes = primaryNotes +',\nCOB on File : '+insuranceVerification1.COB_on_File__c;
           
            if(insuranceVerification1.Precert_Company__c != null)
                primaryNotes = primaryNotes +',\nPrecert Company : '+insuranceVerification1.Precert_Company__c;
            if(insuranceVerification1.Precert_Phone_Number__c != null)
                primaryNotes = primaryNotes +',\nPrecert Phone Number : '+insuranceVerification1.Precert_Phone_Number__c;
            if(insuranceVerification1.Carve_Out_for_Behavioral_Health__c != null)
                primaryNotes = primaryNotes +',\nCarve Out for Behavioral Health : '+insuranceVerification1.Carve_Out_for_Behavioral_Health__c;
             if(insuranceVerification1.Carve_Out_Phone_Number__c!= null)
                primaryNotes = primaryNotes +',\nCarve Out Phone Number : '+insuranceVerification1.Carve_Out_Phone_Number__c; 
            if(insuranceVerification1.Carve_Out_Policy_Number__c!= null)
                primaryNotes = primaryNotes +',\nCarve Out Policy Number : '+insuranceVerification1.Carve_Out_Policy_Number__c;    
            if(insuranceInformation1.Insurance_Policy__c != null && insuranceInformation1.Insurance_Policy__c.length() >= 3)
                primaryNotes = primaryNotes +',\n Policy ID Number : '+insuranceInformation1.Insurance_Policy__c.substring(0,2);
            if(insuranceInformation1.Employer__c != null)
                primaryNotes = primaryNotes +',\nEmployer : '+insuranceInformation1.Employer__c;
            if(insuranceVerification1.Additional_Notes__c != null)    
                primaryNotes = primaryNotes +',\nAdditional Notes : '+insuranceVerification1.Additional_Notes__c+'\n\n'; 
            
         if(insuranceVerification1.Detox_Benefits_Covered_INNET__c != null || insuranceVerification1.Residential_Benefits_Covered_INNET__c != null || insuranceVerification1.Part_Hospital_Covered_INNET__c != null ||  insuranceVerification1.IOP_Covered_INNET__c != null || insuranceVerification1.OP_Covered_INNET__c != null)
            primaryNotes = primaryNotes +',\nIN NETWORK BENEFITS'; 
        if(insuranceVerification1.DED_INNET__c != null)
            primaryNotes = primaryNotes + ',\nIN NET DED : '+insuranceVerification1.DED_INNET__c;
        if(insuranceVerification1.DED_met_INNET__c != null)
            primaryNotes = primaryNotes +',\nIN NET DED met : '+insuranceVerification1.DED_met_INNET__c;
        if(insuranceVerification1.OOP_INNET__c != null)
            primaryNotes = primaryNotes +',\nIN NET OOP : '+insuranceVerification1.OOP_INNET__c;
        if(insuranceVerification1.OOP_met_INNET__c != null)
            primaryNotes = primaryNotes +',\nIN NET OOP Met : '+insuranceVerification1.OOP_met_INNET__c;
        if(insuranceVerification1.DED_Apply_to_OOP_INNET__c != null)
            primaryNotes = primaryNotes +',\nIN NET DED apply to OOP : '+insuranceVerification1.DED_Apply_to_OOP_INNET__c;
        if(insuranceVerification1.Individual_or_Family_INNET__c != null)
            primaryNotes = primaryNotes +',\nIN NET Individual/Family : '+insuranceVerification1.Individual_or_Family_INNET__c;
        if(insuranceVerification1.Detox_Benefits_Covered_INNET__c != null)
            primaryNotes = primaryNotes +',\nDetox Coverage % : '+insuranceVerification1.Detox_Benefits_Covered_INNET__c;
        if(insuranceVerification1.Detox_Benefits_Max_Per_Day_INNET__c != null)
            primaryNotes = primaryNotes +',\nDetox Max $ per day : '+insuranceVerification1.Detox_Benefits_Max_Per_Day_INNET__c;
        if(insuranceVerification1.Residential_Benefits_Covered_INNET__c != null)
            primaryNotes = primaryNotes +',\nRTC Coverage % : '+insuranceVerification1.Residential_Benefits_Covered_INNET__c;
        if(insuranceVerification1.Residential_Benefits_Max_Per_Day_INNET__c != null)
            primaryNotes = primaryNotes +',\nRTC Max $ per day : '+insuranceVerification1.Residential_Benefits_Max_Per_Day_INNET__c;
        if(insuranceVerification1.Part_Hospital_Covered_INNET__c != null)
            primaryNotes = primaryNotes +',\nPHP Coverage % : '+insuranceVerification1.Part_Hospital_Covered_INNET__c;
        if(insuranceVerification1.Part_Hospital_Max_Per_Day_INNET__c != null)
            primaryNotes = primaryNotes +',\nPHP Max $ per day : '+insuranceVerification1.Part_Hospital_Max_Per_Day_INNET__c;
        if(insuranceVerification1.IOP_Covered_INNET__c != null)
            primaryNotes = primaryNotes +',\nIOP Coverage % : '+insuranceVerification1.IOP_Covered_INNET__c;
        if(insuranceVerification1.IOP_Max_Per_Day_INNET__c != null)
            primaryNotes = primaryNotes +',\nIOP Max $ per day : '+insuranceVerification1.IOP_Max_Per_Day_INNET__c;
        if(insuranceVerification1.OP_Covered_INNET__c != null)
            primaryNotes = primaryNotes +',\nOP Coverage % : '+insuranceVerification1.OP_Covered_INNET__c;
        if(insuranceVerification1.OP_Max_Per_Day_INNET__c != null)
            primaryNotes = primaryNotes +',\nOP Max $ per day : '+insuranceVerification1.OP_Max_Per_Day_INNET__c;        
            
        if(insuranceVerification1.Detox_Benefits_Covered__c != null || insuranceVerification1.Residential_Benefits_Covered__c != null || insuranceVerification1.Part_Hospital_Covered__c != null ||  insuranceVerification1.IOP_Covered__c != null || insuranceVerification1.OP_Covered__c != null)
            primaryNotes = primaryNotes +',\nOUT OF NETWORK BENEFITS'; 
        if(insuranceVerification1.Substance_Abuse_DED__c != null)
            primaryNotes = primaryNotes + ',\nOON DED : '+insuranceVerification1.Substance_Abuse_DED__c;
        if(insuranceVerification1.Substance_Abuse_DED_met__c != null)
            primaryNotes = primaryNotes +',\nOON DED met : '+insuranceVerification1.Substance_Abuse_DED_met__c;
        if(insuranceVerification1.Substance_Abuse_OOP__c != null)
            primaryNotes = primaryNotes +',\nOON OOP : '+insuranceVerification1.Substance_Abuse_OOP__c;
        if(insuranceVerification1.Substance_Abuse_OOP_met__c != null)
            primaryNotes = primaryNotes +',\nOON OOP Met : '+insuranceVerification1.Substance_Abuse_OOP_met__c;
        if(insuranceVerification1.Substance_Abuse_DED_Apply_to_OOP__c != null)
            primaryNotes = primaryNotes +',\nOON DED apply to OOP : '+insuranceVerification1.Substance_Abuse_DED_Apply_to_OOP__c;
        if(insuranceVerification1.Substance_Abuse_Individual_or_Family__c != null)
            primaryNotes = primaryNotes +',\nOON Individual/Family : '+insuranceVerification1.Substance_Abuse_Individual_or_Family__c;
        if(insuranceVerification1.Detox_Benefits_Covered__c != null)
            primaryNotes = primaryNotes +',\nDetox Coverage % : '+insuranceVerification1.Detox_Benefits_Covered__c;
        if(insuranceVerification1.Detox_Benefits_Max_Per_Day__c != null)
            primaryNotes = primaryNotes +',\nDetox Max $ per day : '+insuranceVerification1.Detox_Benefits_Max_Per_Day__c;
        if(insuranceVerification1.Residential_Benefits_Covered__c != null)
            primaryNotes = primaryNotes +',\nRTC Coverage % : '+insuranceVerification1.Residential_Benefits_Covered__c;
        if(insuranceVerification1.Residential_Benefits_Max_Per_Day__c != null)
            primaryNotes = primaryNotes +',\nRTC Max $ per day : '+insuranceVerification1.Residential_Benefits_Max_Per_Day__c;
        if(insuranceVerification1.Part_Hospital_Covered__c != null)
            primaryNotes = primaryNotes +',\nPHP Coverage % : '+insuranceVerification1.Part_Hospital_Covered__c;
        if(insuranceVerification1.Part_Hospital_Max_Per_Day__c != null)
            primaryNotes = primaryNotes +',\nPHP Max $ per day : '+insuranceVerification1.Part_Hospital_Max_Per_Day__c;
        if(insuranceVerification1.IOP_Covered__c != null)
            primaryNotes = primaryNotes +',\nIOP Coverage % : '+insuranceVerification1.IOP_Covered__c;
        if(insuranceVerification1.IOP_Max_Per_Day__c != null)
            primaryNotes = primaryNotes +',\nIOP Max $ per day : '+insuranceVerification1.IOP_Max_Per_Day__c;
        if(insuranceVerification1.OP_Covered__c != null)
            primaryNotes = primaryNotes +',\nOP Coverage % : '+insuranceVerification1.OP_Covered__c;
        if(insuranceVerification1.OP_Max_Per_Day__c != null)
            primaryNotes = primaryNotes +',\nOP Max $ per day : '+insuranceVerification1.OP_Max_Per_Day__c;
          
              
               system.debug('primaryNotes Values::::'+ primaryNotes );
               
               system.debug('insuranceVerification1::::'+insuranceVerification1);
        system.debug('insuranceVerification2:::'+insuranceVerification2);
        
                
            secondaryNotes = '\n\n Secondary Insurance Information';
            if(insuranceInformation2.Insurance_Policy__c != null)
                secondaryNotes = secondaryNotes + '\nInsurance Policy# : '+insuranceInformation2.Insurance_Policy__c;
             if(insuranceInformation2.Insurance_Type__c != null)
                secondaryNotes = secondaryNotes + '\nInsurance Type : '+insuranceInformation2.Insurance_Type__c;
            if(insuranceVerification2.Effective_Date__c != null)
                secondaryNotes = secondaryNotes + '\nEffective Date : '+insuranceVerification2.Effective_Date__c;
            if(insuranceVerification2.Termination_Date__c != null)
                secondaryNotes = secondaryNotes +',\nTermination Date : '+insuranceVerification2.Termination_Date__c;
            if(insuranceVerification2.Calendar_Plan_Year__c != null)
                secondaryNotes = secondaryNotes +',\n Calendar/Plan Year : '+insuranceVerification2.Calendar_Plan_Year__c;
            if(insuranceVerification2.Rate_Type__c != null)
                secondaryNotes = secondaryNotes +',\nRate Type : '+insuranceVerification2.Rate_Type__c;
            if(insuranceVerification2.Covered__c != null)
                secondaryNotes = secondaryNotes +',\n% Covered : '+insuranceVerification2.Covered__c;
            if(insuranceVerification2.State_Lic_Accepted__c != null)
                secondaryNotes = secondaryNotes +',\nState License Accepted : '+insuranceVerification2.State_Lic_Accepted__c;
            if(insuranceVerification2.JCAHO_CARF_Req_Levels__c != null)
                secondaryNotes = secondaryNotes +',\nJCAHO/CARF Req (Levels) : '+insuranceVerification2.JCAHO_CARF_Req_Levels__c;
            if(insuranceVerification2.Policy_Exclusions__c != null)    
                secondaryNotes = secondaryNotes +',\nPolicy Exclusions : '+insuranceVerification2.Policy_Exclusions__c;
            if(insuranceVerification2.Out_of_State_Restrictions__c != null)
                secondaryNotes = secondaryNotes +',\nOut of State Restrictions : '+insuranceVerification2.Out_of_State_Restrictions__c;
            if(insuranceVerification2.Assignment_of_Benefits_Accepted__c != null)
                secondaryNotes = secondaryNotes +',\nAssignment of Benefits Accepted : '+insuranceVerification2.Assignment_of_Benefits_Accepted__c;
            if(insuranceVerification2.COB_on_File__c != null)
                secondaryNotes = secondaryNotes +',\nCOB on File : '+insuranceVerification2.COB_on_File__c;
            if(insuranceVerification2.Carve_Out_for_Behavioral_Health__c != null)
                secondaryNotes = secondaryNotes +',\nCarve Out for Behavioral Health : '+insuranceVerification2.Carve_Out_for_Behavioral_Health__c;
             if(insuranceVerification2.Carve_Out_Phone_Number__c!= null)
                secondaryNotes = secondaryNotes +',\nCarve Out Phone Number : '+insuranceVerification2.Carve_Out_Phone_Number__c; 
            if(insuranceVerification2.Carve_Out_Policy_Number__c!= null)
                secondaryNotes = secondaryNotes +',\nCarve Out Policy Number : '+insuranceVerification2.Carve_Out_Policy_Number__c;    
            if(insuranceInformation2.Insurance_Policy__c != null && insuranceInformation2.Insurance_Policy__c.length() >= 3)
                secondaryNotes = secondaryNotes +',\n Policy ID Number : '+insuranceInformation2.Insurance_Policy__c.substring(0,2);
            if(insuranceInformation2.Employer__c != null)
                secondaryNotes = secondaryNotes +',\nEmployer : '+insuranceInformation2.Employer__c;
            if(insuranceVerification2.Additional_Notes__c != null)    
                secondaryNotes = secondaryNotes +',\nAdditional Notes : '+insuranceVerification2.Additional_Notes__c+'\n\n'; 
                
        if(insuranceVerification2.Detox_Benefits_Covered_INNET__c != null || insuranceVerification2.Residential_Benefits_Covered_INNET__c != null || insuranceVerification2.Part_Hospital_Covered_INNET__c != null ||  insuranceVerification2.IOP_Covered_INNET__c != null || insuranceVerification2.OP_Covered_INNET__c != null)
            secondaryNotes = secondaryNotes +',\nIN NETWORK BENEFITS'; 
        if(insuranceVerification2.DED_INNET__c != null)
            secondaryNotes = secondaryNotes + ',\nIN NET DED : '+insuranceVerification2.DED_INNET__c;
        if(insuranceVerification2.DED_met_INNET__c != null)
            secondaryNotes = secondaryNotes +',\nIN NET DED met : '+insuranceVerification2.DED_met_INNET__c;
        if(insuranceVerification2.OOP_INNET__c != null)
            secondaryNotes = secondaryNotes +',\nIN NET OOP : '+insuranceVerification2.OOP_INNET__c;
        if(insuranceVerification2.OOP_met_INNET__c != null)
            secondaryNotes = secondaryNotes +',\nIN NET OOP Met : '+insuranceVerification2.OOP_met_INNET__c;
        if(insuranceVerification2.DED_Apply_to_OOP_INNET__c != null)
            secondaryNotes = secondaryNotes +',\nIN NET DED apply to OOP : '+insuranceVerification2.DED_Apply_to_OOP_INNET__c;
        if(insuranceVerification2.Individual_or_Family_INNET__c != null)
            secondaryNotes = secondaryNotes +',\nIN NET Individual/Family : '+insuranceVerification2.Individual_or_Family_INNET__c;
        if(insuranceVerification2.Detox_Benefits_Covered_INNET__c != null)
            secondaryNotes = secondaryNotes +',\nDetox Coverage % : '+insuranceVerification2.Detox_Benefits_Covered_INNET__c;
        if(insuranceVerification2.Detox_Benefits_Max_Per_Day_INNET__c != null)
            secondaryNotes = secondaryNotes +',\nDetox Max $ per day : '+insuranceVerification2.Detox_Benefits_Max_Per_Day_INNET__c;
        if(insuranceVerification2.Residential_Benefits_Covered_INNET__c != null)
            secondaryNotes = secondaryNotes +',\nRTC Coverage % : '+insuranceVerification2.Residential_Benefits_Covered_INNET__c;
        if(insuranceVerification2.Residential_Benefits_Max_Per_Day_INNET__c != null)
            secondaryNotes = secondaryNotes +',\nRTC Max $ per day : '+insuranceVerification2.Residential_Benefits_Max_Per_Day_INNET__c;
        if(insuranceVerification2.Part_Hospital_Covered_INNET__c != null)
            secondaryNotes = secondaryNotes +',\nPHP Coverage % : '+insuranceVerification2.Part_Hospital_Covered_INNET__c;
        if(insuranceVerification2.Part_Hospital_Max_Per_Day_INNET__c != null)
            secondaryNotes = secondaryNotes +',\nPHP Max $ per day : '+insuranceVerification2.Part_Hospital_Max_Per_Day_INNET__c;
        if(insuranceVerification2.IOP_Covered_INNET__c != null)
            secondaryNotes = secondaryNotes +',\nIOP Coverage % : '+insuranceVerification2.IOP_Covered_INNET__c;
        if(insuranceVerification2.IOP_Max_Per_Day_INNET__c != null)
            secondaryNotes = secondaryNotes +',\nIOP Max $ per day : '+insuranceVerification2.IOP_Max_Per_Day_INNET__c;
        if(insuranceVerification2.OP_Covered_INNET__c != null)
            secondaryNotes = secondaryNotes +',\nOP Coverage % : '+insuranceVerification2.OP_Covered_INNET__c;
        if(insuranceVerification2.OP_Max_Per_Day_INNET__c != null)
            secondaryNotes = secondaryNotes +',\nOP Max $ per day : '+insuranceVerification2.OP_Max_Per_Day_INNET__c;    
            
        if(insuranceVerification2.Detox_Benefits_Covered__c != null || insuranceVerification2.Residential_Benefits_Covered__c != null || insuranceVerification2.Part_Hospital_Covered__c != null ||  insuranceVerification2.IOP_Covered__c != null || insuranceVerification2.OP_Covered__c != null)
            secondaryNotes = secondaryNotes +',\nOUT OF NETWORK BENEFITS'; 
        if(insuranceVerification2.Substance_Abuse_DED__c != null)
            secondaryNotes = secondaryNotes + ',\nOON DED : '+insuranceVerification2.Substance_Abuse_DED__c;
        if(insuranceVerification2.Substance_Abuse_DED_met__c != null)
            secondaryNotes = secondaryNotes +',\nOON DED met : '+insuranceVerification2.Substance_Abuse_DED_met__c;
        if(insuranceVerification2.Substance_Abuse_OOP__c != null)
            secondaryNotes = secondaryNotes +',\nOON OOP : '+insuranceVerification2.Substance_Abuse_OOP__c;
        if(insuranceVerification2.Substance_Abuse_OOP_met__c != null)
            secondaryNotes = secondaryNotes +',\nOON OOP Met : '+insuranceVerification2.Substance_Abuse_OOP_met__c;
        if(insuranceVerification2.Substance_Abuse_DED_Apply_to_OOP__c != null)
            secondaryNotes = secondaryNotes +',\nOON DED apply to OOP : '+insuranceVerification2.Substance_Abuse_DED_Apply_to_OOP__c;
        if(insuranceVerification2.Substance_Abuse_Individual_or_Family__c != null)
            secondaryNotes = secondaryNotes +',\nOON Individual/Family : '+insuranceVerification2.Substance_Abuse_Individual_or_Family__c;
        if(insuranceVerification2.Detox_Benefits_Covered__c != null)
            secondaryNotes = secondaryNotes +',\nDetox Coverage % : '+insuranceVerification2.Detox_Benefits_Covered__c;
        if(insuranceVerification2.Detox_Benefits_Max_Per_Day__c != null)
            secondaryNotes = secondaryNotes +',\nDetox Max $ per day : '+insuranceVerification2.Detox_Benefits_Max_Per_Day__c;
        if(insuranceVerification2.Residential_Benefits_Covered__c != null)
            secondaryNotes = secondaryNotes +',\nRTC Coverage % : '+insuranceVerification2.Residential_Benefits_Covered__c;
        if(insuranceVerification2.Residential_Benefits_Max_Per_Day__c != null)
            secondaryNotes = secondaryNotes +',\nRTC Max $ per day : '+insuranceVerification2.Residential_Benefits_Max_Per_Day__c;
        if(insuranceVerification2.Part_Hospital_Covered__c != null)
            secondaryNotes = secondaryNotes +',\nPHP Coverage % : '+insuranceVerification2.Part_Hospital_Covered__c;
        if(insuranceVerification2.Part_Hospital_Max_Per_Day__c != null)
            secondaryNotes = secondaryNotes +',\nPHP Max $ per day : '+insuranceVerification2.Part_Hospital_Max_Per_Day__c;
        if(insuranceVerification2.IOP_Covered__c != null)
            secondaryNotes = secondaryNotes +',\nIOP Coverage % : '+insuranceVerification2.IOP_Covered__c;
        if(insuranceVerification2.IOP_Max_Per_Day__c != null)
            secondaryNotes = secondaryNotes +',\nIOP Max $ per day : '+insuranceVerification2.IOP_Max_Per_Day__c;
        if(insuranceVerification2.OP_Covered__c != null)
            secondaryNotes = secondaryNotes +',\nOP Coverage % : '+insuranceVerification2.OP_Covered__c;
        if(insuranceVerification2.OP_Max_Per_Day__c != null)
            secondaryNotes = secondaryNotes +',\nOP Max $ per day : '+insuranceVerification2.OP_Max_Per_Day__c;
            
                //secondaryNotes = '(Substance Abuse)\n Insurance Policy# : '+insuranceInformation2.Insurance_Policy__c+'\nEffective Date : '+insuranceVerification2.Effective_Date__c+',\nTermination Date : '+insuranceVerification2.Termination_Date__c+',\n Calendar/Plan Year : '+insuranceVerification2.Calendar_Plan_Year__c+ ',\nDed : '+insuranceVerification2.Substance_Abuse_DED__c+',\nDed Met : '+insuranceVerification2.Substance_Abuse_DED_met__c+',\nOOP : '+insuranceVerification2.Substance_Abuse_OOP__c+',\nOOP Met : '+insuranceVerification2.Substance_Abuse_OOP_met__c+',\nDED apply to OOP : '+insuranceVerification2.Substance_Abuse_DED_Apply_to_OOP__c+',\nIndividual/Family : '+insuranceVerification2.Substance_Abuse_Individual_or_Family__c+',\nRate Type : '+insuranceVerification2.Rate_Type__c+',\n% Covered : '+insuranceVerification2.Covered__c+',\nState License Accepted : '+insuranceVerification2.State_Lic_Accepted__c+',\nJCAHO/CARF Req (Levels) : '+insuranceVerification2.JCAHO_CARF_Req_Levels__c+
                  //                      ',\nPolicy Exclusions : '+insuranceVerification2.Policy_Exclusions__c+',\nOut of State Restrictions : '+insuranceVerification2.Out_of_State_Restrictions__c+',\nAssignment of Benefits Accepted : '+insuranceVerification2.Assignment_of_Benefits_Accepted__c+',\n 67COB on File : '+insuranceVerification2.COB_on_File__c+',\nDetox Coverage % : '+insuranceVerification2.Detox_Benefits_Covered__c+',\nDetox Max $ per day : '+insuranceVerification2.Detox_Benefits_Max_Per_Day__c+',\nRTC Coverage % : '+insuranceVerification2.Residential_Benefits_Covered__c+',\nRTC Max $ per day : '+insuranceVerification2.Residential_Benefits_Max_Per_Day__c+',\nPHP Coverage % : '+insuranceVerification2.Part_Hospital_Covered__c+',\nPHP Max $ per day : '+insuranceVerification2.Part_Hospital_Max_Per_Day__c+',\nIOP Coverage % : '+insuranceVerification2.IOP_Covered__c+',\nIOP Max $ per day : '+insuranceVerification2.IOP_Max_Per_Day__c+
                    //                    ',\nOP Coverage % : '+insuranceVerification2.OP_Covered__c+',\nOP Max $ per day : '+insuranceVerification2.OP_Max_Per_Day__c+'\nCarve Out for Behavioral Health : '+insuranceVerification2.Carve_Out_for_Behavioral_Health__c+'\n Policy ID Number : '+insuranceInformation2.Insurance_Policy__c.substring(0,2)+'\nEmployer : '+insuranceInformation2.Employer__c+'\nAdditional Notes : '+insuranceVerification2.Additional_Notes__c;
            
            
           if(insuranceInformation1.Insurance_Status__c != null && insuranceInformation1.Insurance_Provider__c != null && insuranceInformation2.Insurance_Status__c != null){
               
               
                Opportunity tempOpp = new Opportunity(id=opp.id, VOB_Status__c = 'Completed', Insurance_Verified_By__c = UserInfo.getUserId(), 
                                                      Insurance_Verified_Time_Stamp__c = dateTime.Now(), VOB_Completed__c = dateTime.Now(),
                                                      Insurance_Provider__c = insuranceInformation1.Insurance_Provider__c, Insurance_Notes__c = primaryNotes+secondaryNotes,
                                                      Client_DOB__c = oppInfo.client_dob__c, Name= oppInfo.Name,
                                                     Carve_Out_for_Behavioral_Health__c = insuranceVerification1.Carve_Out_for_Behavioral_Health__c, Carve_Out_Phone_Number__c = insuranceVerification1.Carve_Out_Phone_Number__c,
                                                     Carve_Out_Policy_Number__c = insuranceVerification1.Carve_Out_Policy_Number__c, Insurance_Policy__c = insuranceInformation1.Insurance_Policy__c,
                                                     Covered__c = insuranceVerification1.Covered__c, Month_to_Month__c = insuranceVerification1.Month_to_Month__c,
                                                     Will_Plan_Terminate_when_Client_Turns_26__c = insuranceVerification1.Will_Plan_Terminate_when_Client_Turns_26__c,
                                                     Cobra__c = insuranceVerification1.Cobra__c, COB_on_File__c = insuranceVerification1.COB_on_File__c,
                                                     Substance_Abuse_Copay_Admit_Fee__c = insuranceVerification1.Substance_Abuse_Copay_Admit_Fee__c,
                                                     Substance_Abuse_DED_Apply_to_OOP__c = insuranceVerification1.Substance_Abuse_DED_Apply_to_OOP__c,
                                                     Substance_Abuse_Individual_or_Family__c = insuranceVerification1.Substance_Abuse_Individual_or_Family__c,
                                                     State_Lic_Accepted__c = insuranceVerification1.State_Lic_Accepted__c,
                                                     JCAHO_CARF_Req_Levels__c = insuranceVerification1.JCAHO_CARF_Req_Levels__c,
                                                     Free_Standing__c = insuranceVerification1.Free_Standing_Facility__c,
                                                     Usual_and_Customary__c = insuranceVerification1.Rate_Type__c,
                                                     Assignment_of_Benefits__c = insuranceVerification1.Assignment_of_Benefits_Accepted__c,
                                                     OON_Deductible__c = insuranceVerification1.Substance_Abuse_DED__c,
                                                     OON_Deductible_Met__c = insuranceVerification1.Substance_Abuse_DED_met__c,
                                                     OON_OOP_Max__c = insuranceVerification1.Substance_Abuse_OOP__c,
                                                     OON_OOP_Met__c = insuranceVerification1.Substance_Abuse_OOP_met__c,
                                                     Deductible__c   = insuranceVerification1.DED_INNET__c,
                                                     Deductible_Met__c = insuranceVerification1.DED_met_INNET__c,
                                                     OOP_Max__c = insuranceVerification1.OOP_INNET__c,
                                                     OOP_Met__c = insuranceVerification1.OOP_met_INNET__c);
              LstOppUpdate.add(tempOpp );
            }
            
        }
        }
        
        }
        
         system.debug('Final List'+ LstOppUpdate);

        if(LstOppUpdate.size()>0){
            system.debug('Final List'+ LstOppUpdate);
             update LstOppUpdate;}
         
     
     
     }


}