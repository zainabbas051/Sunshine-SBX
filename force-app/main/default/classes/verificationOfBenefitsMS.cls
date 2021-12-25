//Test Class : verificationOfBenefitsMSTest
public with sharing class verificationOfBenefitsMS{
    public List<Insurance_Information__c> insuranceInformationList{get;set;}
    Public opportunity opp;
    Public static string vobRequestId;
    
    Public Insurance_Verification__c insuranceVerification1{
        get{
            if(insuranceVerification1 == null)
                insuranceVerification1 = new Insurance_Verification__c();
            return insuranceVerification1;
        }
        set;
    }
    Public Insurance_Verification__c insuranceVerification2{
        get{
            if(insuranceVerification2== null)
                insuranceVerification2= new Insurance_Verification__c();
            return insuranceVerification2;
        }
        set;
    }
    
    Public opportunity oppInfo{
        get{
            if(oppInfo == null)
                oppInfo = new Opportunity();
            return oppInfo;
        }
        set;
    }
    
    Public Insurance_Information__c insuranceInformation1{
        get{
            if(insuranceInformation1 == null)
                insuranceInformation1 = new Insurance_Information__c();
            
            return insuranceInformation1;
        }
        set;
    }
    Public Insurance_Information__c insuranceInformation2{
        get{
            if(insuranceInformation2== null)
                insuranceInformation2= new Insurance_Information__c();
            
            return insuranceInformation2;
        }
        set;
    }
    
    public boolean primaryInsuranceReadOnly{get;set;}
    public boolean primaryInsuranceVerificationReadOnly{get;set;}
    public boolean secondaryInsuranceReadOnly{get;set;}
    public boolean secondaryInsuranceVerificationReadOnly{get;set;}
    
    public boolean readOnly{get;set;}
    
    public boolean vobComplete{get;set;}
    
    public boolean displayPrimary{get;set;}
    public boolean displaySecondary{get;set;}
    
    public verificationOfBenefitsMS(){
        
        String oppId = ApexPages.CurrentPage().GetParameters().get('oppId');
        loadData(oppId);
    }
    
    public void loadData(Id oppId){
        
        opp = [select id, Latest_VOB_Request__c, Latest_VOB_Request__r.VOB_Request_Status__c, Name, Owner.MobilePhone, Owner.name, insurance_provider__c, client_dob__c from Opportunity where id=: oppId];
        
        oppInfo.Client_DOB__c = opp.client_dob__c;
        oppInfo.Insurance_Provider__c = opp.Insurance_Provider__c;
        oppInfo.Name = opp.Name;
        system.debug('oppinfor Insurance Provider:::::'+oppInfo.Insurance_Provider__c);
        vobRequestId = ApexPages.CurrentPage().GetParameters().get('vobId');
        system.debug('vobRequestId :::'+vobRequestId);
        if(opp.Latest_VOB_Request__r.VOB_Request_Status__c=='In-Progress')
            vobComplete = False;
        if(opp.Latest_VOB_Request__r.VOB_Request_Status__c=='Complete')
            vobComplete = True;
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
        
        system.debug('insuranceInformationQueryString ::::'+insuranceInformationQueryString);
         insuranceInformationList = Database.query(insuranceInformationQueryString);
        List<Insurance_Verification__c> insuranceVerificationList = Database.query(insuranceVerificationQueryString);
        
        
        for(Insurance_Information__c ii : insuranceInformationList){
            if(ii.Insurance_Status__c == null && displayPrimary == null){
                insuranceInformation1 = ii;
                displayPrimary = True;
                primaryInsuranceReadOnly = True;
                primaryInsuranceVerificationReadOnly = True;
            }else if(ii.Insurance_Status__c == null && displayPrimary == True){
                insuranceInformation2 = ii;
                displaySecondary = True;
                 secondaryInsuranceReadOnly = True;
                secondaryInsuranceVerificationReadOnly = True;
           
            }else if(ii.Insurance_Status__c == 'Primary'){
                insuranceInformation1 = ii;
                displayPrimary = True;
                primaryInsuranceReadOnly = True;
                primaryInsuranceVerificationReadOnly = True;
            }else if(ii.Insurance_Status__c == 'Secondary'){
                insuranceInformation2 = ii;
                displaySecondary = True;
                secondaryInsuranceReadOnly = True;
                secondaryInsuranceVerificationReadOnly = True;
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
            
                    system.debug('Insurance1Provider45++++++:::'+  insuranceInformation1.Insurance_Provider__c);
                    system.debug('InsuranceID:::::'+insuranceInformation1.id);
                                        system.debug('Insurancestatus:::::'+insuranceInformation1.Insurance_Status__c );


        
        //primaryInsuranceReadOnly =  True;
        //primaryInsuranceVerificationReadOnly = True;
    }
    
    public void initatePrimaryInsurance(){
        displayPrimary = True;
        primaryInsuranceReadOnly =  True;
        primaryInsuranceVerificationReadOnly = True;
    }
    
    public void initiateSecondaryInsurance(){
        displaySecondary = True;
        secondaryInsuranceReadOnly =  True;
        secondaryInsuranceVerificationReadOnly = True;
    }
    
    public void editPrimaryInsurance(){
        primaryInsuranceReadOnly = False;
    }
    
    public void savePrimaryInsurance(){
        vobRequestId = ApexPages.CurrentPage().GetParameters().get('vobId');
            system.debug('vobRequestId :::'+vobRequestId);
        if(insuranceInformation1.Opportunity__c == Null)
            insuranceInformation1.Opportunity__c=opp.id;
        if(insuranceInformation1.VOB_Request__c == Null)
            insuranceInformation1.VOB_Request__c = vobRequestId;
        if(oppInfo.Insurance_Provider__c!=null)
            insuranceInformation1.Insurance_Provider__c=oppInfo.Insurance_Provider__c;
        if(insuranceInformation1.id==null)
            insert insuranceInformation1;
        else
            update insuranceInformation1;
        if(insuranceInformation1.Insurance_Status__c == 'Secondary' ){
            if(insuranceInformation2.Insurance_Status__c == 'Secondary' && insuranceInformation2.id !=null){
                Insurance_Information__c tempII= insuranceInformation2;
                    tempII.Insurance_Status__c = 'Primary';
                    Update TempII;
                Insurance_Verification__c  TempIV=insuranceVerification2;
                insuranceInformation2 = insuranceInformation1;
                insuranceVerification2 = insuranceVerification1;
                insuranceVerification1 = tempIV;
            insuranceInformation1 = TempII;
            displayPrimary = True;
            displaySecondary = True;
            
            }
           
            else if (insuranceInformation2.id ==null){
            insuranceInformation2 = insuranceInformation1;
            insuranceVerification2 = insuranceVerification1;
            insuranceVerification1 = null;
            insuranceInformation1 = null;
            displayPrimary = False;
            displaySecondary = True;
            //SecondaryInsuranceReadOnly =true;
            
            }
            
             else if(insuranceInformation2.Insurance_Status__c == null && insuranceInformation2.id !=null){
            Insurance_Information__c tempII= insuranceInformation2;
               
                Insurance_Verification__c  TempIV=insuranceVerification2;
                insuranceInformation2 = insuranceInformation1;
                insuranceVerification2 = insuranceVerification1;
                insuranceVerification1 = tempIV;
            insuranceInformation1 = TempII;
            displayPrimary = True;
            displaySecondary = True;
            
            
            
        } 
            
        }  
        
                
        primaryInsuranceReadOnly = True;
        
    }
    
    public void editPrimaryInsuranceVerification(){
        primaryInsuranceVerificationReadOnly = False;
    }
    
    public void savePrimaryInsuranceVerification(){
        vobRequestId = ApexPages.CurrentPage().GetParameters().get('vobId');
            system.debug('vobRequestId :::'+vobRequestId);
        if(insuranceVerification1.Opportunity__c == Null)
            insuranceVerification1.Opportunity__c=opp.id;
        if(insuranceVerification1.VOB_Request__c == Null)
            insuranceVerification1.VOB_Request__c = vobRequestId;
        if(insuranceVerification1.Related_Insurance_Information__c == null)
            insuranceVerification1.Related_Insurance_Information__c = insuranceInformation1.id;
        if(insuranceVerification1.id == null)
            insert insuranceVerification1;
        else
            update insuranceVerification1;
        
        primaryInsuranceVerificationReadOnly = True;
        
        
    }
    
    public void editSecondaryInsurance(){
        secondaryInsuranceReadOnly = False;
    }
    
    public void saveSecondaryInsurance(){
        vobRequestId = ApexPages.CurrentPage().GetParameters().get('vobId');
        system.debug('vobRequestId :::'+vobRequestId);
        if(insuranceInformation2.Opportunity__c == Null)
            insuranceInformation2.Opportunity__c=opp.id;
        if(insuranceInformation2.VOB_Request__c == Null)
            insuranceInformation2.VOB_Request__c = vobRequestId;
        if(oppInfo.Insurance_Provider__c!=null)
            insuranceInformation2.Insurance_Provider__c=oppInfo.Insurance_Provider__c;
       
        if(insuranceInformation2.id==null)
            insert insuranceInformation2;
        else
            update insuranceInformation2;
        if(insuranceInformation2.Insurance_Status__c == 'Primary' ){
            if(insuranceInformation1.Insurance_Status__c == 'Primary' && insuranceInformation1.id !=null){
                Insurance_Information__c tempII= insuranceInformation1;
                    tempII.Insurance_Status__c = 'Secondary';
                    Update TempII;
                Insurance_Verification__c  TempIV=insuranceVerification1;
                insuranceInformation1 = insuranceInformation2;
                insuranceVerification1 = insuranceVerification2;
                insuranceVerification2 = tempIV;
            insuranceInformation2 = TempII;
            displayPrimary = True;
            displayPrimary = True;
            
            }
           
            else if (insuranceInformation1.id ==null){
            insuranceInformation1 = insuranceInformation2;
            insuranceVerification1 = insuranceVerification2;
            insuranceVerification2 = null;
            insuranceInformation2 = null;
            displayPrimary = False;
            displayPrimary = True;
            
            }
            
             else if(insuranceInformation1.Insurance_Status__c == null && insuranceInformation1.id !=null){
            Insurance_Information__c tempII= insuranceInformation1;
               
                Insurance_Verification__c  TempIV=insuranceVerification1;
                insuranceInformation1 = insuranceInformation2;
                insuranceVerification1 = insuranceVerification2;
                insuranceVerification2 = tempIV;
            insuranceInformation2 = TempII;
            displayPrimary = True;
            displayPrimary = True;
            
            
            
        } 
            
        }  
              
        secondaryInsuranceReadOnly = True;
        
    }
    
    public void editSecondaryInsuranceVerification(){
        secondaryInsuranceVerificationReadOnly = False;
    }
    
    public void saveSecondaryInsuranceVerification(){
        vobRequestId = ApexPages.CurrentPage().GetParameters().get('vobId');
            system.debug('vobRequestId :::'+vobRequestId);
        if(insuranceVerification2.Opportunity__c == Null)
            insuranceVerification2.Opportunity__c=opp.id;
        if(insuranceVerification2.VOB_Request__c == Null)
            insuranceVerification2.VOB_Request__c = vobRequestId;
        if(insuranceVerification2.Related_Insurance_Information__c == null)
            insuranceVerification2.Related_Insurance_Information__c = insuranceInformation2.id;
        if(insuranceVerification2.id == null)
            insert insuranceVerification2;
        else
            update insuranceVerification2;
        
        secondaryInsuranceVerificationReadOnly = True;
    }
    
    public pageReference completeVOB(){
        system.debug('insuranceVerification1::::'+insuranceVerification1);
        system.debug('insuranceVerification2:::'+insuranceVerification2);
        system.debug('displayPrimary :::::'+displayPrimary );
        system.debug('displaySecondary ::::'+displaySecondary );
        system.debug('Insurance1Provider:::'+  insuranceInformation1.Insurance_Provider__c);
        if(displayPrimary == True){
            savePrimaryInsurance();
            savePrimaryInsuranceVerification();
        }
        if(displaySecondary == True){
            saveSecondaryInsurance();
            saveSecondaryInsuranceVerification();
        }
    
        system.debug('displayPrimary11 :::::'+displayPrimary );
        system.debug('displaySecondary11 ::::'+displaySecondary );
       
        boolean complete=True;
        vobRequestId = ApexPages.CurrentPage().GetParameters().get('vobId');
       
        if(displayPrimary == True && displaySecondary==False){
        String primaryNotes='';
        //if(!Test.isRunningTest()){
         system.debug('Is 1st if works');   
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
        if(insuranceVerification1.DED_Apply_to_OOP_INNET__c != false)
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
        if(insuranceVerification1.Substance_Abuse_DED_Apply_to_OOP__c != false)
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
            
        //}
            system.debug('display primary');
            system.debug('primary insurance status ::'+insuranceInformation1.Insurance_Status__c);
                    system.debug('oppinfor Insurance Provider1:::::'+oppInfo.Insurance_Provider__c);

            if(insuranceInformation1.Insurance_Status__c != null && insuranceInformation1.Insurance_Provider__c != null){
                system.debug('point update');
                VOB_Request__c vobRequest = new VOB_Request__c(id = vobRequestId, VOB_Request_Status__c = 'Complete',
                                                               Date_Time_Insurance_Verified__c = dateTime.Now(), Insurance_Verified_By__c = UserInfo.getUserId());
                update vobRequest;
                
               /* Opportunity tempOpp = new Opportunity(id = opp.id, VOB_Status__c= 'Completed', Insurance_Verified_By__c = UserInfo.getUserId(), 
                                                        Insurance_Verified_Time_Stamp__c = dateTime.Now(), VOB_Completed__c = dateTime.Now(),
                                                        Insurance_Provider__c = oppInfo.Insurance_Provider__c, Insurance_Notes__c = primaryNotes,
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
                                                     OON_OOP_Met__c = insuranceVerification1.Substance_Abuse_OOP_met__c);
                update tempOpp;*/
                insertChatter(primaryNotes, opp.id);

                
            }
            else{
                system.debug('point error');
                complete = False;
                if(insuranceInformation1.Insurance_Status__c == null)
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select the Insurance Status for atleast one insurance!!'));
                if(insuranceInformation1.Insurance_Provider__c == null)
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select the Insurance Provider for the Primary Insurance!!'));
            }
        }
        if(displayPrimary == True && displaySecondary==True){
                     system.debug('Is 2nd if works');   
                     
                     system.debug('insuranceInformation1 2nd works::'+insuranceInformation1);
                     system.debug('insuranceInformation2 2nd works::'+insuranceInformation2);

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
                
               
            system.debug('display primary');
            system.debug('primary insurance status ::'+insuranceInformation1.Insurance_Status__c);
            
                    system.debug('oppinfor Insurance Provider2:::::'+oppInfo.Insurance_Provider__c);

            if(insuranceInformation1.Insurance_Status__c != null && insuranceInformation1.Insurance_Provider__c != null && insuranceInformation2.Insurance_Provider__c != null && insuranceInformation2.Insurance_Status__c != null){
                system.debug('point update');
                VOB_Request__c vobRequest = new VOB_Request__c(id = vobRequestId, VOB_Request_Status__c = 'Complete', 
                                                                Date_Time_Insurance_Verified__c = dateTime.Now(), Insurance_Verified_By__c = UserInfo.getUserId());
                update vobRequest;
                             
                             system.debug('secondaryNotes:::' + secondaryNotes);
                             system.debug('primaryNotes+secondaryNotes::::'+primaryNotes+secondaryNotes);

                insertChatter(primaryNotes+secondaryNotes, opp.id);

            }
            else{
                system.debug('point error');
                complete = False;
                if(insuranceInformation1.Insurance_Status__c == null || insuranceInformation2.Insurance_Status__c == null)
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select the Insurance Status for atleast one insurance!!'));
                if(insuranceInformation1.Insurance_Provider__c == null || insuranceInformation2.Insurance_Provider__c == null)
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select the Insurance Provider for the Primary Insurance for atleast one insurance!!'));
            }
        }
        if(displayPrimary == False && displaySecondary==True){
            complete = False;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'A Primary Insurance Information is Needed to Complete VOB'));
        }
        if(displayPrimary == False && displaySecondary==False){
            complete = False;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Atleast One Insurance on File is Needed to complete the VOB'));
        }
        system.debug('complete ::'+complete);
        if(complete == True){
            vobComplete = True;
            String smsBody = 'The Verification of Benefits (VOB) for the Opportunity '+opp.Name+', has been completed by '+UserInfo.getName()+', on '+dateTime.Now();
            sendSMS(smsBody, opp.Owner.MobilePhone, opp.Owner.Name);
            insertChatter(smsBody, opp.id);
            pageReference pr = new pageReference('/'+opp.id);
            return pr;
        }
        
        
        return null;
    }
    
    public void sendSMS(String smsBody, String phoneNumber, String userName){
        
        if(phoneNumber != null && smsBody != null){
            //Uncomment Below This Line
            
            list<smagicinteract__smsMagic__c> lstSendSMS = new list<smagicinteract__smsMagic__c>();
            smagicinteract__smsMagic__c smsObjNewMS = new smagicinteract__smsMagic__c();
            smsObjNewMS.smagicinteract__PhoneNumber__c = phoneNumber;//Phone Number to which text is sent
            smsObjNewMS.smagicinteract__SMSText__c = smsBody;//Body of the SMS
            smsObjNewMS.smagicinteract__senderId__c = 'smsMagic';
            smsObjNewMS.smagicinteract__Name__c = userName;
            smsObjNewMS.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
            lstSendSMS.add(smsObjNewMS);
            
            if(lstSendSMS.size()>0){
                if(!Test.isRunningTest())
                    insert lstSendSMS;
            }
            
        }
        
    }
    
    public void insertChatter(String feedBody, String feedParentId){
        if(feedBody != null && feedParentId != null){
            FeedItem fi = new FeedItem();
            fi.Body = feedBody;
            fi.Type = 'AdvancedTextPost';
            fi.ParentId = feedParentId;
            insert fi;
        }
    }

}