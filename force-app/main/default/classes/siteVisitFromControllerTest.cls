@isTest
public with sharing class siteVisitFromControllerTest {

    @isTest
    static void testgetProjectsData(){

        Profile profileId = [SELECT Id, Name FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        List<User> testUsers = new List<User>();
        User usr = new User(LastName = 'LIVESTON1',
                            FirstName='JASON1',
                            Alias = 'jlive',
                            Email = 'jason12.liveston1@asdf.com',
                            Username = 'jason12.liveston1@asdf.com',
                            ProfileId = profileId.id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            LocaleSidKey = 'en_US'
                           );

        insert usr;

        Project__c proj = New Project__c();
        proj.Name = 'Vaishnavi serene';
        insert proj;

        Project_GRE_Association__c pGRE = New Project_GRE_Association__c();
        pGRE.Project__c = proj.Id;
        pGRE.GRE__c = usr.Id;
        insert pGRE;

        string GREId = [SELECT Id,Project__c From Project_GRE_Association__c WHERE GRE__c =: pGRE.GRE__c].Project__c;

    }

    @isTest
    static void testcreateCloneVisit(){
        
        Opportunity__c oppRecord = New Opportunity__c();
        oppRecord.Opportunity_Name__c = 'testOppName';
        insert oppRecord;

        Visit__c visitRec = New Visit__c();
        visitRec.Opportunities__c = oppRecord.Id;
        insert visitRec;

        siteVisitFormController.createCloneVisit(visitRec.id);

    }

    @isTest
    static void testcloneOpportunityAndSV(){

        Account accRec = New Account();
        accRec.Name = 'test Account';
        insert accRec;

        Opportunity__c oppRec = New Opportunity__c();
        oppRec.AccountId__c = accRec.Id;
        oppRec.Opportunity_Name__c = 'Test Opportunity';
        oppRec.Stage__c = 'Lost';
        oppRec.Email__c = 'isha@gmail.com';
        oppRec.Phone__c = '9599845667';
        
        insert oppRec;

        Visit__c visitRec = New Visit__c();
        visitRec.Name__c = 'test';
        // visitRec.Opportunities__c = clonedRecord.Id;
        insert visitRec;

        siteVisitFormController.cloneOpportunityAndSV(oppRec.Id,visitRec.id);
    }

    @isTest
    static void testcloneOppForDiffProject(){

        Account accRec = New Account();
        accRec.Name = 'test Account';
        insert accRec;

        Project__c project = New Project__c();
        project.Name = 'Test Project';
        insert project;

        Opportunity__c oppRec = New Opportunity__c();
        oppRec.AccountId__c = accRec.Id;
        oppRec.Opportunity_Name__c = 'Test Opportunity';
        oppRec.Stage__c = 'Lost';
        oppRec.Project__c = project.Id;
        oppRec.Email__c = 'isha@gmail.com';
        oppRec.Phone__c = '9599845667';
        
        insert oppRec;

        siteVisitFormController.cloneOppForDiffProject(oppRec.Id,project.Id);
    }

    @isTest
    static void testgetLeadRecords(){
        Lead__c leadRec = New Lead__c();
        leadRec.Name__c = 'Test lead';
        leadRec.Email__c = 'isha999raj@gmail.com';
        leadRec.Phone__c = '9599836568';
        insert leadRec;

        siteVisitFormController.getLeadRecords(leadRec.Email__c);

        // string phonestring = '%' +leadRec.Email__c;
        // List<Lead__c> leadList = [select id,Name__c,Email__c,Phone__c From Lead__c where Email__c =:leadRec.Email__c OR Phone__c LIKE :phonestring order by lastModifiedDate Desc limit 1];
    }

    @isTest
    static void testcreateLeadRecord(){

        Lead__c leadRecord = New Lead__c();
        leadRecord.Name__c = 'test Lead';
        leadRecord.Email__c = 'test@mail.com';
        leadRecord.Phone__c = '9599836568';
        insert leadRecord;

        siteVisitFormController.createLeadRecord(leadRecord);
    }

    @isTest
    static void testgetVisitRecord(){

        Lead__c leadRecord = New Lead__c();
        leadRecord.Name__c = 'test Lead';
        leadRecord.Email__c = 'test@mail.com';
        leadRecord.Phone__c = '9599836568';
        insert leadRecord;
        siteVisitFormController.getVisitRecord(leadRecord.Id);
        // Visit__c visitRec = New Visit__c();
        // visitRec.lead__C = leadRecord.Id;
        // insert visitRec;
        
        // Visit__c existingvisitRecord = [SELECT Id,Name__c,Lead__c FROM Visit__c WHERE Lead__c =: leadRecord.Id];
    }
    
    @isTest
    static void testgetChannelPartners(){

        
        siteVisitFormController.getChannelPartners();
    }
    
    @isTest
    static void testgetSalesManager(){
        Profile profileId = [SELECT Id, Name FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        List<User> testUsers = new List<User>();
        User usr = new User(LastName = 'LIVESTON1',
                            FirstName='JASON1',
                            Alias = 'jlive',
                            Email = 'jason12.liveston1@asdf.com',
                            Username = 'jason12.liveston1@asdf.com',
                            ProfileId = profileId.id,
                            TimeZoneSidKey = 'GMT',
                            LanguageLocaleKey = 'en_US',
                            EmailEncodingKey = 'UTF-8',
                            LocaleSidKey = 'en_US'
                           );

        insert usr;
        siteVisitFormController.getSalesManager();
    }
    
    @isTest
    static void testgetLocationList(){

        Location__c locat = New Location__c();
        locat.Name = 'testLoc';
        insert locat;
        siteVisitFormController.getLocationList();
    }

    @isTest
    static void testinsertVisitRecord(){

        Integer year = 2023;
        Integer day = 11;
        Integer month = 11;
        Integer visityear = 2023;
        Integer visitday = 11;
        Integer visitmonth = 11;

        Visit__c visitRec = New Visit__c();
        visitRec.Date_Of_Birth__c = Date.newInstance(year, month, day); 
        visitRec.Actual_visit_date__c = Date.newInstance(visityear, visitmonth, visitday);
        insert visitRec;

        Lead__c leadRecord = New Lead__c();
        leadRecord.Name__c = 'test Lead';
        leadRecord.Email__c = 'test@mail.com';
        leadRecord.Phone__c = '9599836568';
        insert leadRecord;

        Location__c locationRec = new Location__c();
        locationRec.Name = 'Test';
        insert locationRec;
            
        siteVisitFormController.insertVisitRecord(visitRec,leadRecord.Id,year,month,day,visityear,visitmonth,visitday,'Test');

    }

    @isTest
    static void testinsertVisitRecordUnderOpportunity(){
        Integer year = 2023;
        Integer day = 11;
        Integer month = 11;
        Integer visityear = 2023;
        Integer visitday = 11;
        Integer visitmonth = 11;

        Visit__c visitRec = New Visit__c();
        visitRec.Date_Of_Birth__c = Date.newInstance(year, month, day); 
        visitRec.Actual_visit_date__c = Date.newInstance(visityear, visitmonth, visitday);
        insert visitRec;

        siteVisitFormController.insertVisitRecordUnderOpportunity(visitRec,year,month,day,visityear,visitmonth,visitday);

        // Visit__c visitRecUpdate = New Visit__c(); 
        // visitRecUpdate.Id = visitRec.Id;
        // visitRecUpdate.Actual_visit_date__c = Date.newInstance(2022, 12, 12);
        // update visitRecUpdate;
    }

    @isTest
    static void testupdateVisitRecord(){
        Integer year = 2023;
        Integer day = 11;
        Integer month = 11;
        Integer visityear = 2023;
        Integer visitday = 11;
        Integer visitmonth = 11;

        Explorer_Configuration__c cpConfigs = new Explorer_Configuration__c();
        cpConfigs.Name = 'Channel Partner';
        cpConfigs.Folders__c = 'A,B';
        insert cpConfigs;
            
        Visit__c visitRec = New Visit__c();
        visitRec.Date_Of_Birth__c = Date.newInstance(year, month, day); 
        visitRec.Actual_visit_date__c = Date.newInstance(visityear, visitmonth, visitday);
        insert visitRec;
        
        Channel_Partner__c cp = New Channel_Partner__c();
        cp.Name = 'Test CP';
        insert cp;

        siteVisitFormController.updateVisitRecord(visitRec,cp.Id);
    }

    @isTest
    static void testupdateGREDetails(){
        Integer shour = 10;
        Integer sMin = 10;
        Visit__c visitRec = New Visit__c();
        visitRec.Name__c = 'visitName';
        visitRec.Customer_Time_In__c = Time.newInstance(11, 10, 0, 0);
        insert visitRec;

        siteVisitFormController.updateGREDetails(visitRec,shour,sMin);
    }

    @isTest
    static void testfinalSubmit(){
        Visit__c visitRec = New Visit__c();
        visitRec.Name__c = 'visitName';
        insert visitRec;

        siteVisitFormController.finalSubmit(visitRec);
        
        siteVisitFormController.ageGroup  = 'a';
        siteVisitFormController.employmentType  = 'a'; 
        siteVisitFormController.budget  = 'a';
        siteVisitFormController.area  = 'a';
        siteVisitFormController.constructionStatus  = 'a';
        siteVisitFormController.purposeOfBuying  = 'a';
        siteVisitFormController.walkinSource  = 'a';
        // siteVisitFormController.walkinSubSource  = 'a';
        siteVisitFormController.gender  = 'a';
        siteVisitFormController.facilitatedBy  = 'a';
        siteVisitFormController.classification  = 'a';
        siteVisitFormController.leadClassification  = 'a'; 
        siteVisitFormController.closedReason  = 'a';
        siteVisitFormController.ownership  = 'a';
        siteVisitFormController.sourceOfFunding  = 'a'; 
        siteVisitFormController.ethnicity  = 'a';
        siteVisitFormController.flatType  = 'a';
        siteVisitFormController.UserId  = 'a';
        
    }
    @isTest
    static void searchLeadTest(){
        Lead__c leadRec = new Lead__c();
        leadRec.Email__c = 'test@mailinator.com';
        insert leadRec; 
        
        Lead__c leadRec1 = new Lead__c();
        leadRec1.Email__c = 'test1@mailinator.com';
        leadRec1.isConverted__c = true;
        insert leadRec1;
        
        Project__c project = New Project__c();
        project.Name = 'Test Project';
        insert project;
        
        siteVisitFormController.searchLead('test@mailinator.com',project.Id);
        siteVisitFormController.searchLead('test1@mailinator.com',project.Id);
        siteVisitFormController.searchLead(NULL,NULL);
    }
    @isTest
    static void testConstructor() {
        Test.startTest();
        siteVisitFormController controller = new siteVisitFormController();
        Test.stopTest();
    }
}