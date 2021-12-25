public class PsychiatricProgressCtlr {
	
    public Medical__c med {get;set;} 
    public string clientId {get;set;}
    public string mcId {get;set;}
    public string rtId {get;set;}
    public boolean edit {get;set;}
	public list<string> Codes {get; set;}
    public list<SelectOption> listAllCodes {get; set;}
    
    
    public list<Order__c> listOfMeds {get; set;}
    
    public Client_Chart__c ClientChart {get;set;}
    public List<UtlizationReviewOrder__c> ListOfOrder{
        get;
        set;
    } 
    public PsychiatricProgressCtlr(){
        System.debug('medical on constructor: '+ med);
        edit = false;
        listOfMeds = new List<Order__c>();
        clientId = ApexPages.CurrentPage().getParameters().get('id');
        mcId= ApexPages.CurrentPage().getParameters().get('mcid');
        rtId = ApexPages.CurrentPage().getParameters().get('rtid');
        string editValue = ApexPages.CurrentPage().getParameters().get('editValue');
        if(editValue != null)
        {
            edit = editValue == '0' ? false: true;
        }
        
        List<Medical__c> medList = [Select Id,Name,Status__c,PPN_Present_Illness_History__c, PPN_Present_Illness_History_Desc__c,
                                    PPN_Sources_of_Information__c, PPN_Sources_of_Information_Other__c, PPN_Weight__c, 
                                    PPN_Appetite__c, PPN_Sleep__c, PPN_Energy__c, PPN_Relevant_Laboratory__c, PPN_Notes__c,
                                    LA_Notes_Comments__c, PPN_Appearance__c, PPN_Speech__c, PPN_Mood__c, PPN_Attitude__c,
                                    PPN_Affect__c, PPN_Thought_Content__c, PPN_Thought_Process__c, PPN_Hallucinations__c, 
                                    PPN_Orientated_X__c, PPN_Memory__c, PPN_Attention_Span__c, PPN_Realty_Testing__c,
                                    PPN_Insight_Judgement__c, PPN_Behavior__c, PPN_Motor__c,  PPN_Medication_Compliance__c, 
                                    MDF_Medication_Side_Effects__c , MDF_Medication_Side_Effects_None__c, PPN_MMSE_Score__c,
                                    PPN_Diagnosis_Code_Axis_II__c, PPN_Recomm_Treatment_Plan__c, PPN_RTP_Dose_Reduction__c,
                                    PPN_RTP_Medication_Changes__c, PPN_Patient_Informed_Consent__c, PPN_Responsible_Party__c,
                                    PPN_Explanation_of_Risks__c, PPN_Information_Shared__c, PPN_Recommended_Therapies__c,
                                    PPN_Recommended_Therapies_Other__c, PPN_Follow_Up__c, PPN_Follow_Up_Other__c,
                                    PPN_Hospitalize_due_to__c, PPN_Datetime__c, PPN_Foreign_Language__c, 
                                    Medication_List_Update_Time__c, PNP_Diagnosis_Code_Axis_I__c
                                    from Medical__c where Id=: mcId Limit 1];
        if(medList.size()>0)
        {
            med = medList[0];
            
            fillAllCodes();
            getExistingCodesFromCC();
            
            getAllMeds();
        }
        
        System.debug('edit flag on constructor: '+edit);
      
    }
    private void getExistingCodesFromCC(){
        
        Codes = new List<string>();
        
        if(med != null && med.PNP_Diagnosis_Code_Axis_I__c != null && med.Status__c == 'Closed')
        {
            for(string exstCode: med.PNP_Diagnosis_Code_Axis_I__c.split(';'))
            {
                Codes.add(exstCode);    
            }
        }
        else if(med.Status__c != 'Closed'){
        	List<Client_Chart__c> CCList = [Select Id,Name, Diagnosis_Code__c from Client_Chart__c where Id=:clientId Limit 1];
            ClientChart = new Client_Chart__c();
            if(CCList.size()>0)
            {
                ClientChart = CCList[0];
                if(ClientChart.Diagnosis_Code__c != null)
                {
                    med.PNP_Diagnosis_Code_Axis_I__c = ClientChart.Diagnosis_Code__c;
                    for(string exstCode: ClientChart.Diagnosis_Code__c.split(';'))
                    {
                        Codes.add(exstCode);    
                    }
                }
                
            }    
            
        }
        
    }
    private void fillAllCodes()
    {
        listAllCodes = new list<SelectOption>();
        List<DiagnosisCode__c> myCs = DiagnosisCode__c.getall().values();
        for(DiagnosisCode__c m : myCs){
            SelectOption option = new SelectOption((m.Name+' '+m.Description__c),(m.Name+' '+m.Description__c));
            listAllCodes.add(option);
        }
    }
    
    public void editPPNRecord() {
        edit = true;
        
        System.debug('medical on edit: '+ this.med);
		System.debug('edit flag on edit: '+edit);
    }
    
    public void SavePPNRecord() {
        edit = false;
        //med.PNP_Diagnosis_Code_Axis_I__c = String.join(Codes, ';');
        update this.med;
        
        ClientChart.Diagnosis_Code__c = med.PNP_Diagnosis_Code_Axis_I__c;
        update ClientChart;
        
       
        getExistingCodesFromCC();
    }
    
    public void SavePPNRecordQuick() {
        edit = true;
        //med.PNP_Diagnosis_Code_Axis_I__c = String.join(Codes, ';');
        update this.med;
        
        ClientChart.Diagnosis_Code__c = med.PNP_Diagnosis_Code_Axis_I__c;
        update ClientChart;
        
        
        
        getExistingCodesFromCC();
    }
    
    
   
    
    
    
    public void getAllMeds()
    {
        listOfMeds = [select id,Amount_per_Dosage__c,Client_Chart__c, createdDate ,Medical__c,Continue_on_Discharge__c,Discontinue_Date_Time__c,
                                Dosage_Form__c,Dose__c,Duration__c,End_Date__c,Frequency__c,Justification__c,Medicine__c,Medicine__r.Name,Order_By__c,
                                Order_Type__c,PRN__c,Requested_via__c,Route__c,Start_Date__c,Status__c,Taper__c,Taper__r.Name,Taper__r.Protocol__c,
                                Taper__r.Justification_Indication_Target__c,Via_cancelled_by__c,
                                Warnings__c from Order__c where Medical__c =: mcId];
        
        listOfMeds = [select id,Amount_per_Dosage__c,Client_Chart__c, createdDate ,Medical__c,Continue_on_Discharge__c,Discontinue_Date_Time__c,
                      Dosage_Form__c,Dose__c,Duration__c,End_Date__c,Frequency__c,Justification__c,Medicine__c,Medicine__r.Name,Order_By__c,
                      Order_Type__c,PRN__c,Requested_via__c,Route__c,Start_Date__c,Status__c,Taper__c,Taper__r.Name,Taper__r.Protocol__c,
                      Taper__r.Justification_Indication_Target__c,Via_cancelled_by__c,
                      Warnings__c from Order__c where Client_Chart__c =: clientId AND (Status__c = 'Active' OR Status__c = 'Under Review') ];
        
        system.debug('#listOfMeds'+listOfMeds);
        
    }
    
    public void updateMedications()
    {
        list<Order__c> listToUpdateMeds = new list<Order__c>();
        for(Order__c ord: [select id,Amount_per_Dosage__c,Client_Chart__c, createdDate ,Medical__c,Continue_on_Discharge__c,Discontinue_Date_Time__c,
                                Dosage_Form__c,Dose__c,Duration__c,End_Date__c,Frequency__c,Justification__c,Medicine__c,Medicine__r.Name,Order_By__c,
                                Order_Type__c,PRN__c,Requested_via__c,Route__c,Start_Date__c,Status__c,Taper__c,Taper__r.Name,Taper__r.Protocol__c,
                                Taper__r.Justification_Indication_Target__c,Via_cancelled_by__c,
                                Warnings__c from Order__c where Client_Chart__c =: clientID])
        {
            if(ord.Status__c == 'Inactive')
            {
                if(ord.Medical__c == mcId)
                {
                    ord.Medical__c = null;
                    listToUpdateMeds.add(ord);
                }
            }   
            
            if(ord.Status__c == 'Active')
            {
               	med.Medication_List_Update_Time__c = datetime.now();
                ord.Medical__c = mcId;
                listToUpdateMeds.add(ord);
            }
        }
        
        try
        {
            update listToUpdateMeds;
            update med;
            getAllMeds();
        }
        catch(exception e)
        {
            ApexPages.AddMessages(e);
        }
    }  
}