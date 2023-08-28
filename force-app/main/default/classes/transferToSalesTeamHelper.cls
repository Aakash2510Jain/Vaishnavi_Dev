public without Sharing class transferToSalesTeamHelper {
    @auraEnabled
    public static string shareAndTagSalesTeamMember(string leadId){
        system.debug('leadId--->'+leadId);
       
        Lead__c leadRec = [Select Id,Project_Pickval__c,Budget_Pick__c,Unit_Pickval__c,Location__c,Project_TimeLine__c From Lead__c where Id =:leadId];
        
        if(string.isBlank(leadRec.Project_Pickval__c)){
          return 'Project is Empty';  
        }
        if(string.isBlank(leadRec.Budget_Pick__c)){
          return 'Budget is Empty';  
        }
        if(string.isBlank(leadRec.Unit_Pickval__c)){
          return 'Unit is Empty';  
        }
        if(string.isBlank(leadRec.Location__c)){
          return 'Location is Empty';  
        }
        if(string.isBlank(leadRec.Project_TimeLine__c)){
          return 'Timeline is Empty';  
        }
        
        set<String> LeadIdList = new Set<String>();
        LeadIdList.add(leadId);
        String courseName = 'Sales Team '+leadRec.Project_Pickval__c;
        RoundRobinLeadAssignment.assignLeadsToBDS(courseName, LeadIdList,true);
        return 'Success';
    }
    
    @AuraEnabled
    public static void sendEmailToLead(Id leadId){
        /*EmailTemplate temp = [Select id,Subject,Body,HTMLValue from EmailTemplate where name = 'Lead Associate to Sales Team']; 
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
        */
    }
}