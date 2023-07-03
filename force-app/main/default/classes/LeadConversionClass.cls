public class LeadConversionClass {
    public static void convertLead(List<Lead__c> leadListToBeConverted ){
        List<Account> accountListToInsert = new List<Account>();
        Set<Id> leadIds = new Set<Id>();
        
        if(!leadListToBeConverted.isEmpty()){
            for(Lead__c leadRec : leadListToBeConverted){
                leadIds.add(leadRec.Id);
                Account accRecToInsert = new Account();
                accRecToInsert.name = leadRec.Name__c;
                accRecToInsert.Lead__c = leadRec.Id;
                accRecToInsert.Email__c = leadRec.Email__c;
                accRecToInsert.Phone = leadRec.Phone__c;
                accRecToInsert.AccountSource = leadRec.Lead_Source__c;
                accRecToInsert.Source_Type__c = leadRec.Lead_Source_Type__c;
                accRecToInsert.Sub_Source__c = leadRec.Lead_Sub_Source__c;
                accRecToInsert.Project__c = leadRec.Project__c;
                
                accRecToInsert.Campaign__c = leadRec.Campaign__c;
                accRecToInsert.Project__c = leadRec.Project__c;
                accRecToInsert.Site_Visit_Planned_Date__c = leadRec.Site_Visit_Date__c;
                accRecToInsert.Is_Budget_Verified__c = leadRec.Is_Budget_Verified__c;
                accRecToInsert.Project_Location__c = leadRec.Project_Location__c;
                accRecToInsert.Project_Completion_TimeLine__c = leadRec.Project_Completion_TimeLine__c;
                accRecToInsert.Unit_Availability__c = leadRec.Unit_Availability__c;
                
                accountListToInsert.add(accRecToInsert);
            }
            if(!accountListToInsert.isEmpty()){
                insert accountListToInsert;
            }
            
        }
    }
}