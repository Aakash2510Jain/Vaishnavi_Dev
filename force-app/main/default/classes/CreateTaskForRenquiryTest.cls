@isTest
public class CreateTaskForRenquiryTest {
    @isTest
    static void testInsertTask() {
        List<Lead__c> leadList = new List<Lead__c>();
        for (Integer i = 0; i < 5; i++) {
            Lead__c lead = new Lead__c(Lead_Source__c = 'ATL',Lead_Source_Type__c = 'Magazine',Lead_Sub_Source__c = 'News Paper Insert');
            leadList.add(lead);
        }
        insert leadList;

        Map<Id, Lead__c> existingLeadIdByNewLeadRec = new Map<Id, Lead__c>();
        for (Lead__c lead : leadList) {
            existingLeadIdByNewLeadRec.put(lead.Id, lead);
        }
        
        Test.startTest();
        createTaskForRenquiry.insertTask(existingLeadIdByNewLeadRec);
        Test.stopTest();

        List<Task> tasks = [SELECT Subject, WhatId, Lead_Source__c, Lead_Source_Type__c, Lead_Sub_Source__c FROM Task];
       // System.assertEquals(leadList.size(), tasks.size());

        for (Task task : tasks) {
           // System.assertEquals('Task Subject', task.Subject);
           // System.assertEquals(existingLeadIdByNewLeadRec.get(task.WhatId).Lead_Source__c, task.Lead_Source__c);
           // System.assertEquals(existingLeadIdByNewLeadRec.get(task.WhatId).Lead_Source_Type__c, task.Lead_Source_Type__c);
           // System.assertEquals(existingLeadIdByNewLeadRec.get(task.WhatId).Lead_Sub_Source__c, task.Lead_Sub_Source__c);
        }
    }
}