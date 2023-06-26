@isTest
private class AccountRollupCmpHelperTest {
	@isTest
    static void testGetOppData(){
        // Create Test Data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Opportunity__c opp1 = new Opportunity__c(Opportunity_Name__c = 'Opportunity 1',Stage__c = 'SV Done', AccountId__c = testAccount.Id);
        Opportunity__c opp2 = new Opportunity__c(Opportunity_Name__c = 'Opportunity 2',Stage__c = 'Pricing Negotiation', AccountId__c = testAccount.Id);
        Opportunity__c opp3 = new Opportunity__c(Opportunity_Name__c = 'Opportunity 3',Stage__c = 'Booking Done', AccountId__c = testAccount.Id);
        insert new List<Opportunity__c>{ opp1, opp2, opp3 };
            
        Case c1 = new Case(Subject = 'Case 1',AccountId = testAccount.Id);
        Case c2 = new Case(Subject = 'Case 2',AccountId = testAccount.Id);
        insert new List<Case> { c1,c2 };
            
        // Call getOppData method
        AccountRollupCmpHelper.wrapper result = AccountRollupCmpHelper.getOppData(testAccount.Id);
        
       // System.assertEquals(3, result.TotalOpportunityCount);
       // System.assertEquals(1, result.NewStageOpportunityCount);
       // System.assertEquals(1, result.UnderPaymentOpportunityCount);
       // System.assertEquals(1, result.ClosedWonOpportunityCount);
       // System.assertEquals(2, result.TotalCaseCount);
        
    }
}