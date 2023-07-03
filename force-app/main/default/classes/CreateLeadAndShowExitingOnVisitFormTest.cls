@isTest
public class CreateLeadAndShowExitingOnVisitFormTest {
	@isTest
    static void testshowExistingLead(){
        
        Lead__c leadRec = new Lead__c(Name__c ='Test Lead',Email__c='Test@gmail.com',Phone__c='9876543201',Lead_Stage__c='Not Connected',Lead_Substage__c='Invalid Number');
        insert leadRec;
        
        String recId = leadRec.Id;
        
        Lead_Search_Count__c ldSearchRec = new Lead_Search_Count__c(Lead__c = leadRec.Id,Searched_Date_Time__c = DateTime.now());
        insert ldSearchRec;
        
        Company__c cmpRec = new Company__c(Company_Name__c = 'Test Company');
        insert cmpRec;
        
        List<Visit__c> visitList = new List<Visit__c>();
        
        Visit__c visitRec = new Visit__c(Name__c = 'Test Visit',Company_Name__c = 'Test Visit Company',Firm_Name__c = 'Test Firm');
        insert visitRec;
        visitList.add(visitRec);
        
        Opportunity__c oppRec = new Opportunity__c(Opportunity_Name__c = 'Test Opportunity');
        insert oppRec;
               
        test.startTest();
        CreateLeadAndShowExistingOnVisiteForm.showExistingLead(leadRec.Email__c);
        CreateLeadAndShowExistingOnVisiteForm.updateExistinglead('', leadRec);   
        CreateLeadAndShowExistingOnVisiteForm.createNewLead(recid, leadRec);    
        CreateLeadAndShowExistingOnVisiteForm.getDependentMap(leadRec,'Lead_Stage__c','Lead_Substage__c');
        CreateLeadAndShowExistingOnVisiteForm.decimalToBinary(50);
        CreateLeadAndShowExistingOnVisiteForm.base64ToBits('Testing'); 
        CreateLeadAndShowExistingOnVisiteForm.createVisitUnderCurrentLead(recId,visitRec,cmpRec);          
        CreateLeadAndShowExistingOnVisiteForm.fetchvisitRecord(recId);
        test.stopTest();
        
    }
}