public class LeadConversionClass {
    public static void convertLead(List<Lead__c> leadListToBeConverted ){
        List<Account> accountListToInsert = new List<Account>();
              
        if(!leadListToBeConverted.isEmpty()){
            for(Lead__c leadRec : leadListToBeConverted){
                Account accRecToInsert = new Account();
                accRecToInsert.name = leadRec.Name__c;
                accRecToInsert.Lead__c = leadRec.Id;
                accRecToInsert.Email__c = leadRec.Email__c;
                accRecToInsert.Phone = leadRec.Phone__c;
                accRecToInsert.AccountSource = leadRec.Lead_Source__c;
                accRecToInsert.Source_Type__c = leadRec.Lead_Source_Type__c;
                accRecToInsert.Sub_Source__c = leadRec.Lead_Sub_Source__c;
                accountListToInsert.add(accRecToInsert);
            }
            if(!accountListToInsert.isEmpty()){
                insert accountListToInsert;
            }
        }
    }
}