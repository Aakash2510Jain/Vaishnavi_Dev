public without sharing class siteVisitFormController {
    
    public static String ageGroup {get;set;}
    public static String employmentType {get;set;} 
    public static String budget {get;set;}
    public static String area {get;set;}
    public static String constructionStatus {get;set;}
    public static String purposeOfBuying {get;set;}
    public static String walkinSource {get;set;}
    // public static String walkinSubSource {get;set;}
    public static String gender {get;set;}
    public static String facilitatedBy {get;set;}
    public static String classification {get;set;}
    public static String leadClassification {get;set;} 
    public static String closedReason {get;set;}
    public static String ownership {get;set;}
    public static String sourceOfFunding {get;set;} 
    public static String ethnicity {get;set;}
    public static String flatType {get;set;}
    public static String UserId {get;set;}
    
    public siteVisitFormController() {
        ageGroup = JSON.serialize(UtilityPickListClass.getPicklistValues('Visit__c', 'Age_Group__c'));
        employmentType = JSON.serialize(UtilityPickListClass.getPicklistValues('Visit__c', 'Employment_Type__c'));
        budget = JSON.serialize(UtilityPickListClass.getPicklistValues('Visit__c', 'Budget__c'));
        area = JSON.serialize(UtilityPickListClass.getPicklistValues('Visit__c', 'Area__c'));
        constructionStatus = JSON.serialize(UtilityPickListClass.getPicklistValues('Visit__c', 'Construction_Status__c'));
        purposeOfBuying = JSON.serialize(UtilityPickListClass.getPicklistValues('Visit__c', 'Purpose_Of_Buying__c'));
        walkinSource = JSON.serialize(UtilityPickListClass.getPicklistValues('Visit__c', 'Walkin_Source__c'));
        // walkinSubSource = JSON.serialize(UtilityPickListClass.getPicklistValues('Visit__c', 'Walkin_Sub_Source__c'));
        gender = JSON.serialize(UtilityPickListClass.getPicklistValues('Visit__c', 'Customer_Gender__c'));
        facilitatedBy = JSON.serialize(UtilityPickListClass.getPicklistValues('Visit__c', 'Facilitated_By__c'));
        classification = JSON.serialize(UtilityPickListClass.getPicklistValues('Visit__c', 'Customer_Classicfication__c'));
        leadClassification = JSON.serialize(UtilityPickListClass.getPicklistValues('Visit__c', 'Lead_Classification__c'));
        closedReason = JSON.serialize(UtilityPickListClass.getPicklistValues('Visit__c', 'Reason_Of_Lead_Closed__c'));
        ownership = JSON.serialize(UtilityPickListClass.getPicklistValues('Visit__c', 'Current_House_Ownership__c'));
        sourceOfFunding = JSON.serialize(UtilityPickListClass.getPicklistValues('Visit__c', 'Source_Of_Funding__c'));
        ethnicity = JSON.serialize(UtilityPickListClass.getPicklistValues('Visit__c', 'Ethnicity__c'));
        flatType = JSON.serialize(UtilityPickListClass.getPicklistValues('Project__c', 'Flat_Type__c'));
        UserId = UserInfo.getUserId();
    }

    @RemoteAction
    public static Project_GRE_Association__c getProjectsData(string userId){
        try{
            Project_GRE_Association__c projectId = [Select Id,Project__c,Project__r.Name From Project_GRE_Association__c WHERE GRE__c =: userId];
            return projectId;
        }catch(Exception e){
            return null;
        }
    }

    @RemoteAction
    public static Project_Config__c getBudgetAndUnitOfProject(string projectName){
        try{
            Project_Config__c projectsRecords = [SELECT Id,Name,Budget__c,Unit__c From Project_Config__c WHERE Name =: projectName];
            return projectsRecords;
        }catch(Exception e){
            return null;
        }
    }

    @RemoteAction
    public static string createCloneVisit(string visitId){
        try{
            Visit__c visitRec = [SELECT Actual_visit_date__c,Age_Group__c,Alternate_Phone__c,Apartment_No__c,Area__c,Assigned_User__c,Budget__c,Channel_Partner_Email__c,Channel_Partner_Mobile_No__c,Channel_Partner_Name__c,Channel_Partner_Not_registered__c,Channel_Partner__c,CheckIn__c,CheckIn__Latitude__s,CheckIn__Longitude__s,Check_In_Time__c,Check_Out__c,Check_Out__Latitude__s,Check_Out__Longitude__s,City__c,Company_Name__c,Configuration__c,Construction_Status__c,Country__c,CreatedById,CreatedDate,Current_Floor_No__c,Current_House_Ownership__c,Customer_Classicfication__c,Customer_Gender__c,Customer_s_Desired_Budget__c,Customer_s_Desired_Location_E_W__c,Customer_Time_In__c,Customer_Time_Out__c,Date_Of_Birth__c,Delivery_Agent__c,Designation__c,Distance_Km__c,Email__c,Employment_Type__c,Ethnicity__c,Facilitated_By__c,Family_Size__c,Firm_Name__c,Form_No__c,Geo_Location__c,Geo_Location__Latitude__s,Geo_Location__Longitude__s,GRE_Date_of_Birth__c,GRE_Email__c,GRE_Mobile_No__c,GR_Code__c,Industry__c,Interested_In__c,Inventory_Interested_In__c,IsDeleted,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Lead_Classification__c,Lead_Source__c,Lead__c,Locality__c,Location__c,Marital_Status__c,Mobile_No__c,Name,Name__c,Occupation__c,Office_Address__c,Office_PinCode__c,Opportunities__c,Organization__c,Others_City__c,Others_Locality__c,OwnerId,Pincode__c,Projects__c,Project__c,Purpose_Of_Buying__c,Reason_Of_Lead_Closed__c,Referral_Mobile_No__c,Referral_Name__c,RERA_No__c,Residential_Address__c,Sales_Manager__c,Site_Visit_Remarks__c,Source_Of_Funding__c,Sourcing_Manager__c,SystemModstamp,Visiting_On_Behalf_Of__c,Visiting_With__c,Visit_Plan__c,Visit_Type__c,Walkin_Source__c,Walkin_Sub_Source__c,WalkIn_Type__c FROM Visit__c where Id =: visitId];

            system.debug('visitRec ==> '+visitRec);
            Visit__c clonedRecord = visitRec.clone(false, false, false, false);
            clonedRecord.Actual_visit_date__c = system.today();
            clonedRecord.Visit_Type__c = 'Revisit';
            system.debug('clonedRecord ==> '+clonedRecord);

            insert clonedRecord;
            return clonedRecord.Id;

        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }

    @RemoteAction
    public static string cloneOpportunityAndSV(string oppId, string visitId){
        try{
            Opportunity__c oppRecord = [Select Id,AccountId__c,Opportunity_Name__c,Stage__c,Email__c,Phone__c,Amount__c,Apartment_No__c,Base_Rate__c,Booking_Amount__c,
            Booking_Form_Checklist__c,Booking_Form_Checklist_Option__c,Branch__c,Car_Park_Cost__c,Card_Swipe_Transaction_Date__c,Card_Swipe_Transaction_Number__c,Channel_Partner_Mobile_No__c,
            Cheque_DD_Date__c,Cheque_DD_No__c,Clubhouse_Charges__c,Competitor_Name__c,CP_Name_Company__c,Customer_Email_Id__c,Customer_Mobile_No__c,Customer_Name__c,
            Drawn_On__c,Employee_Email_Id__c,Employee_Mobile_No__c,Employee_Name__c,Employee_Vaishnavi_Referral__c,Existing_Customer_Referral__c,Existing_Employee_Referral__c,
            Expected_Revenue__c,Floor_No__c,Floor_Rise_Rate__c,Forecast_Category__c,Location__c,No_of_Car_Parks__c,Online_Payment_Transaction_Date__c,Online_Payment_Transaction_Number__c,
            Phase__c,PLC_Charges__c,Plot_Area__c,Plot_Facing__c,Plot_Number__c,Price_Book__c,Probability__c,Project_Name__c,Quantity__c,RERA_Regn_No__c,Sale_Value__c,
            Site_Visit_Date__c,Source_Of_Booking__c,Super_Built_Up_Area__c,Total_Rate__c,Type__c,Unit_Plot_No__c,Vaishnavi_Referral__c,Walkin_Source__c,
            Walkin_Source_Group__c FROM Opportunity__c WHERE Id =: oppId];

            system.debug('oppRecord ==> '+oppRecord);
            Opportunity__c clonedRecord = oppRecord.clone(false, false, false, false);
            clonedRecord.Stage__c = 'SV Done';
            system.debug('clonedRecord ==> '+clonedRecord);

            insert clonedRecord;


            Visit__c visitRec = [SELECT Actual_visit_date__c,Age_Group__c,Alternate_Phone__c,Apartment_No__c,Area__c,Assigned_User__c,Budget__c,Channel_Partner_Email__c,Channel_Partner_Mobile_No__c,Channel_Partner_Name__c,Channel_Partner_Not_registered__c,Channel_Partner__c,CheckIn__c,CheckIn__Latitude__s,CheckIn__Longitude__s,Check_In_Time__c,Check_Out__c,Check_Out__Latitude__s,Check_Out__Longitude__s,City__c,Company_Name__c,Configuration__c,Construction_Status__c,Country__c,CreatedById,CreatedDate,Current_Floor_No__c,Current_House_Ownership__c,Customer_Classicfication__c,Customer_Gender__c,Customer_s_Desired_Budget__c,Customer_s_Desired_Location_E_W__c,Customer_Time_In__c,Customer_Time_Out__c,Date_Of_Birth__c,Delivery_Agent__c,Designation__c,Distance_Km__c,Email__c,Employment_Type__c,Ethnicity__c,Facilitated_By__c,Family_Size__c,Firm_Name__c,Form_No__c,Geo_Location__c,Geo_Location__Latitude__s,Geo_Location__Longitude__s,GRE_Date_of_Birth__c,GRE_Email__c,GRE_Mobile_No__c,GR_Code__c,Industry__c,Interested_In__c,Inventory_Interested_In__c,IsDeleted,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Lead_Classification__c,Lead_Source__c,Lead__c,Locality__c,Location__c,Marital_Status__c,Mobile_No__c,Name,Name__c,Occupation__c,Office_Address__c,Office_PinCode__c,Opportunities__c,Organization__c,Others_City__c,Others_Locality__c,OwnerId,Pincode__c,Projects__c,Project__c,Purpose_Of_Buying__c,Reason_Of_Lead_Closed__c,Referral_Mobile_No__c,Referral_Name__c,RERA_No__c,Residential_Address__c,Sales_Manager__c,Site_Visit_Remarks__c,Source_Of_Funding__c,Sourcing_Manager__c,SystemModstamp,Visiting_On_Behalf_Of__c,Visiting_With__c,Visit_Plan__c,Visit_Type__c,Walkin_Source__c,Walkin_Sub_Source__c,WalkIn_Type__c FROM Visit__c where Id =: visitId];

            system.debug('visitRec ==> '+visitRec);
            Visit__c visitclonedRecord = visitRec.clone(false, false, false, false);
            visitclonedRecord.Actual_visit_date__c = system.today();
            visitclonedRecord.Opportunities__c = clonedRecord.Id;
            visitclonedRecord.Visit_Type__c = 'Revisit';
            system.debug('visitclonedRecord ==> '+visitclonedRecord);

            insert visitclonedRecord;
            return clonedRecord.Id;

        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }

    @RemoteAction
    public static string cloneOppForDiffProject(string oppId, string projectId){
        try{
            Opportunity__c oppRecord = [Select Id,AccountId__c,Opportunity_Name__c,Stage__c,Email__c,Phone__c,Amount__c,Apartment_No__c,Base_Rate__c,Booking_Amount__c,
            Booking_Form_Checklist__c,Booking_Form_Checklist_Option__c,Branch__c,Car_Park_Cost__c,Card_Swipe_Transaction_Date__c,Card_Swipe_Transaction_Number__c,Channel_Partner_Mobile_No__c,
            Cheque_DD_Date__c,Cheque_DD_No__c,Clubhouse_Charges__c,Competitor_Name__c,CP_Name_Company__c,Customer_Email_Id__c,Customer_Mobile_No__c,Customer_Name__c,
            Drawn_On__c,Employee_Email_Id__c,Employee_Mobile_No__c,Employee_Name__c,Employee_Vaishnavi_Referral__c,Existing_Customer_Referral__c,Existing_Employee_Referral__c,
            Expected_Revenue__c,Floor_No__c,Floor_Rise_Rate__c,Forecast_Category__c,Location__c,No_of_Car_Parks__c,Online_Payment_Transaction_Date__c,Online_Payment_Transaction_Number__c,
            Phase__c,PLC_Charges__c,Plot_Area__c,Plot_Facing__c,Plot_Number__c,Price_Book__c,Probability__c,Project_Name__c,Quantity__c,RERA_Regn_No__c,Sale_Value__c,
            Site_Visit_Date__c,Source_Of_Booking__c,Super_Built_Up_Area__c,Total_Rate__c,Type__c,Unit_Plot_No__c,Vaishnavi_Referral__c,Walkin_Source__c,
            Walkin_Source_Group__c FROM Opportunity__c WHERE Id =: oppId];

            system.debug('oppRecord ==> '+oppRecord);
            Opportunity__c clonedRecord = oppRecord.clone(false, false, false, false);
            clonedRecord.Project__c = projectId;
            clonedRecord.Stage__c = 'SV Done';
            system.debug('clonedRecord ==> '+clonedRecord);

            insert clonedRecord;
            return clonedRecord.Id;
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }
    
    @RemoteAction
    public Static leadAndSVwrapper searchLead(string searchkey, string projectId){
        try{
            Map<Id, Opportunity__c> opportunityIdByOpportunityRecordMap = New Map<Id, Opportunity__c>();
            system.debug('searchkey--->'+searchkey);
           // set<Id> oppId = New Set<Id>();
            if(searchkey != null){
                
                string phonestring = '%' +searchkey;
                List<Lead__c> leadList = [select id,Name__c,Email__c,Phone__c,Lead_Source__c,Lead_Sub_Source__c,Lead_Source_Type__c,isConverted__c,Project__c,Owner.Name From Lead__c where Email__c =:searchkey or Alternate_Email__c =:searchkey OR Phone__c LIKE :phonestring OR Alternate_Phone__c LIKE :phonestring order by lastModifiedDate Desc limit 1];
                system.debug('leadRec===>>'+leadList);
                // system.debug('leadList[0].isConverted__c ==>> '+leadList[0].isConverted__c);
                if(!leadList.isEmpty() && leadList[0].isConverted__c == false){
                    //Non -Converted Lead Already Exists
                    system.debug('Inside Is Converted FALSE.....');
                    Lead_Search_Count__c leadSearchCountRec = new Lead_Search_Count__c();
                    leadSearchCountRec.Lead__c = leadList[0].Id;
                    leadSearchCountRec.Searched_Date_Time__c = DateTime.now();
                    insert leadSearchCountRec;
                    leadAndSVwrapper leadAndSVwrapInstance = new leadAndSVwrapper(leadList[0], null, null);
                    return leadAndSVwrapInstance;
                }else if(!leadList.isEmpty() && leadList[0].isConverted__c == true ){
                    //converted lead exists and return opportunity and list of SVs
                    system.debug('Inside Is Converted TRUE.....');
                    List<Visit__C> relatedVisitRecords = new List<Visit__C>();
                    Map<Id, Opportunity__c> oppRecByOppIdMap  = new Map<Id, Opportunity__c>([Select Id,Email__c,Opportunity_Name__c,Phone__c,Project__c,Stage__c From Opportunity__c where Email__c =:searchkey OR Phone__c LIKE :phonestring order by createdDate Desc]);
                    system.debug('oppRecByOppIdMap ==> '+oppRecByOppIdMap);
                    if(!oppRecByOppIdMap.isEmpty()){
                        for(Id oppId : oppRecByOppIdMap.keyset()){
                            if(oppRecByOppIdMap.get(oppId).Project__c == projectId){

                            }
                        }
                    }
                    /*system.debug('opportunityIdByOpportunityRecordMap ==>>'+opportunityIdByOpportunityRecordMap);*/
                    if(!oppRecByOppIdMap.isEmpty()){
                        relatedVisitRecords = [Select Id,Name__c,Project__r.Name,Visit_Type__c,Actual_visit_date__c,Planned_visit_date__c,Visiting_With__c,Email__c,Mobile_No__c,
                        Walkin_Source__c,Walkin_Sub_Source__c,Channel_Partner_Name__c,Referral_Name__c,GRE_Email__c,Budget__c From Visit__C where Opportunities__c in : oppRecByOppIdMap.keyset() order by Actual_visit_date__c ASC];
                    }
                    leadAndSVwrapper leadAndSVwrapInstance = new leadAndSVwrapper(null, relatedVisitRecords, oppRecByOppIdMap.values()[0]);
                    return leadAndSVwrapInstance;
                }else{
                    // No lead or opportunity exists
                    system.debug('Else Condition.....');

                    List<Visit__C> relatedVisitRecords = new List<Visit__C>();
                    Map<Id, Opportunity__c> oppRecByOppIdMap  = new Map<Id, Opportunity__c>([Select Id,Email__c,Opportunity_Name__c,Phone__c,Project__c,Stage__c From Opportunity__c where Email__c =:searchkey OR Phone__c LIKE :phonestring order by createdDate Desc]);
                    system.debug('oppRecByOppIdMap ==> '+oppRecByOppIdMap);
                    if(!oppRecByOppIdMap.isEmpty()){
                        for(Id oppId : oppRecByOppIdMap.keyset()){
                            if(oppRecByOppIdMap.get(oppId).Project__c == projectId){

                            }
                        }
                    }
                    /*system.debug('opportunityIdByOpportunityRecordMap ==>>'+opportunityIdByOpportunityRecordMap);*/
                    if(!oppRecByOppIdMap.isEmpty()){
                        relatedVisitRecords = [Select Id,Name__c,Project__r.Name,Visit_Type__c,Actual_visit_date__c,Planned_visit_date__c,Visiting_With__c,Email__c,Mobile_No__c,
                        Walkin_Source__c,Walkin_Sub_Source__c,Channel_Partner_Name__c,Referral_Name__c,GRE_Email__c,Budget__c From Visit__C where Opportunities__c in : oppRecByOppIdMap.keyset() order by Actual_visit_date__c ASC];
                    }
                    leadAndSVwrapper leadAndSVwrapInstance = new leadAndSVwrapper(null, relatedVisitRecords, oppRecByOppIdMap.values()[0]);
                    return leadAndSVwrapInstance;
                    // leadAndSVwrapper leadAndSVwrapInstance = new leadAndSVwrapper(null, null, null);
                    // return leadAndSVwrapInstance;
                }
            }else{
                return null;
            }
        }catch(Exception e){
            system.debug('Error Message==>'+e.getMessage()+ 'Erro in Line==>'+e.getLineNumber());
            return null;   
        }
    }

    @RemoteAction
    public static List<Lead__c> getLeadRecords(string searchkey){
        try{
            string phonestring = '%' +searchkey;
            List<Lead__c> leadList = [select id,Name__c,Email__c,Phone__c,Project__c From Lead__c where Email__c =:searchkey OR Phone__c LIKE :phonestring order by lastModifiedDate Desc limit 1];
            return leadList;
        }catch(Exception e){
            return null;
        }
    }
    
    @RemoteAction
    public static string createLeadRecord(Lead__c leadRecord){
        try{
            system.debug('leadRecord ---> '+leadRecord);
            if(leadRecord != null){
                insert leadRecord;
            }
            return leadRecord.Id;
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }
    
    @RemoteAction
    public static Visit__c getVisitRecord(string leadId){
        try{
            Visit__c existingvisitRecord = [SELECT Id,Name__c,Mobile_No__c,Email__c,Date_Of_Birth__c,Age_Group__c,Residential_Address__c,City__c,Locality__c,
                                            Pincode__c,Employment_Type__c,Company_Name__c,Industry__c,Office_Address__c,Office_PinCode__c,Form_No__c,Actual_visit_date__c,Budget__c,Area__c,
                                            Construction_Status__c,Purpose_Of_Buying__c,Lead__r.Name__c,Lead__r.Birthdate__c,Lead__r.Email__c,Lead__r.Phone__c,Visiting_With__c,Visiting_On_Behalf_Of__c,
                                            Walkin_Source__c,Sourcing_Manager__c,Sales_Manager__c,Facilitated_By__c,Customer_Gender__c,GRE_Mobile_No__c,GRE_Email__c,GRE_Date_of_Birth__c,
                                            Customer_Time_In__c,Customer_Time_Out__c,Customer_Classicfication__c,Lead_Classification__c,Reason_Of_Lead_Closed__c,Current_House_Ownership__c,
                                            Configuration__c,Family_Size__c,Current_Floor_No__c,Customer_s_Desired_Budget__c,Customer_s_Desired_Location_E_W__c,Source_Of_Funding__c,
                                            Ethnicity__c FROM Visit__c WHERE Lead__c =: leadId];
            return existingvisitRecord;
        }catch(Exception e){
            return null;
        }
    }
    
    @RemoteAction
    public static string insertVisitRecord(Visit__c visitRecord, string leadId, Integer year, Integer month, Integer day, Integer visityear, Integer visitmonth, Integer visitday, string location){
        try{
            system.debug('leadId ==> '+leadId);
            System.debug(' --- visitRecord:'+visitRecord);
            System.debug(' --- location:'+location);
            visitRecord.Visit_Type__c = 'First Visit';
            if(!String.isBlank(location)){
                List<Location__c> locationrec = [Select Id,name From Location__c WHERE Id =: location LIMIT 1];
                system.debug('locationrec ==> '+locationrec);
                if(!locationrec.isEMpty()){
                    visitRecord.Location__c = locationrec[0].Id;
                }
                system.debug('visitRecord.Location__c ==> '+visitRecord.Location__c);
            }
            // Visit__c visitRecord = (Visit__c) JSON.deserialize(visitString, Visit__c.class);
            // visitRecord.Lead__c = leadId;
            if(day == 0 && month==0 && year==0){
                
            }else{
                visitRecord.Date_Of_Birth__c = Date.newInstance(year, month, day); 
            }
            if(visitday == 0 && visitmonth==0 && visityear==0){

            }else{
                visitRecord.Actual_visit_date__c = Date.newInstance(visityear, visitmonth, visitday); 
            }
            if(visitRecord.Id != null){
                update visitRecord;
            }else{
                insert visitRecord;
            }
            
            Lead__c leadRecToUpdateAsClosedWon = new Lead__c();
            leadRecToUpdateAsClosedWon.Id = leadId;
            leadRecToUpdateAsClosedWon.Lead_Stage__c = ConstantClass.LeadStageConverted;
            update leadRecToUpdateAsClosedWon;
            
            return visitRecord.Id;
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }

    @RemoteAction
    public static string insertVisitRecordUnderOpportunity(Visit__c visitRecord, Opportunity__c oppRecToInsert, Integer year, Integer month, Integer day, Integer visityear, Integer visitmonth, Integer visitday, string location){
        try{
            System.debug(' --- visitRecord:'+visitRecord);
            if(visitRecord.Opportunities__c != null){
                if(day == 0 && month==0 && year==0){
                
                }else{
                    visitRecord.Date_Of_Birth__c = Date.newInstance(year, month, day); 
                }
                if(visitday == 0 && visitmonth==0 && visityear==0){
    
                }else{
                    visitRecord.Actual_visit_date__c = Date.newInstance(visityear, visitmonth, visitday); 
                }
                if(visitRecord.Id != null){
                    update visitRecord;
                }else{
                    insert visitRecord;
                } 
            }else{
                if(oppRecToInsert != null){
                    oppRecToInsert.Walkin_Source__c = 'Direct Walkin';
                    insert oppRecToInsert;
                    if(!String.isBlank(location)){
                        List<Location__c> locationrec = [Select Id,name From Location__c WHERE Id =: location LIMIT 1];
                        system.debug('locationrec ==> '+locationrec);
                        if(!locationrec.isEMpty()){
                            visitRecord.Location__c = locationrec[0].Id;
                        }
                        system.debug('visitRecord.Location__c ==> '+visitRecord.Location__c);
                    }
                    if(day == 0 && month==0 && year==0){
                
                    }else{
                        visitRecord.Date_Of_Birth__c = Date.newInstance(year, month, day); 
                    }
                    if(visitday == 0 && visitmonth==0 && visityear==0){
        
                    }else{
                        visitRecord.Actual_visit_date__c = Date.newInstance(visityear, visitmonth, visitday); 
                    }
                    visitRecord.Opportunities__c = oppRecToInsert.Id;
                    visitRecord.Walkin_Source__c = 'Direct Walkin';
                    insert visitRecord;
                }
            }         
            return visitRecord.Id;
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }
    
    @RemoteAction
    public static string updateVisitRecord(Visit__c visitRecord, string channelPartner){
        try{
            if(!String.isBlank(channelPartner)){
                List<Channel_Partner__c> channelPartnerList = [SELECT Id,Name FROM Channel_Partner__c WHERE Id =: channelPartner LIMIT 1];
                if(!channelPartnerList.isEmpty()){
                    if(channelPartnerList[0].Name != 'Un-registered CP'){
                        visitRecord.Channel_Partner__c = channelPartner;
                    }
                }
            }
            update visitRecord;
            return 'SUCCESS';
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }
    
    @RemoteAction
    public static string updateGREDetails(Visit__c visitRecord, Integer shour, Integer sMin){
        try{
            if(visitRecord != null){
                List<User> salesUserList = [SELECT Id,Name,Profile.Name FROM User WHERE Id =: visitRecord.Sales_Manager__c];
                visitRecord.Sales_Manager__c = salesUserList[0].Name;
                visitRecord.OwnerId = salesUserList[0].Id;
                visitRecord.Attending_Sales_Manager__c = salesUserList[0].Id;

                Visit__c visitRec = [SELECT Id,Opportunities__c,Opportunities__r.OwnerId FROM Visit__c WHERE Id=: visitRecord.Id];
                if(!String.isBlank(visitRec.Opportunities__c)){
                    Opportunity__c oppRecToUpdate = New Opportunity__c();
                    oppRecToUpdate.Id = visitRec.Opportunities__c;
                    oppRecToUpdate.OwnerId = salesUserList[0].Id;
                    update oppRecToUpdate;
                }
            }
            // if(day == 0 && month==0 && year==0){
                
            // }else{
            //     visitRecord.GRE_Date_of_Birth__c = Date.newInstance(year, month, day); 
            // }
            if(shour != null && sMin != null ){
                visitRecord.Customer_Time_In__c = Time.newInstance(shour, sMin, 0, 0);
            }
            // if(oHour != null && oMin != null ){
            //     visitRecord.Customer_Time_Out__c = Time.newInstance(oHour, oMin, 0, 0);
            // }
            update visitRecord;
            return 'SUCCESS';
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }
    
    @RemoteAction
    public static string finalSubmit(Visit__c visitRecord){
        try{
            // if(visitday == 0 && visitmonth==0 && visityear==0){
                
            // }else{
            //     visitRecord.Actual_visit_date__c = Date.newInstance(visityear, visitmonth, visitday); 
            // }
            update visitRecord;
            return 'SUCCESS';
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }

    @RemoteAction
    public static List<Location__c> getLocationList(){
        try{
            List<Location__c> locationList = [SELECT Id,Name From Location__c order by Name];
            return locationList;
        }catch(Exception e){
            return null;
        }
    }

    @RemoteAction
    public static List<User> getSalesManager(){
        try{
            List<User> salesUserList = [SELECT Id,Name,Profile.Name FROM User WHERE Profile.Name = 'Sales Team'];
            return salesUserList;
        }catch(Exception e){
            return null;
        }
    }

    @RemoteAction
    public static List<Channel_Partner__c> getChannelPartners(){
        try{
            List<Channel_Partner__c> channelPartnerList = [SELECT Id,Name FROM Channel_Partner__c ];
            return channelPartnerList;
        }catch(Exception e){
            return null;
        }
    }

    public class leadAndSVwrapper{
        public Lead__c leadRec {get;set;}
        public List<Visit__c> visitList {get;set;}
        public Opportunity__c oppRec {get;set;}
        
        public leadAndSVwrapper(Lead__c leadRec, List<Visit__c> visitList, Opportunity__c oppRec){
            this.leadRec = leadRec;
            this.visitList = visitList;
            this.oppRec = oppRec;
        }
    }
}