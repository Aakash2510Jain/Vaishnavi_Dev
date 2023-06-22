// sendTextMessageController.js
({
    doInit : function(component, event, helper) {
        debugger;
        var action = component.get("c.getPreviousTextMessages");
        action.setParams({
            "leadId": component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.previousMessages", response.getReturnValue().messageList);
                component.set("v.messageTemplateList", response.getReturnValue().smsTemplateList);
            }
            else {
                // Handle errors
                console.error("Error sending text message: " + response.getError());
            }
        });
        
        $A.enqueueAction(action);
    },
    sendTextMessage : function(component, event, helper) {
        debugger;
        var messageBody = component.get("v.messageBody");
        var action = component.get("c.sendSMS");
        action.setParams({
            "leadId": component.get("v.recordId"),
            "messageBody": messageBody,
            "smsTempId" : component.get("v.selectedSMSMessageTempId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Message sent Successfully!!!',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
            }
            else {
                toastEvent.setParams({
                    title : 'Error',
                    message:'Some Error Occured!!!',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
            }
            component.set("v.isModalOpen", false);
        });
        
        $A.enqueueAction(action);
    },
    handleMSGTemp: function(component, event, helper) {
        debugger;
        var selectedMSGTempId = component.find("messageTemplate").get("v.value");
        component.set("v.selectedSMSMessageTempId", selectedMSGTempId);
        var smsTempList = component.get("v.messageTemplateList");
        for(var i=0; i< smsTempList.length;i++){
            if(smsTempList[i].Id == selectedMSGTempId){
                component.set("v.messageBody", smsTempList[i].Message__c);
                component.set("v.frontEndMessageBody", smsTempList[i].Message_for_FrontEnd__c);
            }
        }
        // Set isModalOpen attribute to true
        //component.set("v.isModalOpen", true);
    },
    openModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
    },
})