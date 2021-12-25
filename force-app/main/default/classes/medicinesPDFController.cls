/*
    medicinespdf controller
    author Huma
    Test Class : medicinesPDFControllerTest
*/
public class medicinesPDFController{
    
    public OrderView.OrderPDF info{get;set;}
    public UtlizationReviewOrder__c BBC{get;set;}
    public string allergies{get;set;}
    public Insurance_Verification__c insuranceVerification {get;set;}
    
    public medicinesPDFController(){
    
        id OrderId = system.CurrentPageReference().getParameters().get('orderId');
        system.debug(OrderId );
        
        Order__c ViewOrderRec = [select id, Status__c, Action__c ,Order_Type__c, Signed_By__c, Order_By__c, Doctor_Image_URL__c, 
        Doctor_Signed_User__c, Client_Chart__r.Name,Order_By__r.Name, Order_By__r.Title, CreatedBy.Name, CreatedBy.Title,
        Client_Chart__r.Treatment_Center__r.Name,
        Doctor_Signed_Date__c, Taper__c, Taper__r.Protocol__c, Taper__r.Name, Taper__r.Number_of_Days__c, 
        Taper__r.Justification_Indication_Target__c, Taper__r.Dispense_Amount__c,
        Taper__r.Warning__c, Warnings__c, Client_Chart__c ,Client_Chart__r.Opportunity__c,
        Start_Date__c, CreatedById,Medicine__c, Medicine__r.Name,Client_Chart__r.DOB__c, Client_Chart__r.Treatment_Center__c,
        Route__c, Frequency__c, Dose__c, Dosage_Form__c, Pharmacy_Status__c, Client_Chart__r.Gender__c, Justification__c, 
        Client_Chart__r.Street__c, Client_Chart__r.State__c, 
        Client_Chart__r.City__c, Client_Chart__r.Postal_Code__c, Client_Chart__r.Country__c, Dispense_Amount__c , Number_of_Refills__c,
        Client_Chart__r.Medical_Record_Number__c, Duration__c
         from Order__c where id=: OrderId ];
         
         try{
         //for address
             for(UtlizationReviewOrder__c uro : [Select id, Client_Chart__c, Bed__r.Room__r.House__r.House_Phone_Number__c, Bed__r.Room__r.House__r.House_Fax_Number__c, 
                                                Bed__c, Bed__r.Room__r.House__r.Address__c, Bed__r.Room__r.House__r.House_Website__c from UtlizationReviewOrder__c
                                                where Client_Chart__c =: ViewOrderRec.Client_Chart__c AND (Status__c =: 'Active' OR Status__c =: 'Future Reservation')]){
                if(BBC == null){
                    BBC = uro;
                }else{
                    if(uro.Status__c == 'Active' && BBC.id != uro.id){
                        BBC = uro;
                    }
                }
             }
         }
         catch(exception e){}
         
         //for allergies
         list<Allergies__c> allergy = [select Allergen__c from Allergies__c where Client_Chart__c =: ViewOrderRec.Client_Chart__c and
         Allergy_Type__c = 'Drug'];
         
         allergies = '';
         
         for(Allergies__c alg : allergy ){
             allergies += alg.Allergen__c + ',';
         }
         if(allergies.endswith(','))
             allergies = allergies.substring(0,allergies.length()-1);
         
         if(allergies == '')
             allergies = 'No Know Allergies/NKA';
         
         Taper__c taper;
         
         if(ViewOrderRec.Order_Type__c != 'Manual' && ViewOrderRec.Order_Type__c != 'Action'){
             if(ViewOrderRec.Taper__c ==null)
                taper = new Taper__c();
            else
               taper = [select id, Name from Taper__c where id=: ViewOrderRec.Taper__c];
               
              list<Order_line_item__c> lstOLI = [select id, Frequency__c, Medicine__c, Day__c, Route__c, Dosage_Form__c, Dose__c, Medicine__r.Name
                                       from Order_line_item__c where order__c =: ViewOrderRec.id];
                                       
            map<string,decimal> mapMedicineDispenseAmount = new map<string,decimal>();
            
            for(Order_line_item__c TLI : lstOLI ){
                list<string> freq = TLI.Frequency__c.split(' : ');
                FrequencyMapping__c FM = FrequencyMapping__c.getValues(freq[0]);
                if(mapMedicineDispenseAmount.containsKey(TLI.Medicine__r.Name+TLI.Dose__c)){
                    decimal i = mapMedicineDispenseAmount.get(TLI.Medicine__r.Name+TLI.Dose__c);
                    if(FM.Count__c !=null)
                        i += FM.Count__c;
                    mapMedicineDispenseAmount.put(TLI.Medicine__r.Name+TLI.Dose__c,i);
                }
                else{
                    decimal cnt = 1;
                    if(FM.Count__c !=null)
                        cnt = FM.Count__c;
                    mapMedicineDispenseAmount.put(TLI.Medicine__r.Name+TLI.Dose__c,cnt);
                }
            }
            map<string,OrderView.MedicationInfo> mapMedications = new map<string,OrderView.MedicationInfo>(); 
            OrderView.MedicationInfo wrapObj ;    
            
            for(Order_line_item__c TLI : lstOLI ){
                if(!mapMedications.containsKey(TLI.Medicine__r.Name+TLI.Dose__c)){
                    wrapObj = new OrderView.MedicationInfo (TLI.Medicine__r.Name, TLI.Dose__c,TLI.Route__c, TLI.Dosage_Form__c,
                    'As per Taper Information' , (ViewOrderRec.Order_Type__c =='Standard - PRN')?ViewOrderRec.Taper__r.Dispense_Amount__c:mapMedicineDispenseAmount.get(TLI.Medicine__r.Name+TLI.Dose__c),'0');// TLI.Frequency__c,lstTime );
                    mapMedications.put(TLI.Medicine__r.Name+TLI.Dose__c, wrapObj);
                }                    
            }
            info= new OrderView.OrderPDF(ViewOrderRec, mapMedications.values());
       }
       else{

           list<OrderView.MedicationInfo> lst = new list<OrderView.MedicationInfo>(); 
           OrderView.MedicationInfo  wrapObj ;
          
           wrapObj = new OrderView.MedicationInfo(ViewOrderRec.Medicine__r.Name, ViewOrderRec.Dose__c,ViewOrderRec.Route__c, 
           ViewOrderRec.Dosage_Form__c, ViewOrderRec.Frequency__c,ViewOrderRec.Dispense_Amount__c ,ViewOrderRec.Number_of_Refills__c);
           lst.add(wrapObj );
           info= new OrderView.OrderPDF(ViewOrderRec,  lst);
       }
       
       List < Insurance_Verification__c > lstInsurVerif = [SELECT Id, Pharmacy_Phone__c, Pharmacy_Vendor__c,Pharmacy_Benefits_RX_ID__c,
       Pharmacy_Benefits_RX_BIN__c, Pharmacy_Benefits_RX_Group__c, Pharmacy_Benefits_RX_PCN__c FROM Insurance_Verification__c
                where Opportunity__c = :ViewOrderRec.Client_Chart__r.Opportunity__c limit 1];
                
        if (lstInsurVerif.size() > 0) {
            insuranceVerification = lstInsurVerif.get(0);
        }

    }
    
}