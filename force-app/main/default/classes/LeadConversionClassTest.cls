@isTest
public class LeadConversionClassTest {
	@isTest
    static void testConvertLead(){
        
        Campaign cmpRec = new Campaign(Name = 'Test Campaign');
        insert cmpRec;
        
        Project__c proRec = new Project__c(Name = 'Test Project');
        insert proRec;
        
        List<Lead__c> leadList = new List<Lead__c>();
                  
        Lead__c lead = new Lead__c();
        lead.Name__c = 'Test Lead';
        lead.Email__c = 'test@example.com';
        lead.Phone__c = '1234567890';
        lead.Lead_Source__c = 'ATL';
        lead.Lead_Source_Type__c = 'Magazine';
        lead.Lead_Sub_Source__c = 'Outdoor	';
        lead.Campaign__c = cmpRec.Id;
        lead.Project__c = proRec.Id;
        lead.Site_Visit_Date__c = Date.today();
        lead.Is_Budget_Verified__c = true;
        lead.Project_Location__c = true;
        lead.Project_Completion_TimeLine__c = true;
        lead.Unit_Availability__c = true;
        
        leadList.add(lead);
               
        Test.startTest();
        LeadConversionClass.convertLead(leadList);
        Test.stopTest();
               
        Account convertedAccount = [SELECT Name, Lead__c, Email__c, Phone, AccountSource, Source_Type__c, Sub_Source__c, 
                                    Campaign__c, Project__c, Site_Visit_Planned_Date__c, Is_Budget_Verified__c, 
                                    Project_Location__c, Project_Completion_TimeLine__c, Unit_Availability__c 
                                    FROM Account LIMIT 1];

    }
}