({
    doInit : function(component, event, helper) {
        debugger;
        //var callPicklistMethod = component.get("c.getSourceTypePicklistValues");
        //$A.enqueueAction(callPicklistMethod);
        var action = component.get("c.getTasks");
        action.setParams({
            "recordId" : component.get('v.recordId')
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
               
                var result= response.getReturnValue();
                var DataToSplit  = [];
                if(result != null && result != undefined){
                    for(var i in result){
                        result[i].Sub = 'Re-Enq';
                    }
                    component.set("v.taskListWithsimDomain", result);
                }
                else{
                    component.set("v.showImage", true);
                }
            }
        });      
        $A.enqueueAction(action);
    },
    getSourceTypePicklistValues : function(component, event, helper) {
        debugger;
        var action = component.get("c.getLeadSourceTypePickList");
        action.setParams({
            ObjectApi_name : 'Lead__c',
            Field_name : 'Lead_Source_Type__c'
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var dataPickList= response.getReturnValue();
                if(dataPickList !=null && dataPickList !=undefined){
                    component.set("v.LeadSourcePickList",dataPickList);
                }
            } else if(state === "ERROR"){
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);
                    }
                }
            }else if (state=== "INCOMPLETE") {
                alert('No response from server or client is offline.');
            }
        });
        $A.enqueueAction(action);
    }
})