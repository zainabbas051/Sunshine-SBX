/*
TestClass : MedicalConsultationViewCtrlTest
*/
public class MedicalConsultationViewCtrl
{
    public Medical__c medical {get;set;}
    public Client_Chart__c clientChart  {get;set;}
    public string vitalSignId {get;set;}
    
    public boolean displayPopup {
  get;
  set;
 }    
 
   public boolean readOnly {get;set;}
    
    public string vitalSignName {get;set;}
    public string ccRecordId ;
    public List <Allergies__c> AllergiesLst{
 set;
 Private get;
 }
 public List <Recurring_Assessment__c > lstvtalSign {
     set;
     get;
 }
 
    
    public MedicalConsultationViewCtrl(){
        
        readOnly = false;
    }
    
    public void getMethod(){
        string mcId = ApexPages.CurrentPage().getParameters().get('mcId');
          ccRecordId = apexPages.currentPage().getParameters().get('id');

        if(mcId != null && mcId != ''){
           medical = [SELECT id,
                                 MC_Evaluation_Date__c,
                                 MC_Chief_Complaint__c,
                                 MC_Clinical_Exam__c,
                                 MC_Labs_tests__c,
                                 MC_Assessment__c,
                                 MC_Plan__c,
                                 Client_Chart__c
                             FROM Medical__c 
                             WHERE Id =:mcId limit 1];
           
        getVitalSignLst();   
        }}
        
        
    
    public list < Recurring_Assessment__c > getVitalSignLst() {
lstvtalSign  = [SELECT Id, BP_Systolic__c, BP_Diastolic__c, Temperature__c, Pulse__c,Respirations__c, X02_Saturation__c,
                           Time_Due__c, LastModifiedDate, Owner.Name, CreatedDate, Related_To__c FROM Recurring_Assessment__c 
                           WHERE RecordType.DeveloperName='Vital_Signs' and Client_Chart__c =: ccRecordId ];
                     return lstvtalSign  ;
 }
     
     public void closePopup() {
  displayPopup = false;
 }

 public void showPopup() {
  displayPopup = true;
 }
   
        
        
    public list<Allergies__C> getAllergiesLst(){
     AllergiesLst = [SELECT id,Allergen__c, Allergy_Type__c, Reaction__c, Reaction_Type__c, Onset__c, Treatment__c, Status__c, Source__c, Medical__c, Client_Chart__c
      FROM Allergies__c where Client_Chart__c =:ccRecordId ];
      
     return AllergiesLst ;
 }
    
    public PageReference EditRec(){
        return new PageReference('/apex/MedicalConsultationEditPage?id='+medical.Id);
    }

}