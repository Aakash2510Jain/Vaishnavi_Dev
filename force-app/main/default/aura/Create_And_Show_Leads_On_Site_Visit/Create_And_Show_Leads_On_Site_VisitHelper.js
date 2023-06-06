({
    fetchPicklistValues: function(component,objDetails,controllerField, dependentField,mapAttrName) {
        var action = component.get("c.getDependentMap");
        action.setParams({
            'objDetail' : objDetails,
            'contrfieldApiName': controllerField,
            'depfieldApiName': dependentField 
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var StoreResponse = response.getReturnValue();
                component.set(mapAttrName,StoreResponse);
                if(mapAttrName == 'v.depnedentFieldMap'){
                    
                    var listOfkeys = []; 
                    var ControllerField = [];  
                    
                    for (var singlekey in StoreResponse) {
                        listOfkeys.push(singlekey);
                    }
                    if (listOfkeys != undefined && listOfkeys.length > 0) {
                        ControllerField.push('--- None ---');
                    }
                    for (var i = 0; i < listOfkeys.length; i++) {
                        ControllerField.push(listOfkeys[i]);
                    }  
                    component.set("v.listControllingValues", ControllerField);
                }
            }else{
                alert('Something went wrong..');
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchDepValues: function(component, ListOfDependentFields,lstAttrName) {
        var dependentFields = [];
        dependentFields.push('--- None ---');
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push(ListOfDependentFields[i]);
        }
        component.set(lstAttrName, dependentFields);
        
    },
    fetchvisitrec : function(component, event){
        debugger;
        var action = component.get("c.fetchvisitRecord");
        var leadRecid = component.get("v.leadRecId");
        action.setParams({
            "leadid" : leadRecid
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var data = response.getReturnValue();   
                component.set("v.visitReclist",data); 
            }
        });
        $A.enqueueAction(action);  
    }
    
})