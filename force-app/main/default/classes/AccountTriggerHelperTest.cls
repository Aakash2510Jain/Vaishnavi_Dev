@isTest
public class AccountTriggerHelperTest {
	@isTest
    static void testAfterInsert(){
        Lead__c leadrec = new Lead__c(Name__c='TestLead');
        insert leadrec;
        
        Account acc = new Account(name = 'Test Account',Lead__c=leadrec.Id);
        insert acc;
        
        Map<Id,Account> newAccMap = new Map<Id,Account>();
        newAccMap.put(acc.Id, acc);
        Test.startTest();
        AccountTriggerHelper.getInstance().afterInsert(newAccMap);
        Test.stopTest();
        
        List<Contact> contacts = [Select Id,AccountId,LastName From Contact Where AccountId =:acc.Id];
        
        List<Opportunity__c> opportunities = [ Select Id,AccountId__c,Lead__c,Opportunity_Name__c,Lead_Source__c, Lead_Sub_Source__c, Lead_Source_Type__c, Email__c, Phone__c FROM Opportunity__c WHERE AccountId__c =:acc.Id];
        
        List<Lead__c> leads = [ Select Id,Account__c,Lead_Source__c, Lead_Sub_Source__c, Lead_Source_Type__c, Email__c, Phone__c From Lead__c Where Account__c =:acc.id];
        
        List<Task> tasks = [Select Id,whatId From Task where whatId in :newAccMap.keyset()]; 
    }
}