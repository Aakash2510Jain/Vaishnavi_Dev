@isTest
public class SendBookingFormsControllerTest {
	@isTest
    static void testSendPremiereBookingForm(){
        Opportunity__c opp = new Opportunity__c(Opportunity_Name__c = 'Test Opportunity',Email__c = 'Test@gmail.com');
        insert opp;
               
        EmailTemplate validEmailTemplate;
        System.runAs (new User(Id = UserInfo.getUserId()) ){
            validEmailTemplate = new EmailTemplate();
            validEmailTemplate.isActive = true;
            validEmailTemplate.Name = 'Testing email Template';
            validEmailTemplate.DeveloperName = 'Test';
            validEmailTemplate.TemplateType = 'text';
            validEmailTemplate.FolderId = '00D1m0000008pgzEAA';
            
            validEmailTemplate.Body = 'test Record';
            insert validEmailTemplate;
        }
        
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        EmailTemplate temp = [SELECT Id,Subject,Body,HtmlValue FROM EmailTemplate WHERE Name ='Testing email Template'];
        
        String htmlBody = temp.HTMLValue;
        String subject = temp.Subject;
        String plainTextBody = temp.body; 
        
        List<String> ToaddressList = new List<String>{'test@gmail.com'};
        List<String> toBccAddressList = new List<String>{'test1@gmail.com'};    
                
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        mail.setHtmlBody(htmlBody);
        mail.setSubject(subject);
        mail.setPlainTextBody(plainTextBody);
        mail.setToAddresses(ToaddressList);
        mail.setCcAddresses(toBccAddressList);
       
        mailList.add(mail);
        
        System.debug('EMIL SUCCESS::'+mailList);   
        if(!mailList.isEmpty()){
            Messaging.sendEmail(mailList);
        }
        
        test.startTest();
        SendBookingFormsController.sendPremiereBookingForm(opp.id);
        test.stopTest();
        
       
    }
    
    @isTest
    static void testSendLifeBookingForm(){
        Opportunity__c opp = new Opportunity__c(Opportunity_Name__c = 'Test Opportunity',Email__c = 'Test@gmail.com');
        insert opp;
               
        EmailTemplate validEmailTemplate;
        System.runAs (new User(Id = UserInfo.getUserId()) ){
            validEmailTemplate = new EmailTemplate();
            validEmailTemplate.isActive = true;
            validEmailTemplate.Name = 'Testing email Template';
            validEmailTemplate.DeveloperName = 'Test';
            validEmailTemplate.TemplateType = 'text';
            validEmailTemplate.FolderId = '00D1m0000008pgzEAA';
            
            validEmailTemplate.Body = 'test Record';
            insert validEmailTemplate;
        }
        
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        EmailTemplate temp = [SELECT Id,Subject,Body,HtmlValue FROM EmailTemplate WHERE Name ='Testing email Template'];
        
        String htmlBody = temp.HTMLValue;
        String subject = temp.Subject;
        String plainTextBody = temp.body; 
        
        List<String> ToaddressList = new List<String>{'test@gmail.com'};
        List<String> toBccAddressList = new List<String>{'test1@gmail.com'};    
                
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        mail.setHtmlBody(htmlBody);
        mail.setSubject(subject);
        mail.setPlainTextBody(plainTextBody);
        mail.setToAddresses(ToaddressList);
        mail.setCcAddresses(toBccAddressList);
       
        mailList.add(mail);
        
        System.debug('EMIL SUCCESS::'+mailList);   
        if(!mailList.isEmpty()){
            Messaging.sendEmail(mailList);
        }
        
        test.startTest();
        SendBookingFormsController.sendLifeBookingForm(opp.id);
        test.stopTest();
        
       
    }
    
    
    @isTest
    static void testSendSereneBookingForm(){
        Opportunity__c opp = new Opportunity__c(Opportunity_Name__c = 'Test Opportunity',Email__c = 'Test@gmail.com');
        insert opp;
               
        EmailTemplate validEmailTemplate;
        System.runAs (new User(Id = UserInfo.getUserId()) ){
            validEmailTemplate = new EmailTemplate();
            validEmailTemplate.isActive = true;
            validEmailTemplate.Name = 'Testing email Template';
            validEmailTemplate.DeveloperName = 'Test';
            validEmailTemplate.TemplateType = 'text';
            validEmailTemplate.FolderId = '00D1m0000008pgzEAA';
            
            validEmailTemplate.Body = 'test Record';
            insert validEmailTemplate;
        }
        
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        EmailTemplate temp = [SELECT Id,Subject,Body,HtmlValue FROM EmailTemplate WHERE Name ='Testing email Template'];
        
        String htmlBody = temp.HTMLValue;
        String subject = temp.Subject;
        String plainTextBody = temp.body; 
        
        List<String> ToaddressList = new List<String>{'test@gmail.com'};
        List<String> toBccAddressList = new List<String>{'test1@gmail.com'};    
                
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        mail.setHtmlBody(htmlBody);
        mail.setSubject(subject);
        mail.setPlainTextBody(plainTextBody);
        mail.setToAddresses(ToaddressList);
        mail.setCcAddresses(toBccAddressList);
       
        mailList.add(mail);
        
        System.debug('EMIL SUCCESS::'+mailList);   
        if(!mailList.isEmpty()){
            Messaging.sendEmail(mailList);
        }
        
        test.startTest();
        SendBookingFormsController.sendSereneBookingForm(opp.id);
        test.stopTest();
        
       
    }
    
    
    
}