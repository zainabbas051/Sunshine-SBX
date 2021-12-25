public with sharing class MedicationRecordsController {

    id clientChartId;
    string rtparam;

    public List<TaperRecordWrapper> MedicationRecords {get; set;}
    public List<TaperRecordWrapper> DestructionRecords {get; set;}

    //Signature
    public string accessKeyId {get; set;}
    public string secretAccessKey {get; set;}
    public string AWSURL {get; set;}
    public string OrgName {get; set;}
    public string SunShineCenterName {get; set;}
    public string ClientName {get; set;}
    public string SelectedSignedOption {
        get;
        set;
    }

    public MedicationRecordsController() {

        clientChartId = ApexPages.CurrentPage().getParameters().get('id');
        rtparam = ApexPages.CurrentPage().getParameters().get('rt');

        // Signature Config
        accessKeyId = Constants.accessKeyId;
        OrgName = Constants.OrgName;
        AWSURL = 'http://freepu.s3.amazonaws.com/';
        secretAccessKey = Constants.secretAccessKey;

        Client_Chart__c ClientChartObj = [select id, Name, Treatment_Center__r.Name from Client_Chart__c where id = :clientChartId];
        SunShineCenterName = ClientChartObj.Treatment_Center__r.Name;
        ClientName = ClientChartObj.Name;


        LoadRecords('CentrallyStoredRecord');
        LoadRecords('DestructionRecord');
    }
     public PageReference backToMeds(){
        PageReference meds = new PageReference('/apex/MedsHomePage?id=' + clientChartId + '&rt=' + rtparam );
        meds.setRedirect(true);
        return meds;
    }

    // Medication Record
    public void LoadRecords(string recordType) {
        // Load centrally stored medications
        List<Taper_Line_Item__c> tempMedications = [select id, Name, Medicine__c, Instructions__c, ExpirationDate__c, Date_Received__c,RecordType__c,
                                 Date_Started__c, Pharmacy_Name__c, Prescribing_Physician__c, Status__c, Signature_Url__c,Signature_Url_2__c, Strength__c,Signed_By__c,Destruction_Date__c,
                                 Amount_to_Use_Per_Dosage_Form__c, Presciption_Number__c, No_of_Refills__c, Staff_Signed_User__c,Staff_Signed_User_2__c, Signed_Date__c,Signed_Date_2__c,Destruct_Medicine__c 
                                 from Taper_Line_Item__c where ClientChart__c = :clientChartId and RecordType__c = :recordType order by CreatedDate];

        List<TaperRecordWrapper> wrapperList = new List<TaperRecordWrapper>();
        TaperRecordWrapper wrapper;
        for (Integer i = 0; i < tempMedications.size(); i++) {
            wrapper = new TaperRecordWrapper(i, tempMedications.get(i));
            wrapperList.add(wrapper);
        }

        if (recordType == 'CentrallyStoredRecord') {
            MedicationRecords = new List<TaperRecordWrapper>();
            MedicationRecords.addAll(wrapperList);
        } else if (recordType == 'DestructionRecord') {
            DestructionRecords = new List<TaperRecordWrapper>();
            DestructionRecords.addAll(wrapperList);
        }
    }



    public void AddNewMedication() {
        string recordType = system.CurrentPageReference().getParameters().get('medicationRecordType');
        Taper_Line_Item__c item = new Taper_Line_Item__c();
        item.RecordType__c = recordType;
        item.Status__c = 'Open';
        if(recordType=='CentrallyStoredRecord')
        item.Signed_By__c='1BHT';
        else
        item.Signed_By__c='BHT';

        List<TaperRecordWrapper> records = GetRecords();
        Integer index = records.size();
        TaperRecordWrapper wrapper = new TaperRecordWrapper(index, item);
        wrapper.ChangeEditing(true);
        records.add(wrapper);
    }

    public void CopyToDestructMedication() {
        
        string index = system.CurrentPageReference().getParameters().get('medicationToDestruct');
        List<TaperRecordWrapper> recordsToDestruct = MedicationRecords;
        TaperRecordWrapper wrapperToDestruct = recordsToDestruct.get(Integer.valueOf(index));
        Taper_Line_Item__c itemToDestruct = wrapperToDestruct.TaperItem;
        Taper_Line_Item__c item = new Taper_Line_Item__c();
        item=itemToDestruct.clone();
        
        item.RecordType__c = 'DestructionRecord';
        item.Status__c = 'Open';
        item.Signed_By__c='BHT';
        item.Signed_User__c =null;
        item.Staff_Signed_User__c = null;
        item.Signed_Date__c = null;
        item.Signature_Url__c =null;
        item.Staff_Signed_User_2__c = null;
        item.Signed_Date_2__c = null;
        item.Signature_Url_2__c =null;
        upsert item;
        
        itemToDestruct.Destruct_Medicine__c=true;
        update itemToDestruct;
        
      /*  item.Medicine__c=itemToDestruct.Medicine__c;
        item.Strength__c=itemToDestruct.Strength__c;
        item.Amount_to_Use_Per_Dosage_Form__c=itemToDestruct.Amount_to_Use_Per_Dosage_Form__c;
        item.Instructions__c=itemToDestruct.Instructions__c;
        item.ExpirationDate__c=itemToDestruct.ExpirationDate__c;
        item.Date_Received__c=itemToDestruct.Date_Received__c;
        item.Date_Started__c=itemToDestruct.Date_Started__c;
        item.Prescribing_Physician__c=itemToDestruct.Prescribing_Physician__c;
        item.Presciption_Number__c=itemToDestruct.Presciption_Number__c;
        item.No_of_Refills__c=itemToDestruct.No_of_Refills__c;
        item.Pharmacy_Name__c=itemToDestruct.Pharmacy_Name__c; */
        List<TaperRecordWrapper> records = GetRecords();
        Integer indexNew = records.size();
        TaperRecordWrapper wrapper = new TaperRecordWrapper(indexNew, item);
       // wrapper.ChangeEditing(true);
        records.add(wrapper);
        
        
        
    }
    public void EditItem() {
        List<TaperRecordWrapper> records = GetRecords();
        string index = system.CurrentPageReference().getParameters().get('index');
        TaperRecordWrapper wrapper = records.get(Integer.valueOf(index));
        wrapper.ChangeEditing(true);
    }

    public void SaveTaperItem() {
        List<TaperRecordWrapper> records = GetRecords();
        string index = system.CurrentPageReference().getParameters().get('index');
        TaperRecordWrapper wrapper = records.get(Integer.valueOf(index));
        Taper_Line_Item__c itemToSave = wrapper.TaperItem;
        itemToSave.ClientChart__c = clientChartId;
        upsert itemToSave;

        string recordType = system.CurrentPageReference().getParameters().get('medicationRecordType');
        LoadRecords(recordType);
    }

    public void SaveSignature() {

        // saving signature in taper line item
        string signatureUrl = system.CurrentPageReference().getParameters().get('signatureUrl');
        string signedBy = system.CurrentPageReference().getParameters().get('signedBy');
        string index = system.CurrentPageReference().getParameters().get('index');
        List<TaperRecordWrapper> records = GetRecords();

        User u = [Select Name, title from User where ID = :UserInfo.getUserID() limit 1];
        TaperRecordWrapper wrapper = records.get(Integer.valueOf(index));
        Taper_Line_Item__c itemToSave = wrapper.TaperItem;
     
       
       
       if(itemToSave.RecordType__c=='DestructionRecord')
       {
        if(signedBy=='Behavioral Health Technician' || Test.isRunningTest())
        {
       
        itemToSave.Signed_By__c = 'OnlyStaff';
        itemToSave.Signed_User__c = UserInfo.getUserId();
        itemToSave.Staff_Signed_User__c = 'Staff Signed: ' + u.Name + ', ' + u.Title;
        itemToSave.Signed_Date__c = Datetime.now();
        itemToSave.Signature_Url__c = AWSURL + signatureUrl;
        
        }
        else if(signedBy=='Staff')
        {
           
        if(itemToSave.Staff_Signed_User__c==null)
        {
            itemToSave.Signed_By__c='1BHT';
        }
       
        itemToSave.Staff_Signed_User_2__c = 'Staff Signed: ' + u.Name + ', ' + u.Title;
        itemToSave.Signed_Date_2__c = Datetime.now();
        itemToSave.Signature_Url_2__c = AWSURL + signatureUrl;
        }
        if(itemToSave.Staff_Signed_User__c!=null && itemToSave.Staff_Signed_User_2__c!=null)
        {
            itemToSave.Signed_By__c = 'All';
            itemToSave.Status__c = 'Closed';
            
        }
   
       }
       else if (itemToSave.RecordType__c=='CentrallyStoredRecord')
       {
           
        itemToSave.Status__c = 'Closed';
        itemToSave.Signed_By__c = 'All';
        itemToSave.Staff_Signed_User__c = 'Staff Signed: ' + u.Name + ', ' + u.Title;
        itemToSave.Signed_Date__c = Datetime.now();
        itemToSave.Signature_Url__c = AWSURL + signatureUrl;
           
       }
        upsert itemToSave;
    }

    public List<TaperRecordWrapper> GetRecords() {
        string medicationRecordType = system.CurrentPageReference().getParameters().get('medicationRecordType');
        List<TaperRecordWrapper> records = medicationRecordType == 'CentrallyStoredRecord' ?
                                           MedicationRecords : DestructionRecords;
        return records;
    }
    
     

    public class TaperRecordWrapper {
        public Integer Index {get; set;}
        public Boolean IsEditing {get; private set;}
        public Taper_Line_Item__c TaperItem {get; set;}
        //public string SignatureDetail {get; set;}

        public TaperRecordWrapper(Integer index, Taper_Line_Item__c taper) {
            this.Index = index;
            this.TaperItem = taper;
            this.IsEditing = false;
            
            //DateTime dt = taper.Signed_Date__c;
            //string formattedDateTime = dt == null ? '' : dt.format('YYYY-MM-DD');
            //SignatureDetail = taper.Staff_Signed_User__c + ' ' + formattedDateTime;
        }

        public void ChangeEditing(Boolean edit) {
            IsEditing = TaperItem.Status__c == 'Open' && edit;
        }
        
       
    }

    //public class Utils {
        
    //}
}