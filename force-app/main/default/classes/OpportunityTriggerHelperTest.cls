@isTest
public class OpportunityTriggerHelperTest {
    @isTest
    static void testAfterInsert(){
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Contact testContact = new Contact(AccountId = testAccount.Id, LastName = 'Test Contact');
        insert testContact;
         
        Lead__c testLead = new Lead__c(Name__c = 'Test Lead');
        insert testLead;	
        
        Opportunity__c testOpportunity = new Opportunity__c( Opportunity_Name__c = 'Test Opportunity', AccountId__c = testAccount.Id, Lead__c=testLead.Id);
        
        
        Visit__c testVisit = new Visit__c(Lead__c = testLead.Id);
        insert testVisit;
        
        Test.startTest();
        
        OpportunityTriggerHelper helper = OpportunityTriggerHelper.getInstance();
        
        Map<Id, Opportunity__c> opportunityMap = new Map<Id, Opportunity__c>();
        opportunityMap.put(testOpportunity.Id, testOpportunity);
        helper.afterInsert(opportunityMap);
        
        Visit__c updatedVisit = [SELECT Opportunities__c,Lead__c FROM Visit__c WHERE Id = :testVisit.Id];
        
        Test.stopTest();
    }
}