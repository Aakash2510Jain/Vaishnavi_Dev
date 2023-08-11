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
    public static void notifyCustomerForNewEnquiry(set<string> emailIds, String templateName){
        try{
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            EmailTemplate et = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where name = :templateName];
            
            if(!emailIds.isEmpty()){
                for(string leadEmail : emailIds){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    
                    List<String> recipients = new List<String>();
                    recipients.add(leadEmail);
                    system.debug('recipients------' + recipients);
                    mail.setToAddresses(recipients);
                    mail.setReplyTo('test@email.com');
                    mail.setSenderDisplayName('Vaishnavi');
                    String subject = et.Subject;
                    String htmlBody = et.HtmlValue;
                    
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
     public static void firstNotConnectedEmailToCustomer(set<id> leadIdsSet, String templateName){
        try{
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            EmailTemplate et = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where name = :templateName];
            List<Lead__C> leadListToNotify = [Select Id,Name__c,Site_Visit_Date__c,ProjectName_formula__c,Email__c,owner.Name from Lead__C where Id In : leadIdsSet and Email__c != null];
            
            if(!leadListToNotify.isEmpty()){
                for(Lead__c leadRec : leadListToNotify){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                   
                    List<String> recipients = new List<String>();
                    recipients.add(leadRec.Email__C);
                    system.debug('recipients------' + recipients);
                    mail.setToAddresses(recipients);
                    mail.setReplyTo('test@email.com');
                    mail.setSenderDisplayName('Vaishnavi');
                    String subject = et.Subject;
                    String htmlBody = et.HtmlValue;
                    
                    if(htmlBody.contains('{!Lead.OwnerFullName}'))
                        htmlBody = htmlBody.replace('{!Lead.OwnerFullName}', leadRec.Owner.Name);
                    if(htmlBody.contains('{!Lead.Name}'))
                        htmlBody = htmlBody.replace('{!Lead.Name}', leadRec.Name);
                    if(htmlBody.contains('{!Lead.SVDate}'))
                        htmlBody = htmlBody.replace('{!Lead.SVDate}', string.valueOf(leadRec.Site_Visit_Date__c));
                    if(htmlBody.contains('{!Lead.Project}'))
                        htmlBody = htmlBody.replace('{!Lead.Project}', leadRec.ProjectName_formula__c);
                    
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
     public static void notifyCustomer(set<id> leadIdsSet, String templateName){
        try{
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            EmailTemplate et = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where name = :templateName];
            List<Lead__C> leadListToNotify = [Select Id,Name__c,Project_Pickval__c,Site_Visit_Date__c,ProjectName_formula__c,Email__c,owner.Name,owner.Email from Lead__C where Id In : leadIdsSet and Email__c != null];
            
            if(!leadListToNotify.isEmpty()){
                for(Lead__c leadRec : leadListToNotify){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                   
                    List<String> recipients = new List<String>();
                    recipients.add(leadRec.Email__C);
                    system.debug('recipients------' + recipients);
                    mail.setToAddresses(recipients);
                    mail.setReplyTo('test@email.com');
                    mail.setSenderDisplayName('Vaishnavi');
                    String subject = et.Subject;
                    String htmlBody = et.HtmlValue;
                    
                    if(htmlBody.contains('{{!Lead.Name}'))
                        htmlBody = htmlBody.replace('{!Lead.Name}', leadRec.Name__c);
                    if(htmlBody.contains('{!Lead.ProjectName}'))
                        htmlBody = htmlBody.replace('{!Lead.ProjectName}', leadRec.Project_Pickval__c);
                    if(htmlBody.contains('{!Lead.OwnerName}'))
                        htmlBody = htmlBody.replace('{!Lead.OwnerName}', string.valueOf(leadRec.owner.Name));
                    if(htmlBody.contains('{!Lead.OwnerEmail}'))
                        htmlBody = htmlBody.replace('{!Lead.OwnerEmail}', string.valueOf(leadRec.Owner.Email));
                    if(htmlBody.contains('{!Lead.SVDate}'))
                        htmlBody = htmlBody.replace('{!Lead.SVDate}', string.valueOf(leadRec.Site_Visit_Date__c));
                    
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