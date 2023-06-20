public without sharing class siteVisitFormController {

    public static String ageGroup {get;set;}
    public static String employmentType {get;set;} 
    public static String budget {get;set;}
    public static String area {get;set;}
    public static String constructionStatus {get;set;}
    public static String purposeOfBuying {get;set;}
    public static String walkinSource {get;set;}
    public static String gender {get;set;}
    public static String facilitatedBy {get;set;}
    public static String classification {get;set;}
    public static String leadClassification {get;set;} 
    public static String closedReason {get;set;}
    public static String ownership {get;set;}
    public static String sourceOfFunding {get;set;} 
    public static String ethnicity {get;set;}

    public siteVisitFormController() {
        ageGroup = JSON.serialize(UtilityPickListClass.getPicklistValues('Visit__c', 'Age_Group__c'));
        employmentType = JSON.serialize(UtilityPickListClass.getPicklistValues('Visit__c', 'Employment_Type__c'));
        budget = JSON.serialize(UtilityPickListClass.getPicklistValues('Visit__c', 'Budget__c'));
        area = JSON.serialize(UtilityPickListClass.getPicklistValues('Visit__c', 'Area__c'));
        constructionStatus = JSON.serialize(UtilityPickListClass.getPicklistValues('Visit__c', 'Construction_Status__c'));
        purposeOfBuying = JSON.serialize(UtilityPickListClass.getPicklistValues('Visit__c', 'Purpose_Of_Buying__c'));
        walkinSource = JSON.serialize(UtilityPickListClass.getPicklistValues('Visit__c', 'Walkin_Source__c'));
        gender = JSON.serialize(UtilityPickListClass.getPicklistValues('Visit__c', 'Customer_Gender__c'));
        facilitatedBy = JSON.serialize(UtilityPickListClass.getPicklistValues('Visit__c', 'Facilitated_By__c'));
        classification = JSON.serialize(UtilityPickListClass.getPicklistValues('Visit__c', 'Customer_Classicfication__c'));
        leadClassification = JSON.serialize(UtilityPickListClass.getPicklistValues('Visit__c', 'Lead_Classification__c'));
        closedReason = JSON.serialize(UtilityPickListClass.getPicklistValues('Visit__c', 'Reason_Of_Lead_Closed__c'));
        ownership = JSON.serialize(UtilityPickListClass.getPicklistValues('Visit__c', 'Current_House_Ownership__c'));
        sourceOfFunding = JSON.serialize(UtilityPickListClass.getPicklistValues('Visit__c', 'Source_Of_Funding__c'));
        ethnicity = JSON.serialize(UtilityPickListClass.getPicklistValues('Visit__c', 'Ethnicity__c'));
    }

    @RemoteAction
    public Static Lead__c searchLead(string searchkey){
        try{
            if(searchkey != null){
                string phonestring = '%' +searchkey;
                List<Lead__c> leadList = [select id,Name__c,Email__c,Phone__c,Lead_Source__c,Lead_Sub_Source__c,Lead_Source_Type__c,isConverted__c From Lead__c where Email__c =:searchkey OR Phone__c LIKE :phonestring order by lastModifiedDate Desc limit 1  ];
                system.debug('leadRec===>>'+leadList);
                if(!leadList.isEmpty()){
                    Lead_Search_Count__c leadSearchCountRec = new Lead_Search_Count__c();
                    leadSearchCountRec.Lead__c = leadList[0].Id;
                    leadSearchCountRec.Searched_Date_Time__c = DateTime.now();
                    insert leadSearchCountRec;
                    return leadList[0]; 
                }else{
                    return null;
                }
                
            }
            
        }catch(Exception e){
            system.debug('Error Message==>'+e.getMessage()+ 'Erro in Line==>'+e.getLineNumber());
        }
        return null;   
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
    public static string insertVisitRecord(String visitString, string leadId, Integer year, Integer month, Integer day){
        try{
            System.debug(' --- visitRecord:'+visitString);
            Visit__c visitRecord = (Visit__c) JSON.deserialize(visitString, Visit__c.class);
                visitRecord.Lead__c = leadId;
                if(day == 0 && month==0 && year==0){
                    
                }else{
                    visitRecord.Date_Of_Birth__c = Date.newInstance(year, month, day); 
                }
                insert visitRecord;
            return visitRecord.Id;
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }

    @RemoteAction
    public static string updateVisitRecord(Visit__c visitRecord, string leadId){
        try{
            update visitRecord;
            return 'SUCCESS';
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }

    @RemoteAction
    public static string updateGREDetails(Visit__c visitRecord,string leadId, Integer day, Integer month, Integer year){
        try{
            if(day == 0 && month==0 && year==0){
                    
            }else{
                visitRecord.GRE_Date_of_Birth__c = Date.newInstance(year, month, day); 
            }
            update visitRecord;
            return 'SUCCESS';
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }

    @RemoteAction
    public static string finalSubmit(Visit__c visitRecord, string leadId, Integer visityear, Integer visitmonth, Integer visitday){
        try{
            if(visitday == 0 && visitmonth==0 && visityear==0){
                
            }else{
                visitRecord.Actual_visit_date__c = Date.newInstance(visityear, visitmonth, visitday); 
            }
            update visitRecord;
            return 'SUCCESS';
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }
}