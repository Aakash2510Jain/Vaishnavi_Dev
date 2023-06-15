({
    doInit  : function(component, event, helper){
        debugger;
        component.set("v.showRecordDetail",false);  
        //  helper.fetchvisitrec(component, event);
        var action =component.get("c.fetchAllThePickValues");
        
        action.setParams({
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var data = response.getReturnValue();
                
                //data = JSON.parse(JSON.stringify(data));
                if(data != null){
                    component.set("v.budgetList",data.budgetList);
                    component.set("v.occupationList",data.occupationList);
                    component.set("v.ageGroupList",data.ageGroupList);
                    component.set("v.ethnicityList",data.ethnicityList);
                    component.set("v.buyingPurposeList",data.buyingPurposeList);
                    component.set("v.walkinTypeList",data.walkinTypeList);
                    component.set("v.inventoryList",data.inventoryList);
                    component.set("v.ownershipList",data.ownershipList);
                    component.set("v.martialStatusList",data.martialStatusList);
                    component.set("v.walkinSourceList",data.walkinSource);
                    component.set("v.leadSourceList",data.leadSource);
                    component.set("v.companiesList",data.companiesList);
                }else{
                    
                } 
            }
        });
        $A.enqueueAction(action);
    },
    searchLead : function(component, event, helper) {
        debugger;
        
        var controllingFieldAPI = component.get("v.controllingFieldAPI");
        var dependingFieldAPI = component.get("v.dependingFieldAPI");
        var subDependingFieldAPI = component.get("v.subDependingFieldAPI");
        var objDetails = component.get("v.objDetail");
        
        //helper.fetchPicklistValues(component,objDetails,controllingFieldAPI, dependingFieldAPI, "v.depnedentFieldMap");
        //helper.fetchPicklistValues(component,objDetails,dependingFieldAPI, subDependingFieldAPI, "v.subDepnedentFieldMap");
        
        component.set("v.showVisitButton",true); 
        component.set("v.showNewLeadPage",false); 
        var action =component.get("c.showExistingLead");
        var searchEmailOrPhone = component.get("v.Searchkey");
        
        action.setParams({
            "searchkey" : searchEmailOrPhone
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                
                var data = response.getReturnValue();
                
                if(data != null){
                    if(data.isConverted__c == false){
                        component.set("v.LeadRec",data);
                        component.set("v.leadRecId",data.Id); 
                        component.set("v.showRecordDetail",true); 
                        component.set("v.showError",false);
                    }else if(data.isConverted__c == true){
                        helper.fetchvisitrec(component, event);
                        component.set("v.showRecordDetail",false);
                        component.set("v.showError",true);
                        component.set("v.errorMessage","Customer Already Visited, Please checkout Visits");
                    }
                }else{
                    component.set("v.showRecordDetail",false);
                    component.set("v.showError",true);
                    component.set("v.showVisitButton",false); 
                    component.set("v.errorMessage","No Record Is Available!");
                } 
            }
        });
        $A.enqueueAction(action);
    },
    createvisit : function(component, event, helper){
        debugger;
        component.set("v.showVisitPage",true); 
        component.set("v.showRecordDetail",false);
        component.set("v.showNewLeadPage",false); 
        var today = new Date().toISOString().split('T')[0];
        component.set('v.today', today);
        
    },
    selectdate : function(component, event, helper){
        debugger;
        var dateselect = component.find('date').get('v.value');
        var todaydate = new Date().toISOString().split('T')[0];
        if(dateselect < todaydate){
            alert('Date should Be Gretar than Today Date');
            component.set("v.today",todaydate); 
        }else{
            component.set("v.today",dateselect);  
        }
        
    },
    createVistRec : function(component, event, helper){
        debugger;
        var visitRecord = component.get("v.siteVisitRecordToInsert");
        
        var action = component.get("c.createVisitUnderCurrentLead");
        var leadid = component.get("v.leadRecId");
        var companyRecord = component.get("v.selectedCompany");
        action.setParams({
            "recid" : leadid,
            "newVisitRec" : visitRecord,
            "selectedCompanyRec" : companyRecord
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                alert('New  Visit has been Created under Current Lead');
                component.set("v.showRecordDetail",true);
                component.set("v.showVisitPage", false);
            }
        });
        $A.enqueueAction(action);
        
    }, 
    closeModal: function(component, event, helper) {
        component.set("v.showVisitPage", false);
        component.set("v.showRecordDetail",true);
    },
    
    UpdateLead :function(component, event, helper){
        debugger;
        var action =component.get("c.updateExistinglead");  
        var Leadrecid = component.get("v.leadRecId"); 
        var leadRecords = component.get("v.LeadRec"); 
        action.setParams({
            "recid" : Leadrecid,
            "leadRec" : leadRecords
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                alert('Record get Updated'); 
            }
        });
        $A.enqueueAction(action); 
        
    },
    CreateLead:function(component, event, helper){
        debugger;
        component.set("v.showVisitPage",false);
        component.set("v.showNewLeadPage",true); 
        component.set("v.showRecordDetail",false); 
        
        var controllingFieldAPI = component.get("v.controllingFieldAPI");
        var dependingFieldAPI = component.get("v.dependingFieldAPI");
        var subDependingFieldAPI = component.get("v.subDependingFieldAPI");
        
        var objDetails = component.get("v.objDetail");
        helper.fetchPicklistValues(component,objDetails,controllingFieldAPI, dependingFieldAPI, "v.depnedentFieldMap");
        helper.fetchPicklistValues(component,objDetails,dependingFieldAPI, subDependingFieldAPI, "v.subDepnedentFieldMap");
        
    },
    onControllerFieldChange: function(component, event, helper) {
        debugger;
        var controllerValueKey = event.getSource().get("v.value"); 
        var depnedentFieldMap = component.get("v.depnedentFieldMap");
        
        if (controllerValueKey != '--- None ---') {
            var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
            if(ListOfDependentFields.length > 0){
                component.set("v.bDisabledDependentFld" , false);  
                helper.fetchDepValues(component, ListOfDependentFields,"v.listDependingValues");    
            }else{
                component.set("v.bDisabledDependentFld" , true); 
                component.set("v.listDependingValues", ['--- None ---']);
            }  
            
        } else {
            component.set("v.listDependingValues", ['--- None ---']);
            component.set("v.bDisabledDependentFld" , true);
        }
        
        component.set("v.bDisabledSubDependentFld" , true);
        component.set("v.listSubDependingValues", ['--- None ---']);
    },
    
    
    onSubControllerFieldChange : function(component, event, helper) {   
        debugger;
        var controllerValueKey = event.getSource().get("v.value"); // get selected sub controller field value
        var depnedentFieldMap = component.get("v.subDepnedentFieldMap");
        
        if (controllerValueKey != '--- None ---') {
            var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
            if(ListOfDependentFields.length > 0){
                component.set("v.bDisabledSubDependentFld" , false);  
                helper.fetchDepValues(component, ListOfDependentFields,"v.listSubDependingValues");    
            }else{
                component.set("v.bDisabledSubDependentFld" , true); 
                component.set("v.listSubDependingValues", ['--- None ---']);
            }  
            
        } else {
            component.set("v.listSubDependingValues", ['--- None ---']);
            component.set("v.bDisabledSubDependentFld" , true);
        }
    },
    createNEwLead :function(component, event, helper){
        debugger;
        var action =component.get("c.createNewLead");  
        var newleadRecords = component.get("v.objDetail"); 
        action.setParams({
            
            "createleadRec" : newleadRecords
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                alert('New Lead has been Created'); 
                component.set("v.showNewLeadPage",false); 
            }
        });
        $A.enqueueAction(action);  
    },
    handleBudgetChange: function(component, event, helper) {
        debugger;
        var selectedValue = event.getSource().get("v.value");
        component.set("v.siteVisitRecordToInsert.Budget__c",selectedValue);
    },
    handleOccupationChange: function(component, event, helper) {
        debugger;
        var selectedValue = event.getSource().get("v.value");
        component.set("v.siteVisitRecordToInsert.Occupation__c",selectedValue);
    },
    handleAgeGroupChange: function(component, event, helper) {
        debugger;
        var selectedValue = event.getSource().get("v.value");
        component.set("v.siteVisitRecordToInsert.Age_Group__c",selectedValue);
    },   
    handleEthnicityChange: function(component, event, helper) {
        debugger;
        var selectedValue = event.getSource().get("v.value");
       component.set("v.siteVisitRecordToInsert.Ethnicity__c",selectedValue);
    },
    handleBuyingPurposeChange: function(component, event, helper) {
        debugger;
        var selectedValue = event.getSource().get("v.value");
        component.set("v.siteVisitRecordToInsert.Purpose_Of_Buying__c",selectedValue);
    },
    handleWalkInTypeChange: function(component, event, helper) {
        debugger;
        var selectedValue = event.getSource().get("v.value");
        component.set("v.siteVisitRecordToInsert.WalkIn_Type__c	",selectedValue);
    },
    handleWalkInSourceChange: function(component, event, helper) {
        debugger;
        var selectedValue = event.getSource().get("v.value");
        component.set("v.siteVisitRecordToInsert.Walkin_Source__c",selectedValue);
    },
    handleInventoryChange: function(component, event, helper) {
        debugger;
        var selectedValue = event.getSource().get("v.value");
        component.set("v.siteVisitRecordToInsert.Inventory_Interested_In__c",selectedValue);
    },  
    handleOwnershipChange: function(component, event, helper) {
        debugger;
        var selectedValue = event.getSource().get("v.value");
        component.set("v.siteVisitRecordToInsert.Current_House_Ownership__c",selectedValue);
    },
    handleMartialStatusChange: function(component, event, helper) {
        debugger;
        var selectedValue = event.getSource().get("v.value");
        component.set("v.siteVisitRecordToInsert.Marital_Status__c",selectedValue);
    },
   /* handleInputChange : function(component, event, helper) {
        debugger;
        var selectedValue = event.getSource().get("v.value");
        var organizationValue = component.get("v.organization");
        component.set("v.siteVisitRecordToInsert.Organization__c",organizationValue);
    },*/
    searchCompany: function(component, event, helper) {
        debugger;
        var searchTerm = component.get("v.companySearchTerm");
        var companyList = component.get("v.companiesList");
        var searchedCompanyList = [];
        for(var i=0;i<companyList.length;i++){
            if((companyList[i].Company_Name__c.toLowerCase()).includes(searchTerm.toLowerCase())){
                searchedCompanyList.push(companyList[i]);
            }
        }
            component.set("v.companySearchedList", searchedCompanyList);
    },
    
    selectCompany: function(component, event, helper) {
        debugger;
        var selectedCompanyId = event.target.dataset.id;
        var searchResults = component.get("v.companiesList");
        
        // Find the selected company in the searchResults list
        var selectedCompany = searchResults.find(function(result) {
            return result.Id === selectedCompanyId;
        });
        
        // Set the selectedCompany attribute with the selected company object
        component.set("v.selectedCompany", selectedCompany);
    },
    clearSelection: function(component, event, helper) {
        // Clear the selectedCompany attribute to remove the selected company
        component.set("v.selectedCompany", null);
    }
})