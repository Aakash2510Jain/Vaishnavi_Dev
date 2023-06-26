@isTest
public class LeadConversionClassTest {
	@isTest
    static void testConvertLead(){
        List<Lead__c> leadListToBeConverted = new List<Lead__c>();
        
        Lead__c leadrec = new Lead__c( Name__c='Test Lead', Email__c='Test@gmail.com', Phone__c = '9087653421', Lead_Source__c='ATL', Lead_Source_Type__c = 'Magazine',Lead_Sub_Source__c = 'Print', Campaign__c = '7011m0000004GlHAAU',Project__c = 'a021m00001b4MS4AAM', Site_Visit_Date__c = Date.today(), Is_Budget_Verified__c = true, Project_Location__c = true, Project_Completion_TimeLine__c = true,Unit_Availability__c = true);
 		
        leadListToBeConverted.add(leadrec);
        
        Test.startTest();
        	 LeadConversionClass.convertLead(leadListToBeConverted);
        	 
             List<Account> insertedAccounts = [SELECT Name, Lead__c, Email__c, Phone, AccountSource, Source_Type__c, Sub_Source__c, Campaign__c, Project__c, Site_Visit_Planned_Date__c, Is_Budget_Verified__c, Project_Location__c, Project_Completion_TimeLine__c, Unit_Availability__c FROM Account];
        
        	 Account insertedAccount = insertedAccounts[0];
        Test.stopTest();
        
    }
}