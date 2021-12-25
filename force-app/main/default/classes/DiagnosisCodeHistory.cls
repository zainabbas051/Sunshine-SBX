//Test Class : DiagnosisCodeHistory_Test
public class DiagnosisCodeHistory {
    
    public string ClientId {get; set;}
    public string CeID {get; set;}
    public string allergies {get; set;}
    
    public Client_Chart__c Client {get; set;}
    
    
    public list<DiagnosisWrap> lstWrapperHistory {get; set;}
    
    public DiagnosisCodeHistory()
    {
        ClientId = ApexPages.CurrentPage().getParameters().get('ID');
        String clientRecordType = ApexPages.CurrentPage().getParameters().get('rt');
        CeID = ApexPages.CurrentPage().getParameters().get('ceId')!=null? ApexPages.CurrentPage().getParameters().get('ceId') : null;
        lstWrapperHistory = new list<DiagnosisWrap>();
        Client = new Client_Chart__c();
        allergies = '';
        
        if(ClientId != null)
        {
            Client = [select id, Name, Age__c, DOB__c, Medical_Record_Number__c, Diagnosis_Code__c from Client_Chart__c where id=: ClientId];
            
            for(Allergies__c alg:[select Allergen__c from Allergies__c where Client_Chart__c =: ClientId])
            {
                allergies+= alg.Allergen__c + ',';
            }
            allergies = allergies.removeEnd(',');
            
            for(Tx_and_D_C_Plans__c tx:[select id, recordtype.Name,lastmodifiedDate, Diagnosis__c, Presenting_Problem__c, recordtypeId from Tx_and_D_C_Plans__c where Client_Chart__c =:ClientId
                                                AND (recordtype.Name = 'Discharge Plan' OR recordtype.Name = 'Detox Treatment Plan')])
            {
                if(tx.recordtype.Name == 'Discharge Plan' && tx.Diagnosis__c != null && !string.isBlank(tx.Diagnosis__c))
                    lstWrapperHistory.add(new DiagnosisWrap(ClientId, tx.Diagnosis__c, date.valueOf(tx.lastmodifiedDate), tx.id, 'Tx_and_D_C_Plans__c', tx.recordtype.Name, tx.recordtypeId, clientRecordType));
                else if(tx.recordtype.Name == 'Detox Treatment Plan' && tx.Presenting_Problem__c != null && !string.isBlank(tx.Presenting_Problem__c))
                    lstWrapperHistory.add(new DiagnosisWrap(ClientId, tx.Presenting_Problem__c, date.valueOf(tx.lastmodifiedDate), tx.id, 'Tx_and_D_C_Plans__c', tx.recordtype.Name, tx.recordtypeId, clientRecordType));
            }
            
            for(Clinical_Evaluation__c ce:[select id, recordtype.Name,lastmodifiedDate, Diagnosis_Code__c, recordtypeId from Clinical_Evaluation__c where Client_Chart__c =:ClientId
                                                    AND recordtype.Name ='Phsych Evaluation' ])
            {
                //AND id!=:CeID
                if(ce.Diagnosis_Code__c != null && !string.isBlank(ce.Diagnosis_Code__c))
                    lstWrapperHistory.add(new DiagnosisWrap(ClientId, ce.Diagnosis_Code__c, date.valueOf(ce.lastmodifiedDate), ce.id, 'Clinical_Evaluation__c', ce.recordtype.Name, ce.recordtypeId, clientRecordType));
            }
            
            for(Clinical_Evaluation_3__c ce3:[select id, recordtype.Name,lastmodifiedDate, HP_Diagnosis_Code__c, recordtypeId from Clinical_Evaluation_3__c where Client_Chart__c =:ClientId
                                                        AND (recordtype.Name ='History And Physical' or recordtype.Name ='Phsych Evaluation') ])
            {
                //AND id!=:CeID
                if(ce3.HP_Diagnosis_Code__c != null && !string.isBlank(ce3.HP_Diagnosis_Code__c))
                    lstWrapperHistory.add(new DiagnosisWrap(ClientId, ce3.HP_Diagnosis_Code__c, date.valueOf(ce3.lastmodifiedDate), ce3.id, 'Clinical_Evaluation_3__c', ce3.recordtype.Name, ce3.recordtypeId, clientRecordType));
            }
            
            for(Medical__c med:[select id, recordtype.Name,lastmodifiedDate, PNP_Diagnosis_Code_Axis_I__c, recordtypeId from Medical__c where Client_Chart__c =:ClientId
                                                        AND recordtype.Name ='Psychiatric Progress Notes'])
            {
                if(med.PNP_Diagnosis_Code_Axis_I__c != null && !string.isBlank(med.PNP_Diagnosis_Code_Axis_I__c))
                    lstWrapperHistory.add(new DiagnosisWrap(ClientId, med.PNP_Diagnosis_Code_Axis_I__c, date.valueOf(med.lastmodifiedDate), med.id, 'Medical__c', med.recordtype.Name, med.recordtypeId, clientRecordType));
            }
            
            lstWrapperHistory = BubbleSort(lstWrapperHistory,'desc');
        }
        else
        {
            Apexpages.Message errMsg = new Apexpages.Message(ApexPages.Severity.ERROR,'Client Chart ID(cid) parameter missing in URL.');
            ApexPages.addMessage(errMsg);
        }
    }

