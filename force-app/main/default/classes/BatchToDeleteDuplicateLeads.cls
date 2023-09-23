public without sharing class BatchToDeleteDuplicateLeads implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext context) {
        String query = 'Select id from Lead__c where To_Be_Deleted__c = true';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext context, List<Lead__c> scope) {
        delete scope;
    }
    
    public void finish(Database.BatchableContext context) {
    }
}