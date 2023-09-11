global class AppendCountryCodeToOpportunitiesBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, Phone__c, Alternate_Phone__c FROM Opportunity__c WHERE Phone__c != null OR Alternate_Phone__c != null';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Opportunity__c> opportunityList) {
        List<Opportunity__c> opportunitysToUpdate = new List<Opportunity__c>();
        for (Opportunity__c opportunity : opportunityList) {
            if (opportunity.Phone__c != null && !opportunity.Phone__c.startsWith('+91')) {
                opportunity.Phone__c = '+91' + opportunity.Phone__c;
            }
            if (opportunity.Alternate_Phone__c != null && !opportunity.Alternate_Phone__c.startsWith('+91')) {
                opportunity.Alternate_Phone__c = '+91' + opportunity.Alternate_Phone__c;
            }
            opportunitysToUpdate.add(opportunity);
        }
        
        if (!opportunitysToUpdate.isEmpty()) {
            update opportunitysToUpdate;
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        System.debug('Batch Executed Successfully');
    }
}