    public List<DiagnosisWrap> BubbleSort(List<DiagnosisWrap> dwList, string sortBy){
        
        integer n = dwList.size();
        for (integer i = 0; i < n-1; i++)
        {      
            for (integer j = 0; j < n-i-1; j++)
            {   
                Date d1 = dwList[j].lastUpdated;
                Date d2 = dwList[j+1].lastUpdated;
                if(sortBy.toLowerCase() == 'desc')
                {
                    if (d1 < d2)
                    {
                        // swap temp and arr[i]
                        DiagnosisWrap temp = dwList[j];
                        dwList[j] = dwList[j+1];
                        dwList[j+1] = temp;
                    }    
                }
                else if(sortBy.toLowerCase() == 'asc')
                {
                    if (d1 > d2)
                    {
                        // swap temp and arr[i]
                        DiagnosisWrap temp = dwList[j];
                        dwList[j] = dwList[j+1];
                        dwList[j+1] = temp;
                    }    
                }
                
            }
        }

        return dwList;
    }
    
    
    public class DiagnosisWrap
    {
        public string diagnosisCode {get; set;}
        public date lastUpdated {get; set;}
        public string recordId {get; set;}
        public string ObjectName {get; set;}
        public string RecordtypeName {get; set;}
        public string RecordTypeId {get;set;}
        public string hrefString {get;set;}
        public string DWClientId {get;set;}
        
        public DiagnosisWrap(string ClientId, string diagnosisCode, date lastUpdated, string recordId, string ObjectName, string RecordtypeName, string RecordTypeId,string clientRecordType)
        {
            this.diagnosisCode = diagnosisCode;
            this.lastUpdated = lastUpdated;
            this.recordId = recordId;
            this.ObjectName = ObjectName;
            this.RecordtypeName = RecordtypeName;
            this.RecordTypeId = RecordTypeId;
            
            if(RecordtypeName == 'History And Physical')
                this.hrefString = '/apex/CE_HP2?ID='+ClientId +'&ceId='+recordId+'&type='+RecordtypeName+'&rt='+clientRecordType;
            else if(RecordtypeName == 'Phsych Evaluation')
                this.hrefString = '/apex/PsychEvaluation?ID='+ClientId +'&ceId='+recordId+'&rt='+clientRecordType;
            else if(RecordtypeName == 'Discharge Plan' || RecordtypeName == 'Detox Treatment Plan')
                this.hrefString = '/apex/TxDcDetailPage?ID='+ ClientId +'&TXDX='+recordId+'&rt='+clientRecordType;
            else if(RecordtypeName == 'Psychiatric Progress Notes')
                this.hrefString = '/apex/MedicalHomeEditPage?ID='+ ClientId +'&mcid='+recordId+'&rtid='+RecordTypeId+'&editValue=0&rt='+clientRecordType;

            
        }
        
        
    }

}