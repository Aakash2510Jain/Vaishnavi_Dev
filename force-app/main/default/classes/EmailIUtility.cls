public class EmailIUtility {
    public static void notifyPreSalesTeamOnLeadAssignment(set<Id> leadIDs, String templateName){
        try{
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            
            EmailTemplate et = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where name = :templateName];
            List<Lead__c> leadList = [Select Id,Owner.email,Owner.Name,Name,Email__c,Phone__c From Lead__c where id in : leadIDs];
            
            if(!leadList.isEmpty()){
                for(Lead__c leadRec : leadList){
                    System.debug('leadRec:::'+leadRec);
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    
                    List<String> recipients = new List<String>();
                    recipients.add(leadRec.Owner.Email);
                    system.debug('recipients------' + recipients);
                    mail.setToAddresses(recipients);
                    mail.setReplyTo('test@email.com');
                    mail.setSenderDisplayName('Vaishnavi');
                    String subject = et.Subject;
                    String htmlBody = et.HtmlValue;
                    
                    if(leadRec.Owner.Name != null)
                        htmlBody = htmlBody.replace('{!Lead.OwnerFullName}', leadRec.Owner.Name);
                    if(leadRec.Name != null)
                        htmlBody = htmlBody.replace('{!Lead.Name}', leadRec.Name);
                    if(leadRec.Email__c != null)
                        htmlBody = htmlBody.replace('{!Lead.Email}', leadRec.Email__c);
                    if(leadRec.Phone__c != null)
                        htmlBody = htmlBody.replace('{!Lead.Phone}', leadRec.Phone__c);
                        htmlBody = htmlBody.replace('{!Lead.OwnerEmail}', leadRec.Owner.Email);
                    
                    mail.setSubject(subject);
                    mail.setHtmlBody(htmlBody);
                    mails.add(mail);
                }
                if(!mails.isEmpty()){
                    Messaging.sendEmail(mails);
                }
            }
        } catch (Exception e){
            System.debug('Error Line==>' + e.getLineNumber() + 'Error Message==>' + e.getMessage());
        }
    }
    
     public static void notifySalesTeamOnLeadAssignment(set<Id> leadIDs, String templateName){
        try{
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            
            EmailTemplate et = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where name = :templateName];
            List<Lead__c> leadList = [Select Id,Owner.email,Owner.Name,Name,Email__c,Phone__c From Lead__c where id in : leadIDs];
            
            if(!leadList.isEmpty()){
                for(Lead__c leadRec : leadList){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    
                    List<String> recipients = new List<String>();
                    recipients.add(leadRec.Owner.Email);
                    system.debug('recipients------' + recipients);
                    mail.setToAddresses(recipients);
                    mail.setReplyTo('test@email.com');
                    mail.setSenderDisplayName('Vaishnavi');
                    String subject = et.Subject;
                    String htmlBody = et.HtmlValue;
                    
                    if(leadRec.Owner.Name != null)
                        htmlBody = htmlBody.replace('{!Lead.OwnerFullName}', leadRec.Owner.Name);
                    if(leadRec.Name != null)
                        htmlBody = htmlBody.replace('{!Lead.Name}', leadRec.Name);
                    if(leadRec.Email__c != null)
                        htmlBody = htmlBody.replace('{!Lead.Email}', leadRec.Email__c);
                    if(leadRec.Phone__c != null)
                        htmlBody = htmlBody.replace('{!Lead.Phone}', leadRec.Phone__c);
                    htmlBody = htmlBody.replace('{!Lead.OwnerEmail}', leadRec.Owner.Email);
                    
                    mail.setSubject(subject);
                    mail.setHtmlBody(htmlBody);
                    mails.add(mail);
                }
                if(!mails.isEmpty()){
                    Messaging.sendEmail(mails);
                }
            }
        } catch (Exception e){
            System.debug('Error Line==>' + e.getLineNumber() + 'Error Message==>' + e.getMessage());
        }
    }
}