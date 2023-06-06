({
    doInit  : function(component, event, helper){
        debugger;
        component.set("v.showRecordDetail",false);  
        //  helper.fetchvisitrec(component, event);
    },
    searchLead : function(component, event, helper) {
        debugger;
        
        var controllingFieldAPI = component.get("v.controllingFieldAPI");
        var dependingFieldAPI = component.get("v.dependingFieldAPI");
        var subDependingFieldAPI = component.get("v.subDependingFieldAPI");
        var objDetails = component.get("v.objDetail");
        
        helper.fetchPicklistValues(component,objDetails,controllingFieldAPI, dependingFieldAPI, "v.depnedentFieldMap");
        helper.fetchPicklistValues(component,objDetails,dependingFieldAPI, subDependingFieldAPI, "v.subDepnedentFieldMap");
        
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
                    component.set("v.LeadRec",data);
                    component.set("v.leadRecId",data.Id); 
                    helper.fetchvisitrec(component, event);
                    component.set("v.showRecordDetail",true); 
                    component.set("v.showError",false);
                }else{
                    component.set("v.showRecordDetail",false);
                    component.set("v.showError",true);
                    component.set("v.showVisitButton",false); 
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
        var action = component.get("c.createVisitUnderCurrentLead");
        var leadid = component.get("v.leadRecId");
        var visitRec = component.get("v.SiteVistRec");
        var changdate = component.get("v.today");
        
        action.setParams({
            "recid" : leadid,
            "changedate"  : changdate,
            "newVisitRec" : visitRec
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
    }
})