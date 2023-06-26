@isTest
public class SimilarLeadsHelperTest {
	@isTest
    static void testGetLeads(){
        Lead__c leadRec = new Lead__c (Name__c ='Test Lead',Phone__c='8208472037',Email__c='tushar@gmail.com', Lead_Source__c='ATL');
        insert leadRec;
        Test.startTest();
        List<Lead__c> result = SimilarLeadsHelper.getLeads(leadRec.Id);
        Test.stopTest();
    }
    
  
    @isTest
    static void testGetLeadSourceTypePickList() {
        // Test the getLeadSourceTypePickList method
        Test.startTest();
        List<String> result = SimilarLeadsHelper.getLeadSourceTypePickList('Lead__c', 'Lead_Source_Type__c');
        Test.stopTest();

    }
    
    @isTest
    static void testGetLeads2(){
        Lead__c leadRecord = new Lead__c (Name__c ='Test Lead',Phone__c='82084729999',Email__c='survi@gmail.com', Lead_Source__c='Digital');
        insert leadRecord;
        Test.startTest();
        List<Lead__c> result2 = SimilarLeadsHelper.getLeads2(leadRecord.Id); 
        Test.stopTest();
    }  

}