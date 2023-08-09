public without Sharing class transferToSalesTeamHelper {
    @auraEnabled
    public static void shareAndTagSalesTeamMember(string leadId){
        system.debug('leadId--->'+leadId);
        /*Assignment_Group_Member__c salesTeamMemberRecord = [Select Id,Group_Member__c,Last_Sequence__c From Assignment_Group_Member__c where Assignment_Group__c = 'a0A1m000003of4HEAQ' order by LastModifiedDate limit 1];  
        salesTeamMemberRecord.Last_Sequence__c = 1;
        update salesTeamMemberRecord;
        
        Lead__c leadRecToShareTOSalesTeam = new Lead__c();
        leadRecToShareTOSalesTeam.Id = leadId;
        leadRecToShareTOSalesTeam.Sales_Team_Member__c = salesTeamMemberRecord.Group_Member__c;
        update leadRecToShareTOSalesTeam;
        
        Lead__Share leadShareRec = new Lead__Share();
        leadShareRec.ParentId = leadId;
        leadShareRec.UserOrGroupId = salesTeamMemberRecord.Group_Member__c;
        leadShareRec.AccessLevel = 'EDIT';
        insert leadShareRec;
        
        transferToSalesTeamHelper.sendEmailToLead(leadId);*/
        set<String> LeadIdList = new Set<String>();
        LeadIdList.add(leadId);
        String courseName = system.label.Sales_Team_Group;
        RoundRobinLeadAssignment.assignLeadsToBDS(courseName, LeadIdList,true);
        
    }
    
    @AuraEnabled
    public static void sendEmailToLead(Id leadId){
        EmailTemplate temp = [Select id,Subject,Body,HTMLValue from EmailTemplate where name = 'Lead Associate to Sales Team']; 
        Lead__c leadRec = [Select Id,Email__c,Name__c From Lead__c Where Id =: leadId];
        
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
         
        String htmlBody = temp.HTMLValue;
        String plainTextBody = temp.Body;
        
        plainTextBody = plainTextBody.replace('{!Lead__c.Name__c}', leadRec.Name__c);
        //plainTextBody = plainTextBody.replace('{!Lead__c.Email__c}', leadRec.Email__c);
        
        htmlBody = htmlBody.replace('{!Lead__c.Name__c}', leadRec.Name__c);
        //htmlBody = htmlBody.replace('{!Lead__c.Email__c}', leadRec.Email__c);
        
        Messaging.SingleEmailMessage mailTemp = new Messaging.SingleEmailMessage();
        mailTemp.setHtmlBody(htmlBody);
        mailTemp.setSubject(temp.subject);
        mailTemp.setPlainTextBody(plainTextBody);
        mailTemp.toAddresses = new String[] {leadRec.Email__c};
            mailList.add(mailTemp);
        if(!mailList.isEmpty()){
            Messaging.sendEmail(mailList);
        }
        
    }
}