public without sharing class EmailIUtility {
    public static void notifyPreSalesTeamOnLeadAssignment(set<Id> leadIDs, String templateName){
        try{
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            
            EmailTemplate et = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where name = :templateName];
            List<Lead__c> leadList = [Select Id,Owner.email,Owner.Name,Name,Email__c,Phone__c From Lead__c where id in : leadIDs];
            Id orgWideEmailAddressId = [SELECT Id FROM OrgWideEmailAddress ].Id;
            if(!leadList.isEmpty()){
                for(Lead__c leadRec : leadList){
                    System.debug('leadRec:::'+leadRec);
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setOrgWideEmailAddressId(orgWideEmailAddressId);
                    
                    List<String> recipients = new List<String>();
                    recipients.add(leadRec.Owner.Email);
                    system.debug('recipients------' + recipients);
                    mail.setToAddresses(recipients);
                    // mail.setReplyTo('test@email.com');
                    // mail.setSenderDisplayName('Vaishnavi');
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
            Id orgWideEmailAddressId = [SELECT Id FROM OrgWideEmailAddress ].Id;
            if(!leadList.isEmpty()){
                for(Lead__c leadRec : leadList){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setOrgWideEmailAddressId(orgWideEmailAddressId);
                    
                    List<String> recipients = new List<String>();
                    recipients.add(leadRec.Owner.Email);
                    system.debug('recipients------' + recipients);
                    mail.setToAddresses(recipients);
                    // mail.setReplyTo('test@email.com');
                    // mail.setSenderDisplayName('Vaishnavi');
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
            Id orgWideEmailAddressId = [SELECT Id FROM OrgWideEmailAddress ].Id;
            if(!emailIds.isEmpty()){
                for(string leadEmail : emailIds){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setOrgWideEmailAddressId(orgWideEmailAddressId);
                    
                    List<String> recipients = new List<String>();
                    recipients.add(leadEmail);
                    system.debug('recipients------' + recipients);
                    mail.setToAddresses(recipients);
                    // mail.setReplyTo('test@email.com');
                    // mail.setSenderDisplayName('Vaishnavi');
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
    
    /* Modified By Eshaa */
    public static void firstNotConnectedEmailToCustomer(set<id> leadIdsSet, String templateName){
        try{
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            EmailTemplate et = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where name = :templateName];
            List<Lead__C> leadListToNotify = [Select Id,Name__c,Site_Visit_Date__c,ProjectName_formula__c,Email__c,owner.Name from Lead__C where Id In : leadIdsSet and Email__c != null];
            Id orgWideEmailAddressId = [SELECT Id FROM OrgWideEmailAddress ].Id;
            if(!leadListToNotify.isEmpty()){
                for(Lead__c leadRec : leadListToNotify){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setOrgWideEmailAddressId(orgWideEmailAddressId);
                    
                    List<String> recipients = new List<String>();
                    recipients.add(leadRec.Email__C);
                    system.debug('recipients------' + recipients);
                    mail.setToAddresses(recipients);
                    // mail.setReplyTo('test@email.com');
                    // mail.setSenderDisplayName('Vaishnavi');
                    String subject = et.Subject;
                    String htmlBody = et.HtmlValue;
                    
                    if(!String.isBlank(leadRec.Owner.Name)){
                        htmlBody = htmlBody.replace('{!Lead.OwnerFullName}', leadRec.Owner.Name);
                    }
                    if(!String.isBlank(leadRec.Name__c)){
                        htmlBody = htmlBody.replace('{!Lead.Name}', leadRec.Name__c);
                    }
                    if(leadRec.Site_Visit_Date__c != null){
                        htmlBody = htmlBody.replace('{!Lead.SVDate}', string.valueOf(leadRec.Site_Visit_Date__c));
                    }
                    if(!String.isBlank(leadRec.ProjectName_formula__c)){
                        htmlBody = htmlBody.replace('{!Lead.Project}', leadRec.ProjectName_formula__c);
                    }
                    
                    mail.setSubject(subject);
                    mail.setHtmlBody(htmlBody);
                    mails.add(mail);
                }
                if(!mails.isEmpty()){
                    Messaging.sendEmail(mails);
                }
            }
        } catch (Exception e){
            system.debug('ERROR :: ' + e.getMessage() + 'AT LINE NUMBER :: ' + e.getLineNumber());
            HandleBusinessException.captureError('EmailUtility', 'firstNotConnectedEmailToCustomer', e, null);
        }
    }
    
    /* Modified By Eshaa */
    public static void notifyCustomer(set<id> leadIdsSet, String templateName){
        try{
            system.debug('leadIdsSet ==> '+leadIdsSet);
            system.debug('templateName ==> '+templateName);
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            EmailTemplate et = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where name = :templateName];
            system.debug('et ==> '+et);
            // List<Attachment> files = [SELECT Name, Body, ContentType FROM Attachment WHERE parentId = :et.Id];
            // system.debug('files ====> '+files);
            List<Lead__C> leadListToNotify = [Select Id,Name__c,Project_Pickval__c,Site_Visit_Date__c,ProjectName_formula__c,Email__c,owner.Name,owner.Email,owner.Phone from Lead__C where Id In : leadIdsSet and Email__c != null];
            Id orgWideEmailAddressId = [SELECT Id FROM OrgWideEmailAddress ].Id;
            system.debug('orgWideEmailAddressId ==> '+orgWideEmailAddressId);
            
            if(!leadListToNotify.isEmpty()){
                for(Lead__c leadRec : leadListToNotify){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setOrgWideEmailAddressId(orgWideEmailAddressId);
                    
                    List<String> recipients = new List<String>();
                    recipients.add(leadRec.Email__C);
                    system.debug('recipients------' + recipients);
                    mail.setToAddresses(recipients);
                    // mail.setReplyTo('test@email.com');
                    // mail.setSenderDisplayName('Vaishnavi');
                    String subject = et.Subject;
                    String htmlBody = et.HtmlValue;
                    system.debug('Before HTML Body ----- '+htmlBody);
                    
                    if(!String.isBlank(leadRec.Name__c)){
                        
                        system.debug('Inside Name --------'+htmlBody);
                        htmlBody = htmlBody.replace('{!Lead.Name}', leadRec.Name__c);
                    }
                    if(!String.isBlank(leadRec.Project_Pickval__c)){
                        
                        htmlBody = htmlBody.replace('{!Lead.ProjectName}', leadRec.Project_Pickval__c != null ? leadRec.Project_Pickval__c : '');
                        system.debug('Inside ProjectName --------'+htmlBody);
                    }
                    if(!String.isBlank(leadRec.owner.Name)){
                        
                        htmlBody = htmlBody.replace('{!Lead.OwnerName}', string.valueOf(leadRec.owner.Name));
                        system.debug('Inside OwnerName --------'+htmlBody);
                    }
                    if(!String.isBlank(leadRec.owner.Email)){
                        
                        htmlBody = htmlBody.replace('{!Lead.OwnerEmail}', string.valueOf(leadRec.Owner.Email));
                        system.debug('Inside OwnerEmail --------'+htmlBody);
                    }
                    if(!String.isBlank(leadRec.owner.Phone)){
                        
                        htmlBody = htmlBody.replace('{!Lead.OwnerPhone}', string.valueOf(leadRec.Owner.Phone));
                        system.debug('Inside OwnerPhone --------'+htmlBody);
                    }
                    
                    if(leadRec.Site_Visit_Date__c != null){
                        htmlBody = htmlBody.replace('{!Lead.SVDate}', string.valueOf(leadRec.Site_Visit_Date__c));
                        system.debug('Inside SVDate --------'+htmlBody);
                    }
                    system.debug('htmlBody ==> '+htmlBody);
                    mail.setSubject(subject);
                    mail.setHtmlBody(htmlBody);
                    // List<Messaging.EmailFileAttachment> emailFileAttachments = new List<Messaging.EmailFileAttachment>();
                    // system.debug('et.Attachments ====> '+et.Attachments);
                    // for (Attachment attachment : files) {
                    //     Messaging.EmailFileAttachment emailAttachment = new Messaging.EmailFileAttachment();
                    //     emailAttachment.setFileName(attachment.Name);
                    //     emailAttachment.setBody(attachment.Body);
                    //     system.debug('emailAttachment =====> '+emailAttachment);
                    //     emailFileAttachments.add(emailAttachment);
                    // }
                    // system.debug('emailFileAttachments =====> '+emailFileAttachments);
                    // mail.setFileAttachments(emailFileAttachments);
                    mail.setSubject(subject);
                    mail.setHtmlBody(htmlBody);
                    mails.add(mail);
                    // mails.add(mail);
                }
                if(!mails.isEmpty()){
                    system.debug('mails-->'+mails);
                    Messaging.sendEmail(mails);
                }
            }
        } catch (Exception e){
            system.debug('ERROR :: ' + e.getMessage() + 'AT LINE NUMBER :: ' + e.getLineNumber());
            HandleBusinessException.captureError('EmailUtility', 'notifyCustomer', e, null);
        }
    }
     public static void notifyCustomerForRNR(set<id> leadIdsSet, String templateName){
        try{
            system.debug('leadIdsSet ==> '+leadIdsSet);
            system.debug('templateName ==> '+templateName);
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            EmailTemplate et = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where name = :templateName];
            system.debug('et ==> '+et);
            List<Attachment> files = [SELECT Name, Body, ContentType FROM Attachment WHERE parentId = :et.Id];
            // system.debug('files ====> '+files);
            List<Lead__C> leadListToNotify = [Select Id,Name__c,Project_Pickval__c,Site_Visit_Date__c,ProjectName_formula__c,Email__c,owner.Name,owner.Email,owner.Phone from Lead__C where Id In : leadIdsSet and Email__c != null];
            Id orgWideEmailAddressId = [SELECT Id FROM OrgWideEmailAddress ].Id;
            system.debug('orgWideEmailAddressId ==> '+orgWideEmailAddressId);
            
            if(!leadListToNotify.isEmpty()){
                for(Lead__c leadRec : leadListToNotify){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setOrgWideEmailAddressId(orgWideEmailAddressId);
                    
                    List<String> recipients = new List<String>();
                    recipients.add(leadRec.Email__c);
                    system.debug('recipients------' + recipients);
                    mail.setToAddresses(recipients);
                    // mail.setReplyTo('test@email.com');
                    // mail.setSenderDisplayName('Vaishnavi');
                    String subject = et.Subject;
                    String htmlBody = et.HtmlValue;
                    system.debug('Before HTML Body ----- '+htmlBody);
                    
                    if(!String.isBlank(leadRec.Name__c)){
                        
                        system.debug('Inside Name --------'+htmlBody);
                        htmlBody = htmlBody.replace('{!Lead.Name}', leadRec.Name__c);
                    }
                    if(!String.isBlank(leadRec.Project_Pickval__c)){
                        
                        htmlBody = htmlBody.replace('{!Lead.ProjectName}', leadRec.Project_Pickval__c != null ? leadRec.Project_Pickval__c : '');
                        system.debug('Inside ProjectName --------'+htmlBody);
                        List<Messaging.EmailFileAttachment> emailFileAttachments = new List<Messaging.EmailFileAttachment>();
                        for (Attachment attachment : files) {
                            if(leadRec.Project_Pickval__c.containsIgnoreCase(attachment.Name)){
                                Messaging.EmailFileAttachment emailAttachment = new Messaging.EmailFileAttachment();
                                emailAttachment.setFileName(attachment.Name);
                                emailAttachment.setBody(attachment.Body);
                                emailAttachment.setContentType(attachment.ContentType);
                                system.debug('emailAttachment =====> '+emailAttachment);
                                emailFileAttachments.add(emailAttachment);
                            }
                        }
                        system.debug('emailFileAttachments =====> '+emailFileAttachments);
                        mail.setFileAttachments(emailFileAttachments);
                    }
                    if(!String.isBlank(leadRec.owner.Name)){
                        
                        htmlBody = htmlBody.replace('{!Lead.OwnerName}', string.valueOf(leadRec.owner.Name));
                        system.debug('Inside OwnerName --------'+htmlBody);
                    }
                    if(!String.isBlank(leadRec.owner.Email)){
                        
                        htmlBody = htmlBody.replace('{!Lead.OwnerEmail}', string.valueOf(leadRec.Owner.Email));
                        system.debug('Inside OwnerEmail --------'+htmlBody);
                    }
                    if(!String.isBlank(leadRec.owner.Phone)){
                        
                        htmlBody = htmlBody.replace('{!Lead.OwnerPhone}', string.valueOf(leadRec.Owner.Phone));
                        system.debug('Inside OwnerPhone --------'+htmlBody);
                    }
                    
                    if(leadRec.Site_Visit_Date__c != null){
                        htmlBody = htmlBody.replace('{!Lead.SVDate}', string.valueOf(leadRec.Site_Visit_Date__c));
                        system.debug('Inside SVDate --------'+htmlBody);
                    }
                    system.debug('htmlBody ==> '+htmlBody);
                    mail.setSubject(subject);
                    mail.setHtmlBody(htmlBody);
                    // List<Messaging.EmailFileAttachment> emailFileAttachments = new List<Messaging.EmailFileAttachment>();
                    // system.debug('et.Attachments ====> '+et.Attachments);
                    // for (Attachment attachment : files) {
                    //     Messaging.EmailFileAttachment emailAttachment = new Messaging.EmailFileAttachment();
                    //     emailAttachment.setFileName(attachment.Name);
                    //     emailAttachment.setBody(attachment.Body);
                    //     system.debug('emailAttachment =====> '+emailAttachment);
                    //     emailFileAttachments.add(emailAttachment);
                    // }
                    // system.debug('emailFileAttachments =====> '+emailFileAttachments);
                    // mail.setFileAttachments(emailFileAttachments);
                    mail.setSubject(subject);
                    mail.setHtmlBody(htmlBody);
                    mails.add(mail);
                    // mails.add(mail);
                }
                if(!mails.isEmpty()){
                    system.debug('mails-->'+mails);
                    Messaging.sendEmail(mails);
                }
            }
        } catch (Exception e){
            system.debug('ERROR :: ' + e.getMessage() + 'AT LINE NUMBER :: ' + e.getLineNumber());
            HandleBusinessException.captureError('EmailUtility', 'notifyCustomer', e, null);
        }
    }
    
     public static void notifyCustomerForDroppedDueToReason(set<id> leadIdsSet, String templateName){
        try{
            system.debug('leadIdsSet ==> '+leadIdsSet);
            system.debug('templateName ==> '+templateName);
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            EmailTemplate et = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where name = :templateName];
            system.debug('et ==> '+et);
            List<Attachment> files = [SELECT Name, Body, ContentType FROM Attachment WHERE parentId = :et.Id and Name = 'Dropped'];
            // system.debug('files ====> '+files);
            List<Lead__C> leadListToNotify = [Select Id,Name__c,Project_Pickval__c,Site_Visit_Date__c,ProjectName_formula__c,Email__c,owner.Name,owner.Email,owner.Phone from Lead__C where Id In : leadIdsSet and Email__c != null];
            Id orgWideEmailAddressId = [SELECT Id FROM OrgWideEmailAddress ].Id;
            system.debug('orgWideEmailAddressId ==> '+orgWideEmailAddressId);
            
            if(!leadListToNotify.isEmpty()){
                for(Lead__c leadRec : leadListToNotify){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setOrgWideEmailAddressId(orgWideEmailAddressId);
                    
                    List<String> recipients = new List<String>();
                    recipients.add(leadRec.Email__c);
                    system.debug('recipients------' + recipients);
                    mail.setToAddresses(recipients);
                    // mail.setReplyTo('test@email.com');
                    // mail.setSenderDisplayName('Vaishnavi');
                    String subject = et.Subject;
                    String htmlBody = et.HtmlValue;
                    system.debug('Before HTML Body ----- '+htmlBody);
                    
                    if(!String.isBlank(leadRec.Name__c)){
                        
                        system.debug('Inside Name --------'+htmlBody);
                        htmlBody = htmlBody.replace('{!Lead.Name}', leadRec.Name__c);
                    }
                    if(!String.isBlank(leadRec.Project_Pickval__c)){
                        
                        htmlBody = htmlBody.replace('{!Lead.ProjectName}', leadRec.Project_Pickval__c != null ? leadRec.Project_Pickval__c : '');
                        system.debug('Inside ProjectName --------'+htmlBody);
                        List<Messaging.EmailFileAttachment> emailFileAttachments = new List<Messaging.EmailFileAttachment>();
                        for (Attachment attachment : files) {
                            Messaging.EmailFileAttachment emailAttachment = new Messaging.EmailFileAttachment();
                            emailAttachment.setFileName(attachment.Name);
                            emailAttachment.setBody(attachment.Body);
                            emailAttachment.setContentType(attachment.ContentType);
                            system.debug('emailAttachment =====> '+emailAttachment);
                            emailFileAttachments.add(emailAttachment);
                        }
                        system.debug('emailFileAttachments =====> '+emailFileAttachments);
                        mail.setFileAttachments(emailFileAttachments);
                    }
                    if(!String.isBlank(leadRec.owner.Name)){
                        
                        htmlBody = htmlBody.replace('{!Lead.OwnerName}', string.valueOf(leadRec.owner.Name));
                        system.debug('Inside OwnerName --------'+htmlBody);
                    }
                    if(!String.isBlank(leadRec.owner.Email)){
                        
                        htmlBody = htmlBody.replace('{!Lead.OwnerEmail}', string.valueOf(leadRec.Owner.Email));
                        system.debug('Inside OwnerEmail --------'+htmlBody);
                    }
                    if(!String.isBlank(leadRec.owner.Phone)){
                        
                        htmlBody = htmlBody.replace('{!Lead.OwnerPhone}', string.valueOf(leadRec.Owner.Phone));
                        system.debug('Inside OwnerPhone --------'+htmlBody);
                    }
                    
                    if(leadRec.Site_Visit_Date__c != null){
                        htmlBody = htmlBody.replace('{!Lead.SVDate}', string.valueOf(leadRec.Site_Visit_Date__c));
                        system.debug('Inside SVDate --------'+htmlBody);
                    }
                    system.debug('htmlBody ==> '+htmlBody);
                    mail.setSubject(subject);
                    mail.setHtmlBody(htmlBody);
                    // List<Messaging.EmailFileAttachment> emailFileAttachments = new List<Messaging.EmailFileAttachment>();
                    // system.debug('et.Attachments ====> '+et.Attachments);
                    // for (Attachment attachment : files) {
                    //     Messaging.EmailFileAttachment emailAttachment = new Messaging.EmailFileAttachment();
                    //     emailAttachment.setFileName(attachment.Name);
                    //     emailAttachment.setBody(attachment.Body);
                    //     system.debug('emailAttachment =====> '+emailAttachment);
                    //     emailFileAttachments.add(emailAttachment);
                    // }
                    // system.debug('emailFileAttachments =====> '+emailFileAttachments);
                    // mail.setFileAttachments(emailFileAttachments);
                    mail.setSubject(subject);
                    mail.setHtmlBody(htmlBody);
                    mails.add(mail);
                    // mails.add(mail);
                }
                if(!mails.isEmpty()){
                    system.debug('mails-->'+mails);
                    Messaging.sendEmail(mails);
                }
            }
        } catch (Exception e){
            system.debug('ERROR :: ' + e.getMessage() + 'AT LINE NUMBER :: ' + e.getLineNumber());
            HandleBusinessException.captureError('EmailUtility', 'notifyCustomer', e, null);
        }
    }
    
    /* Modified By Eshaa */
    public static void notifyVaishnaviTeam(set<id> leadIdsSet, String templateName){
        try{
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            EmailTemplate et = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where name = :templateName];
            List<Lead__C> leadListToNotify = [Select Id,Name__c,Project_Pickval__c,Phone__c,hrefLink__c	,Lead_Source_Type__c,Site_Visit_Date__c,ProjectName_formula__c,Email__c,owner.Name,owner.Email from Lead__C where Id In : leadIdsSet and Email__c != null];
            Id orgWideEmailAddressId = [SELECT Id FROM OrgWideEmailAddress ].Id;
            system.debug('orgWideEmailAddressId ==> '+orgWideEmailAddressId);
            
            if(!leadListToNotify.isEmpty()){
                for(Lead__c leadRec : leadListToNotify){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setOrgWideEmailAddressId(orgWideEmailAddressId);
                    
                    List<String> recipients = new List<String>();
                    recipients.add(leadRec.owner.Email);
                    system.debug('recipients------' + recipients);
                    mail.setToAddresses(recipients);
                    // mail.setReplyTo('test@email.com');
                    // mail.setSenderDisplayName('Vaishnavi');
                    String subject = et.Subject;
                    String htmlBody = et.HtmlValue;
                    
                    if(!String.isBlank(leadRec.Name__c)){
                        system.debug('Inside Name --------'+htmlBody);
                        htmlBody = htmlBody.replace('{!Lead.Name}', leadRec.Name__c);
                    }
                    if(!String.isBlank(leadRec.Project_Pickval__c)){
                        htmlBody = htmlBody.replace('{!Lead.ProjectName}', leadRec.Project_Pickval__c != null ? leadRec.Project_Pickval__c : '');
                        system.debug('Inside ProjectName --------'+htmlBody);
                    }
                    if(!String.isBlank(leadRec.owner.Name)){
                        htmlBody = htmlBody.replace('{!Lead.OwnerName}', string.valueOf(leadRec.owner.Name));
                        system.debug('Inside OwnerName --------'+htmlBody);
                    }
                    if(!String.isBlank(leadRec.owner.Email)){
                        htmlBody = htmlBody.replace('{!Lead.OwnerEmail}', string.valueOf(leadRec.Owner.Email));
                        system.debug('Inside OwnerEmail --------'+htmlBody);
                    }
                    if(!String.isBlank(leadRec.Lead_Source_Type__c)){
                        htmlBody = htmlBody.replace('{!Lead.Lead_Source_Type__c}', string.valueOf(leadRec.Lead_Source_Type__c));
                        system.debug('Inside LeadSourceType --------'+htmlBody);
                    }
                    if(!String.isBlank(leadRec.Phone__c)){
                        htmlBody = htmlBody.replace('{!Lead.Phone}', string.valueOf(leadRec.Phone__c));
                        system.debug('Inside LeadPhone --------'+htmlBody);
                    }
                    if(!String.isBlank(leadRec.Email__c)){
                        htmlBody = htmlBody.replace('{!Lead.Email__c}', string.valueOf(leadRec.Email__c));
                        system.debug('Inside LeadEmail --------'+htmlBody);
                    }
                    if(!String.isBlank(leadRec.hrefLink__c)){
                        htmlBody = htmlBody.replace('{!Lead.Link}', string.valueOf(leadRec.hrefLink__c));
                        system.debug('Inside LeadLink --------'+htmlBody);
                    }
                    
                    mail.setSubject(subject);
                    mail.setHtmlBody(htmlBody);
                    mails.add(mail);
                }
                if(!mails.isEmpty()){
                    Messaging.sendEmail(mails);
                }
            }
        } catch (Exception e){
            system.debug('ERROR :: ' + e.getMessage() + 'AT LINE NUMBER :: ' + e.getLineNumber());
            HandleBusinessException.captureError('EmailUtility', 'notifyVaishnaviTeam', e, null);
        }
    }
    
    public static void notifyVaishnaviTeamForSV(set<id> siteVisitIds, String templateName){
        try{
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            EmailTemplate et = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where name = :templateName];
            List<Visit__c> siteVisitList = [Select Id,Name__c,Name,Opportunities__r.owner.Email,Opportunities__r.owner.Name,SV_Link__c,Attending_Sales_Manager__r.Email,Owner.Email,Owner.Name from Visit__c where Id In : siteVisitIds];
            Id orgWideEmailAddressId = [SELECT Id FROM OrgWideEmailAddress ].Id;
            system.debug('orgWideEmailAddressId ==> '+orgWideEmailAddressId);
            
            if(!siteVisitList.isEmpty()){
                for(Visit__c visitRec : siteVisitList){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setOrgWideEmailAddressId(orgWideEmailAddressId);
                    
                    List<String> recipients = new List<String>();
                    
                    recipients.add(visitRec.Owner.Email);
                    if(visitRec.Attending_Sales_Manager__c != null){
                        mail.setCcAddresses( new List<String> {visitRec.Attending_Sales_Manager__r.Email});
                        //recipients.add(visitRec.Attending_Sales_Manager__r.Email);
                    }
                    system.debug('recipients------' + recipients);
                    mail.setToAddresses(recipients);
                    
                    String subject = et.Subject;
                    String htmlBody = et.HtmlValue;
                    
                    htmlBody = htmlBody.replace('{!SiteVisit.OwnerName}', visitRec.Owner.Name);
                    htmlBody = htmlBody.replace('{!Site_Visit__c.Name}', visitRec.Name);
                    htmlBody = htmlBody.replace('{!Site_Visit__c.Link}', string.valueOf(visitRec.SV_Link__c));
                    
                    mail.setSubject(subject);
                    mail.setHtmlBody(htmlBody);
                    mails.add(mail);
                }
                if(!mails.isEmpty()){
                    Messaging.sendEmail(mails);
                }
            }
        } catch (Exception e){
            system.debug('ERROR :: ' + e.getMessage() + 'AT LINE NUMBER :: ' + e.getLineNumber());
            HandleBusinessException.captureError('EmailUtility', 'notifyVaishnaviTeam', e, null);
        }
    }
    public static void sendExceptions(Exception__c exceps){
        //Error Template
        try{
            EmailTemplate ErrorEmailtemplate = [Select id, Name, DeveloperName, Subject, Body, HtmlValue
                                                from EmailTemplate
                                                where name = 'Error Template'];
            String Email = 'aakash.jain@utilitarianLab.com';
            String Email2 = 'isha.raj@utilitarianLab.com';
            
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> recipients = new List<String>();
            recipients.add(Email);
            recipients.add(Email2);
            
            System.debug('recipients ====> ' + recipients);
            mail.setToAddresses(recipients);
            mail.setReplyTo('Vaishnavi@mailinator.com');
            mail.setSenderDisplayName('Vaishnavi');
            String subject = ErrorEmailtemplate.Subject;
            String htmlBody = ErrorEmailtemplate.HtmlValue;
            //System.debug('htmlBody ====> ' + htmlBody);
            //System.debug('referrar Name ===>' + ReferrarNameWithEmail.get(Email));
            
            if (htmlBody.contains('{!Exceptions__c.Class_Name__c}')){
                htmlBody = htmlBody.replace('{!Exceptions__c.Class_Name__c}', exceps.Class_Name__c);
            }
            if (htmlBody.contains('{!Exceptions__c.Error_Message__c}')){
                htmlBody = htmlBody.replace('{!Exceptions__c.Error_Message__c}', exceps.Error_Message__c);
            }
            if (htmlBody.contains('{!Exceptions__c.Error_Line_No__c}')){
                htmlBody = htmlBody.replace('{!Exceptions__c.Error_Line_No__c}', String.valueof(exceps.Error_Line_No__c));
            }
            mail.setSubject(subject);
            mail.setHtmlBody(htmlBody);
            mails.add(mail);
            System.debug('mails =====> ' + mails);
            
            if (!mails.isEmpty()){
                Messaging.sendEmail(mails);
            }
        }catch (Exception e){
            system.debug('ERROR :: ' + e.getMessage() + 'AT LINE NUMBER :: ' + e.getLineNumber());
            HandleBusinessException.captureError('EmailIUtility', 'sendExceptions', e , null);
            
        }
    }
    
     public static void notifyPreSalesForLeadDroppedBySales(set<id> leadIds, String templateName){
        try{
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            EmailTemplate et = [Select id, Name, DeveloperName, Subject, Body, HtmlValue from EmailTemplate where name = :templateName];
            List<Lead__c> leadList = [Select Id,Name,Name__c,Pre_Sales_Team_Member__r.Email,Pre_Sales_Team_Member__r.Name,hrefLink__c from Lead__c where Id In : leadIds];
            Id orgWideEmailAddressId = [SELECT Id FROM OrgWideEmailAddress ].Id;
            system.debug('orgWideEmailAddressId ==> '+orgWideEmailAddressId);
            
            if(!leadList.isEmpty()){
                for(Lead__c leadRec : leadList){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setOrgWideEmailAddressId(orgWideEmailAddressId);
                    
                    List<String> recipients = new List<String>();
                    
                    recipients.add(leadRec.Owner.Email);
                  
                    system.debug('recipients------' + recipients);
                    mail.setToAddresses(recipients);
                    
                    String subject = et.Subject;
                    String htmlBody = et.HtmlValue;
                    
                    htmlBody = htmlBody.replace('{!Lead__c.PreSalesOwner}', leadRec.Pre_Sales_Team_Member__r.Name);
                    htmlBody = htmlBody.replace('{!Lead.Name}', leadRec.Name);
                    htmlBody = htmlBody.replace('{!Lead.Link}', string.valueOf(leadRec.hrefLink__c));
                    
                    mail.setSubject(subject);
                    mail.setHtmlBody(htmlBody);
                    mails.add(mail);
                }
                if(!mails.isEmpty()){
                    Messaging.sendEmail(mails);
                }
            }
        } catch (Exception e){
            system.debug('ERROR :: ' + e.getMessage() + 'AT LINE NUMBER :: ' + e.getLineNumber());
            HandleBusinessException.captureError('EmailUtility', 'notifyVaishnaviTeam', e, null);
        }
    }
}