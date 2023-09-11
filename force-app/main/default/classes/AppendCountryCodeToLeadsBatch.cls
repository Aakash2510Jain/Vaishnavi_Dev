global class AppendCountryCodeToLeadsBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, Phone__c, Alternate_Phone__c FROM Lead__c WHERE Phone__c != null OR Alternate_Phone__c != null';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Lead__c> leadList) {
        List<Lead__c> leadsToUpdate = new List<Lead__c>();
        for (Lead__c lead : leadList) {
            if (lead.Phone__c != null) {
                lead.Phone__c = lead.Phone__c.replaceAll('[^0-9]', '');
                    lead.Phone__c = '+91' + lead.Phone__c.right(10);
            }
            if (lead.Alternate_Phone__c != null) {
                lead.Alternate_Phone__c = lead.Alternate_Phone__c.replaceAll('[^0-9]', '');
                    lead.Alternate_Phone__c = '+91' + lead.Alternate_Phone__c.right(10);
            }
            leadsToUpdate.add(lead);
        }
        
        if (!leadsToUpdate.isEmpty()) {
            update leadsToUpdate;
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        System.debug('Batch Executed Successfully');
    }
}