@isTest
public class EmailIUtilityTest {
    @isTest
    static void testNotifyPreSalesTeamOnLeadAssignment(){
        
        List<Lead__c> ldList = new List<Lead__c>();
               
        EmailTemplate et = new EmailTemplate();
        System.runAs (new User(Id = UserInfo.getUserId()) ){
       	et.Name = 'test_Email_Tempate';
        et.DeveloperName = 'xyz';
       // et.FolderName = 'aaa';
        et.Subject = 'Test Subject';
        et.TemplateType = 'text';
        et.FolderId = '00D1m0000008pgzEAA';
        et.Body = 'test Record';
        et.HtmlValue = '<html><body>{!Lead.Name}</body></html>';
        insert et;
        }
        
        Lead__c testLead = new Lead__c( Name__c = 'Test Lead', Email__c = 'testlead@test.com', Phone__c = '1234567890');
        insert testLead;
        
        Set<id> leadIds = new Set<Id> {testLead.Id};
        
       // Set<Id> leadIds = new Set<Id>{ ldList[0].Id };
            
        Test.startTest();
        EmailIUtility.notifyPreSalesTeamOnLeadAssignment(leadIds,et.Name);
        Test.stopTest();
    }
    
    
    @isTest
    static void testnotifySalesTeamOnLeadAssignment(){
        
        List<Lead__c> ldList = new List<Lead__c>();
               
        EmailTemplate et = new EmailTemplate();
        System.runAs (new User(Id = UserInfo.getUserId()) ){
       	et.Name = 'test_Email_Tempate';
        et.DeveloperName = 'xyz';
       // et.FolderName = 'aaa';
        et.Subject = 'Test Subject';
        et.TemplateType = 'text';
        et.FolderId = '00D1m0000008pgzEAA';
        et.Body = 'test Record';
        et.HtmlValue = '<html><body>{!Lead.Name}</body></html>';
        insert et;
        }
        
        Lead__c testLead = new Lead__c( Name__c = 'Test Lead', Email__c = 'testlead@test.com', Phone__c = '1234567890');
        insert testLead;
        
        Set<id> leadIds = new Set<Id> {testLead.Id};
        
       // Set<Id> leadIds = new Set<Id>{ ldList[0].Id };
            
        Test.startTest();
        EmailIUtility.notifySalesTeamOnLeadAssignment(leadIds,et.Name);
        Test.stopTest();
    }
    	
        /*
        @isTest
        static void testnotifySalesTeamOnLeadAssignment(){
        Lead__c testLead = new Lead__c(Name__c = 'Test Lead',Email__c = 'test@example.com',Phone__c = '1234567890');
        insert testLead;
        
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
        
        // List<Lead__c> leadList = [Select Id,Owner.email,Owner.Name,Name,Email__c,Phone__c From Lead__c where id in : leadIDs];
        
        Set<Id> leadIds = new Set<Id>{ testLead.Id };
        
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
        EmailIUtility.notifySalesTeamOnLeadAssignment(leadIds,'Testing email Template');
        test.stopTest();
        
        }  */
          
}