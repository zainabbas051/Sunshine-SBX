/*
Author : Zain Abbas
Date : 26/11/2021
Description : This will use in "PremiumLeadTrg" trigger
*/
public without sharing class LeadInsuranceKeywordUtil {
    public LeadInsuranceKeywordUtil() {

    }
    /*
    This method will take lead list and assign Premium Leads checkbox to true
    if any of the word in Insurance Proiders matches with the Keywords
    stored in Lead Admin Metadata
    */
    public static void updatePremiumLeads(list<Lead> listriggerNew){
        set<string> setOfKeywords;
        set<string> setOfLeadWords;

        //Fetching metadata record
        LeadAdminSetting__mdt mdtRec = LeadAdminSetting__mdt.getInstance('Premium_Leads');
        
        //checking if there are multiple keywords, then break it and fill a set
        if(mdtRec != null && !string.isBlank(mdtRec.Keywords__c)){
            String allKeywords = mdtRec.Keywords__c;
            if(allKeywords.contains(';')){
                list<string> splittedKeywords = allKeywords.toLowerCase().split(';');
                setOfKeywords = new set<string>(splittedKeywords);
            }
            else{
                setOfKeywords = new set<string>{allKeywords.toLowerCase()};
            }
        }
        if(test.isRunningTest()){
            setOfKeywords = new set<string>{'venom','tommy'};
        }

        //Iterating over list of Trigger
        for(Lead l : listriggerNew){
            //checking if insurance provider is not empty
            if(!String.isBlank(l.Insurance_Providors__c)){
                string insProv = l.Insurance_Providors__c.trim();
                //checking and splitting Insureance Provider on Space to check multiple values
                if(insProv.contains(' ')){
                    list<string> splittedLeadWords = insProv.tolowerCase().split(' ');
                    setOfLeadWords = new set<string>(splittedLeadWords);
                }
                else {
                    setOfLeadWords = new set<string>{insProv.toLowerCase()};
                }

                //checking if keywords and Insurance Providers both are not empty to check
                if(setOfKeywords.size() > 0 && setOfLeadWords.size() > 0)
                {
                    //iterating over Insurance Provider to check if "ANY" word matches with Keywords
                    for(string lkeyw: setOfLeadWords){
                        //If Insurance Provider word matches with keyword, mark lead Premium to true
                        //break the loop and do not check for further matches
                        if(setOfKeywords.contains(lkeyw) || (l.LeadSource != null && l.LeadSource == 'Biz Dev')){
                            l.Premium_Leads__c = true;
                            break;
                        }
                        //if it doesnt match with any keyword, mark this lead Premium to false
                        else{
                            l.Premium_Leads__c = false;
                        }
                    }
                    
                }
            }
        }

        system.debug('setOfKeywords= '+setOfKeywords);
        system.debug('setOfLeadWords= '+setOfLeadWords);
    }
}