@isTest
public class LeadTriggerHandlerTest {
   /* @isTest
    static void testgetInstance(){
        
        LeadTriggerHandler handlerInstance = LeadTriggerHandler.getInstance();
        
        List<Lead__c> listOfLeads = new List<Lead__c>();
        List<Lead__c> listOfLeads2 = new List<Lead__c>();
        List<Lead__c> listOfLeads3 = new List<Lead__c>();
        List<Lead__c> listOfLeads4 = new List<Lead__c>();
        List<Lead__c> listOfLeads5 = new List<Lead__c>();
        List<Lead__c> listOfLeads6 = new List<Lead__c>();
        List<Lead__c> listOfLeads7 = new List<Lead__c>();
        List<Lead__c> listOfLeads8 = new List<Lead__c>();
        List<Lead__c> listOfLeads9 = new List<Lead__c>();
        List<Lead__c> listOfLeads10 = new List<Lead__c>();
        List<Lead__c> listOfLeads11 = new List<Lead__c>();
        List<Lead__c> listOfLeads12 = new List<Lead__c>();
        List<Lead__c> listOfLeads13 = new List<Lead__c>();
        List<Lead__c> listOfLeads14 = new List<Lead__c>();
        List<Lead__c> listOfLeads15 = new List<Lead__c>();
        List<Lead__c> listOfLeads16 = new List<Lead__c>();
        List<Lead__c> listOfLeads17 = new List<Lead__c>();
        List<Lead__c> listOfLeads18 = new List<Lead__c>();
        List<Lead__c> listOfLeads19 = new List<Lead__c>();
        List<Lead__c> listOfLeads20 = new List<Lead__c>();
        List<Lead__c> listOfLeads21 = new List<Lead__c>();
        List<Lead__c> listOfLeads22 = new List<Lead__c>();
        
        List<Campaign> listofCampaign = new List<Campaign>();
        List<Task> listofTask = new List<Task>();
        
        
        Lead__c leadRec = new Lead__c(
            Name__c = 'Test Lead',
            Phone__c='1234567890',
            Email__c='TestLead@gmail.com',
            isConverted__c = false,
            Lead_Source__c='ATL',
            Lead_Source_Type__c='Magazine',
            Lead_Sub_Source__c='Print',
            Lead_Stage__c='Connected',
            Lead_Substage__c='Interested',
            isQualified__c=true,
            Qualified_Date_Time__c=System.today(),
            Next_Followup_Date_Time__c = System.today(),
            Site_Visit_Date__c=System.today()+20 );
        
        insert leadRec;
        listOfLeads.add(leadRec);
        
        Lead__c updateleadRec = new Lead__c();
        updateleadRec.id = leadRec.id;
        updateleadRec.isConverted__c = true;
        update updateleadRec;
        
        updateleadRec.Name__c = 'Tested';
        updateleadRec.Lead_Stage__c = 'Converted';
        update updateleadRec;
        
        //updateleadRec.Lead_Substage__c = 'Site Visit Planned';
        //updateleadRec.Lead_Stage__c = 'SV Prospect';
        //updateleadRec.Lead_Substage__c = 'Site Visit Proposed';
        //update updateleadRec;
        
        updateleadRec.Lead_Source_Type__c = 'Hoarding';
        updateleadRec.Lead_Substage__c = 'Interested';
        updateleadRec.Lead_Sub_Source__c = 'Print';
        updateleadRec.Lead_Source__c = 'ATL';
        update updateleadRec;
        
        updateleadRec.Lead_Source_Type__c = 'Radio';
        updateleadRec.Lead_Substage__c = 'Interested';
        updateleadRec.Lead_Sub_Source__c = 'Electronic';
        updateleadRec.Lead_Source__c = 'ATL';
        update updateleadRec;
        
        updateleadRec.Lead_Source_Type__c = 'Exhibition/ Expo';
        updateleadRec.Lead_Substage__c = 'Interested';
        updateleadRec.Lead_Sub_Source__c = 'Exhibition/ Expo';
        updateleadRec.Lead_Source__c = 'BTL';
        //update updateleadRec;
        
        updateleadRec.Lead_Source_Type__c = 'News Paper Insert';
        updateleadRec.Lead_Substage__c = 'Interested';
        updateleadRec.Lead_Sub_Source__c = 'News Paper Insert';
        updateleadRec.Lead_Source__c = 'BTL';
        update updateleadRec;
        
        updateleadRec.Lead_Source_Type__c = 'Bangalore Club Event';
        updateleadRec.Lead_Substage__c = 'Interested';
        updateleadRec.Lead_Sub_Source__c = 'Sponsorship';
        updateleadRec.Lead_Source__c = 'BTL';
        update updateleadRec;
        
        updateleadRec.Lead_Source_Type__c = 'Apartment Activity';
        updateleadRec.Lead_Substage__c = 'Interested';
        updateleadRec.Lead_Sub_Source__c = 'Apartment Activity';
        updateleadRec.Lead_Source__c = 'BTL';
        update updateleadRec;
        
        updateleadRec.Lead_Source_Type__c = 'Mall Activity';
        updateleadRec.Lead_Substage__c = 'Interested';
        updateleadRec.Lead_Sub_Source__c = 'Mall Activity';
        updateleadRec.Lead_Source__c = 'BTL';
        //update updateleadRec;
        
        updateleadRec.Lead_Source_Type__c = 'Corporate Activity';
        updateleadRec.Lead_Substage__c = 'Interested';
        updateleadRec.Lead_Sub_Source__c = 'Corporate Activity';
        updateleadRec.Lead_Source__c = 'BTL';
        //update updateleadRec;
        
        updateleadRec.Lead_Source_Type__c = 'Other Activations';
        updateleadRec.Lead_Substage__c = 'Interested';
        updateleadRec.Lead_Sub_Source__c = 'Other Activations';
        updateleadRec.Lead_Source__c = 'BTL';
        //update updateleadRec;
        
        updateleadRec.Lead_Source_Type__c = '99 Acres';
        updateleadRec.Lead_Substage__c = 'Interested';
        updateleadRec.Lead_Sub_Source__c = 'Portals';
        updateleadRec.Lead_Source__c = 'DIGITAL';
        update updateleadRec;
        
        updateleadRec.Lead_Source_Type__c = 'Facebook/ Instagram';
        updateleadRec.Lead_Substage__c = 'Interested';
        updateleadRec.Lead_Sub_Source__c = 'Paid Advertising';
        updateleadRec.Lead_Source__c = 'DIGITAL';
        update updateleadRec;
        
        updateleadRec.Lead_Source_Type__c = 'Main Website-Inbound Call';
        updateleadRec.Lead_Substage__c = 'Interested';
        updateleadRec.Lead_Sub_Source__c = 'Website';
        updateleadRec.Lead_Source__c = 'DIGITAL';
        update updateleadRec;
        
        updateleadRec.Lead_Source_Type__c = 'Emailer';
        updateleadRec.Lead_Substage__c = 'Interested';
        updateleadRec.Lead_Sub_Source__c = 'Emailer';
        updateleadRec.Lead_Source__c = 'DIGITAL';
        update updateleadRec;
        
        updateleadRec.Lead_Source_Type__c = 'SMS';
        updateleadRec.Lead_Substage__c = 'Interested';
        updateleadRec.Lead_Sub_Source__c = 'SMS';
        updateleadRec.Lead_Source__c = 'DIGITAL';
        update updateleadRec;
        
        updateleadRec.Lead_Source_Type__c = 'HDFC Expo';
        updateleadRec.Lead_Substage__c = 'Interested';
        updateleadRec.Lead_Sub_Source__c = 'Digital Expos';
        updateleadRec.Lead_Source__c = 'DIGITAL';
        update updateleadRec;
        
        updateleadRec.Lead_Source_Type__c = 'Site Visit Referral';
        updateleadRec.Lead_Substage__c = 'Interested';
        updateleadRec.Lead_Sub_Source__c = 'Site Visit Referral';
        updateleadRec.Lead_Source__c = 'REFERRAL';
        update updateleadRec;
        
        updateleadRec.Lead_Source_Type__c = 'Management Booking';
        updateleadRec.Lead_Substage__c = 'Interested';
        updateleadRec.Lead_Sub_Source__c = 'V-Team';
        updateleadRec.Lead_Source__c = 'REFERRAL';
        update updateleadRec;
        
        updateleadRec.Lead_Source_Type__c = 'Existing Customer';
        updateleadRec.Lead_Substage__c = 'Interested';
        updateleadRec.Lead_Sub_Source__c = 'V-Connect';
        updateleadRec.Lead_Source__c = 'REFERRAL';
        update updateleadRec;
        
        updateleadRec.Lead_Source_Type__c = 'Associate Booking';
        updateleadRec.Lead_Substage__c = 'Interested';
        updateleadRec.Lead_Sub_Source__c = 'V-Associates';
        updateleadRec.Lead_Source__c = 'REFERRAL';
        update updateleadRec;
        
        updateleadRec.Lead_Source_Type__c = 'Investors/ Shareholders';
        updateleadRec.Lead_Substage__c = 'Interested';
        updateleadRec.Lead_Sub_Source__c = 'Investors/ Shareholders';
        updateleadRec.Lead_Source__c = 'REFERRAL';
        //update updateleadRec;
        
        updateleadRec.Lead_Source_Type__c = 'Others';
        updateleadRec.Lead_Substage__c = 'Interested';
        updateleadRec.Lead_Sub_Source__c = 'Others';
        updateleadRec.Lead_Source__c = 'Others';
        update updateleadRec;
        
        Map<Id,Lead__c> oldMap = new Map<Id,Lead__c>();
        oldMap.put(leadRec.Id,leadRec);
        
        Map<Id,Lead__c> newMap = new Map<Id,Lead__c>();
        newMap.put(updateleadRec.Id,updateleadRec);
        
        
        
        Campaign campRec = new Campaign(Name='Test Campaign',Lead_Source__c='ATL',Lead_Source_Type__c='Magazine',Lead_Sub_Source__c='Print',IsActive=true,StartDate=System.today(),EndDate=System.today()+2);
        insert campRec;
        listofCampaign.add(campRec);
        
        Task taskRec = new Task(whatId = leadRec.Id);
        insert taskRec;
        listofTask.add(taskRec);
        
        
        
        
        Lead__c leadRec2 = new Lead__c(Name__c = 'Test Lead2',Phone__c='1234567890',Email__c='TestLead@gmail.com',isConverted__c = false,Lead_Source__c='ATL',Lead_Source_Type__c='Hoarding',Lead_Sub_Source__c='Outdoor');
        insert leadRec2;
        listOfLeads2.add(leadRec2);
        
        Lead__c leadRec3 = new Lead__c(Name__c = 'Test Lead3',Phone__c='1234567890',Email__c='TestLead@gmail.com',isConverted__c = false,Lead_Source__c='ATL',Lead_Source_Type__c='Radio',Lead_Sub_Source__c='Electronic');
        insert leadRec3;
        listOfLeads3.add(leadRec3);
        
        Lead__c leadRec4 = new Lead__c(Name__c='Test Lead4',Phone__c='1234567890',Email__c='TestLead@gmail.com',isConverted__c = false,Lead_Source__c='BTL',Lead_Source_Type__c='Exhibition/ Expo',Lead_Sub_Source__c='Exhibition/ Expo');
       // insert leadRec4;
        //listOfLeads4.add(leadRec4);
       
        Lead__c leadRec5 = new Lead__c(Name__c = 'Test Lead5',Phone__c='1234567890',Email__c='TestLead@gmail.com',isConverted__c = false,Lead_Source__c='BTL',Lead_Source_Type__c='News Paper Insert',Lead_Sub_Source__c='News Paper Insert');
        insert leadRec5;
        listOfLeads5.add(leadRec5);
        
        Lead__c leadRec6 = new Lead__c(Name__c = 'Test Lead6',Phone__c='1234567890',Email__c='TestLead@gmail.com',isConverted__c = false,Lead_Source__c='BTL',Lead_Source_Type__c='Bangalore Club Event',Lead_Sub_Source__c='Sponsorship');
        insert leadRec6;
        listOfLeads6.add(leadRec6);
        
        Lead__c leadRec7 = new Lead__c(Name__c = 'Test Lead7',Phone__c='1234567890',Email__c='TestLead@gmail.com',isConverted__c = false,Lead_Source__c='BTL',Lead_Source_Type__c='Apartment Activity',Lead_Sub_Source__c='Apartment Activity');
        insert leadRec7;
        listOfLeads7.add(leadRec7);
        
        Lead__c leadRec8 = new Lead__c(Name__c = 'Test Lead7',Phone__c='1234567890',Email__c='TestLead@gmail.com',isConverted__c = false,Lead_Source__c='BTL',Lead_Source_Type__c='Mall Activity',Lead_Sub_Source__c='Mall Activity');
       // insert leadRec8;
       //  listOfLeads8.add(leadRec8);
        
        Lead__c leadRec9 = new Lead__c(Name__c = 'Test Lead7',Phone__c='1234567890',Email__c='TestLead@gmail.com',isConverted__c = false,Lead_Source__c='BTL',Lead_Source_Type__c='Corporate Activity',Lead_Sub_Source__c='Corporate Activity');
       // insert leadRec9;
       // listOfLeads9.add(leadRec9);
        
        Lead__c leadRec10 = new Lead__c(Name__c = 'Test Lead7',Phone__c='1234567890',Email__c='TestLead@gmail.com',isConverted__c = false,Lead_Source__c='BTL',Lead_Source_Type__c='Other Activations',Lead_Sub_Source__c='Other Activations');
       // insert leadRec10;
       // listOfLeads10.add(leadRec10);
        
        Lead__c leadRec11 = new Lead__c(Name__c = 'Test Lead7',Phone__c='1234567890',Email__c='TestLead@gmail.com',isConverted__c = false,Lead_Source__c='DIGITAL',Lead_Source_Type__c='99 Acres',Lead_Sub_Source__c='Portals');
        insert leadRec11;
        listOfLeads11.add(leadRec11);
        
        Lead__c leadRec12 = new Lead__c(Name__c = 'Test Lead7',Phone__c='1234567890',Email__c='TestLead@gmail.com',isConverted__c = false,Lead_Source__c='DIGITAL',Lead_Source_Type__c='Facebook/ Instagram',Lead_Sub_Source__c='Paid Advertising');
        insert leadRec12;
        listOfLeads12.add(leadRec12);
        
        Lead__c leadRec13 = new Lead__c(Name__c = 'Test Lead7',Phone__c='1234567890',Email__c='TestLead@gmail.com',isConverted__c = false,Lead_Source__c='DIGITAL',Lead_Source_Type__c='Main Website-Inbound Call',Lead_Sub_Source__c='Website');
        insert leadRec13;
        listOfLeads13.add(leadRec13);
        
        Lead__c leadRec14 = new Lead__c(Name__c = 'Test Lead7',Phone__c='1234567890',Email__c='TestLead@gmail.com',isConverted__c = false,Lead_Source__c='DIGITAL',Lead_Source_Type__c='Emailer',Lead_Sub_Source__c='Emailer');
        insert leadRec14;
        listOfLeads14.add(leadRec14);
        
        Lead__c leadRec15 = new Lead__c(Name__c = 'Test Lead7',Phone__c='1234567890',Email__c='TestLead@gmail.com',isConverted__c = false,Lead_Source__c='DIGITAL',Lead_Source_Type__c='SMS',Lead_Sub_Source__c='SMS');
        insert leadRec15;
        listOfLeads15.add(leadRec15);
        
        Lead__c leadRec16 = new Lead__c(Name__c = 'Test Lead7',Phone__c='1234567890',Email__c='TestLead@gmail.com',isConverted__c = false,Lead_Source__c='DIGITAL',Lead_Source_Type__c='HDFC Expo',Lead_Sub_Source__c='Digital Expos');
        insert leadRec16;
        listOfLeads16.add(leadRec16);
        
        Lead__c leadRec17 = new Lead__c(Name__c = 'Test Lead7',Phone__c='1234567890',Email__c='TestLead@gmail.com',isConverted__c = false,Lead_Source__c='REFERRAL',Lead_Source_Type__c='Site Visit Referral',Lead_Sub_Source__c='Site Visit Referral');
        insert leadRec17;
        listOfLeads17.add(leadRec17);
        
        Lead__c leadRec18 = new Lead__c(Name__c = 'Test Lead7',Phone__c='1234567890',Email__c='TestLead@gmail.com',isConverted__c = false,Lead_Source__c='REFERRAL',Lead_Source_Type__c='Management Booking',Lead_Sub_Source__c='V-Team');
        insert leadRec18;
        listOfLeads18.add(leadRec18);
        
        Lead__c leadRec19 = new Lead__c(Name__c = 'Test Lead7',Phone__c='1234567890',Email__c='TestLead@gmail.com',isConverted__c = false,Lead_Source__c='REFERRAL',Lead_Source_Type__c='Existing Customer',Lead_Sub_Source__c='V-Connect');
        insert leadRec19;
        listOfLeads19.add(leadRec19);
        
        Lead__c leadRec20 = new Lead__c(Name__c = 'Test Lead7',Phone__c='1234567890',Email__c='',isConverted__c = false,Lead_Source__c='REFERRAL',Lead_Source_Type__c='Associate Booking',Lead_Sub_Source__c='V-Associates');
        insert leadRec20;
        listOfLeads20.add(leadRec20);
        
        Lead__c leadRec21 = new Lead__c(Name__c = 'Test Lead7',Phone__c='1234567890',Email__c='',isConverted__c = false,Lead_Source__c='REFERRAL',Lead_Source_Type__c='Investors/ Shareholders',Lead_Sub_Source__c='Investors/ Shareholders');
       // insert leadRec21;
      //  listOfLeads21.add(leadRec21);
        
        Lead__c leadRec22 = new Lead__c(Name__c = 'Test Lead7',Phone__c='',Email__c='TestLead@gmail.com',isConverted__c = false,Lead_Source__c='Others',Lead_Source_Type__c='Others',Lead_Sub_Source__c='Others');
        insert leadRec22;
        listOfLeads22.add(leadRec22);
        
      //  Lead__c leadOldRec = new Lead__c(Name__c = 'Test Lead',Phone__c='1234567890',Email__c='TestLead@gmail.com',isConverted__c = false,isQualified__c=true,Qualified_Date_Time__c=System.today(),Lead_Source__c='ATL',Lead_Source_Type__c='Magazine',Lead_Sub_Source__c='Print',Lead_Stage__c='Connected',Lead_Substage__c='Interested',OwnerId = UserInfo.getUserId(),Next_Followup_Date_Time__c=System.today()+3);
      //  insert leadOldRec;
         
      //  Lead__c leadNewRec = new Lead__c(Name__c = 'Test Lead',Phone__c='1234567890',Email__c='TestLead@gmail.com',isConverted__c = false,isQualified__c=false,Qualified_Date_Time__c=System.today(),Lead_Source__c='ATL',Lead_Source_Type__c='Magazine',Lead_Sub_Source__c='Print',Lead_Stage__c='Connected',Lead_Substage__c='Interested', OwnerId = UserInfo.getUserId(),Next_Followup_Date_Time__c=System.today()+5);
      //  insert leadNewRec;
        
      //  Map<Id,Lead__c> oldMap = new Map<Id,Lead__c>();
      //  oldMap.put(leadOldRec.Id,leadOldRec);
        
      //  Map<Id,Lead__c> newMap = new Map<Id,Lead__c>();
      //  newMap.put(leadNewRec.Id,leadNewRec);
       
        
        Test.startTest();
        
        handlerInstance.beforeInsert(listOfLeads);
        handlerInstance.beforeInsert(listOfLeads2);
        handlerInstance.beforeInsert(listOfLeads3);
      //  handlerInstance.beforeInsert(listOfLeads4);
        handlerInstance.beforeInsert(listOfLeads5);
        handlerInstance.beforeInsert(listOfLeads6);
        handlerInstance.beforeInsert(listOfLeads7);
        handlerInstance.beforeInsert(listOfLeads8);
        handlerInstance.beforeInsert(listOfLeads9);
        handlerInstance.beforeInsert(listOfLeads10);
        handlerInstance.beforeInsert(listOfLeads11);
        handlerInstance.beforeInsert(listOfLeads12);
        handlerInstance.beforeInsert(listOfLeads13);
        handlerInstance.beforeInsert(listOfLeads14);
        handlerInstance.beforeInsert(listOfLeads15);
        handlerInstance.beforeInsert(listOfLeads16);
        handlerInstance.beforeInsert(listOfLeads17);
        handlerInstance.beforeInsert(listOfLeads18);
        handlerInstance.beforeInsert(listOfLeads19);
        handlerInstance.beforeInsert(listOfLeads20);
        handlerInstance.beforeInsert(listOfLeads21);
        handlerInstance.beforeInsert(listOfLeads22);
        handlerInstance.beforeUpdate(newMap,oldMap);
        Test.stopTest();
    }
    
    
    */
}