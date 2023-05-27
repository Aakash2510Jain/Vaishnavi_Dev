public without sharing class SimilarLeadsHelper {
    
    @AuraEnabled
    public static List<Lead__c>  getLeads( string recordId){
        system.debug('recordId==>'+recordId);
        List<Lead__c> leadListWithSimEmail = new List<Lead__c>();
        try{
            if(recordId != null){
                Lead__c ld= [Select id,Name__c,Phone__c,Email__c from Lead__c where id=:recordId];
                system.debug('ld--->'+ld);
                string existingLeadPhone = ld.Phone__c;
                string existingLeadEmail = (ld.Email__c).split('@')[0]+'%';
                
                if(ld.Name__c !=null){                       
                    leadListWithSimEmail = [Select Id,Name__c,Email__c,Phone__c,Lead_Source__c,Lead_Source_Type__c,Lead_Sub_Source__c From Lead__c where (Name__c like: ld.Name__c or Phone__c like : existingLeadPhone or Email__c like : existingLeadEmail)AND Id !=:  recordId];
                    system.debug('leadListWithSimEmail--->'+leadListWithSimEmail);
                    return leadListWithSimEmail;
                }                
                else{
                    return null;
                }
            }   
        }catch(Exception e){
            System.debug(e.getMessage());
            System.debug(e.getLineNumber());
        }  
        return null;
    }
}