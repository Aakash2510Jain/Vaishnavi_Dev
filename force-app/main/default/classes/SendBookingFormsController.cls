public without sharing class SendBookingFormsController {
    @AuraEnabled
    public static void sendPremiereBookingForm(string oppId){
        try{
            Opportunity__c opportunityRecord = [SELECT Id,Opportunity_Name__c FROM Opportunity__c WHERE Id =: oppId];
            String oppEmail = [Select Email__c From Opportunity__c where Id =: oppId].Email__c; 
            Emailtemplate emailTempRec = New Emailtemplate();
            emailTempRec = [Select Id,HtmlValue,Subject from EmailTemplate where Name ='Premiere Booking Form'];
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] { oppEmail});//Set To Email Address
            mail.setSubject(emailTempRec.Subject);
            string emailHtmlValue = emailTempRec.HtmlValue;
            if(!string.isBlank(opportunityRecord.Opportunity_Name__c)){
                emailHtmlValue = emailHtmlValue.replace('{!Opportunity.Name}', opportunityRecord.Opportunity_Name__c);
            }
            if(!string.isBlank(opportunityRecord.Id)){
                emailHtmlValue = emailHtmlValue.replace('{!Opportunity.Id}', opportunityRecord.Id);
            }
            mail.setHtmlBody(emailHtmlValue);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
        }catch(Exception e){
            system.debug(e.getMessage()+e.getLineNumber());
        }
    }


    @AuraEnabled
    public static void sendLifeBookingForm(string oppId){
        try{
            Opportunity__c opportunityRecord = [SELECT Id,Opportunity_Name__c FROM Opportunity__c WHERE Id =: oppId];
            String oppEmail = [Select Email__c From Opportunity__c where Id =: oppId].Email__c; 
            Emailtemplate emailTempRec = New Emailtemplate();
            emailTempRec = [Select Id,HtmlValue,Subject from EmailTemplate where Name ='Life Booking Form'];
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] { oppEmail});//Set To Email Address
            mail.setSubject(emailTempRec.Subject);
            string emailHtmlValue = emailTempRec.HtmlValue;
            if(!string.isBlank(opportunityRecord.Opportunity_Name__c)){
                emailHtmlValue = emailHtmlValue.replace('{!Opportunity.Name}', opportunityRecord.Opportunity_Name__c);
            }
            if(!string.isBlank(opportunityRecord.Id)){
                emailHtmlValue = emailHtmlValue.replace('{!Opportunity.Id}', opportunityRecord.Id);
            }
            mail.setHtmlBody(emailHtmlValue);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
        }catch(Exception e){
            system.debug(e.getMessage()+e.getLineNumber());
        }
    }

    @AuraEnabled
    public static void sendSereneBookingForm(string oppId){
        try{
            Opportunity__c opportunityRecord = [SELECT Id,Opportunity_Name__c FROM Opportunity__c WHERE Id =: oppId];
            String oppEmail = [Select Email__c From Opportunity__c where Id =: oppId].Email__c; 
            Emailtemplate emailTempRec = New Emailtemplate();
            emailTempRec = [Select Id,HtmlValue,Subject from EmailTemplate where Name ='Serene Booking Form'];
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] { oppEmail});//Set To Email Address
            mail.setSubject(emailTempRec.Subject);
            string emailHtmlValue = emailTempRec.HtmlValue;
            if(!string.isBlank(opportunityRecord.Opportunity_Name__c)){
                emailHtmlValue = emailHtmlValue.replace('{!Opportunity.Name}', opportunityRecord.Opportunity_Name__c);
            }
            if(!string.isBlank(opportunityRecord.Id)){
                emailHtmlValue = emailHtmlValue.replace('{!Opportunity.Id}', opportunityRecord.Id);
            }
            mail.setHtmlBody(emailHtmlValue);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
        }catch(Exception e){
            system.debug(e.getMessage()+e.getLineNumber());
        }
    }
}