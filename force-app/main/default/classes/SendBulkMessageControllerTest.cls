@isTest
public class SendBulkMessageControllerTest {
	@isTest
    static void testSendBulkMessageController() {
       List<Lead__c> leadList = new List<Lead__c>();
       for(Lead__c leadRec :leadList){
        leadRec.Name__c = 'Test Lead';
        leadList.add(leadRec);
       }
       insert leadList;

       ApexPages.StandardSetController controller = new ApexPages.StandardSetController(leadList);

       SendBulkMessageController sendBulkMessageController = new SendBulkMessageController(controller);

       List<Lead__c> selectedLeads = sendBulkMessageController.selLeads;
       String leadIds = sendBulkMessageController.LeadIds;

       String expectedLeadIds = '';
        for (Lead__c lead : selectedLeads) {
            expectedLeadIds += lead.Id + '-';
        }
        expectedLeadIds = expectedLeadIds.removeEnd('-');
    }
    
   /* @IsTest
    static void testRedirectToLC() { 
        SendBulkMessageController sendBulkMsgController = new SendBulkMessageController(new ApexPages.StandardSetController(new List<Lead__c>()));

        sendBulkMsgController.LeadIds = 'Test Lead 1 - Test Lead 2';
        
        PageReference expectedPageRef = Page.SendBulkMessageApp;
        expectedPageRef.getParameters().put('listofLeads', sendBulkMsgController.LeadIds);
        expectedPageRef.setRedirect(true);

        // Call the method and assert the return value
        PageReference actualPageRef = sendBulkMsgController.redirectToLC();
}    */
    
    @isTest
    static void testGetLeads(){
        List<Lead__c> leadListTOInsert = new List<Lead__c>();
        for(integer i =0;i< 5;i++){// leadRec :leadList2){
            Lead__c leadRec  = new Lead__C();
            leadRec.Name__c = 'Test Lead'+i;
            leadListTOInsert.add(leadRec);
       }
       insert leadListTOInsert;
        
        String url = '/c/SendBulkMessageApp.app?listofLeads=';
        for (Lead__c lead : leadListTOInsert) {
            url += lead.Id + ',';
        }
        url = url.removeEnd(',');
        system.debug('url---'+url);
        List<Lead__c> returnedLeads = SendBulkMessageController.getLeads(url);
    }
}