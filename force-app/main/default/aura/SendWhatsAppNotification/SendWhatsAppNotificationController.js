({
    init: function(component, event, helper) {
        var action = component.get("c.getSMSTemplates");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.smsTemplates", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    onTemplateChange: function(component, event, helper) {
        debugger;
        var selectedTemplateId = component.get("v.selectedTemplate");
        var smsTemplates = component.get("v.smsTemplates");
        if(selectedTemplateId == 'none' || selectedTemplateId == null || selectedTemplateId == undefined){
            component.set("v.messageContent", '');
            component.set("v.showmessageContent",false);
            component.set("v.disableSendButton",true);
        }
        for (var i = 0; i < smsTemplates.length; i++) {
            if (smsTemplates[i].Id === selectedTemplateId) {
                component.set("v.messageContent", smsTemplates[i].Message_for_FrontEnd__c);
                component.set("v.showmessageContent",true);
                component.set("v.disableSendButton",false);
                break;
            }
        }
    },
    handleCancel: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    handleSend: function(component, event, helper) {
        debugger;
        component.set("v.disableSendButton",true);
        var selectedTemplateId = component.get("v.selectedTemplate");
        var recordId = component.get("v.recordId");
        var action = component.get("c.sendWhatsAppNotification");
        action.setParams({
            "smsTemplateId": selectedTemplateId,
            "recordId": recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success",
                    message: "SMS sent successfully.",
                    type: "success"
                });
                toastEvent.fire();
            } else if (state === "ERROR") {
                var errors = response.getError();
                var errorMessage = "Unknown error";
                if (errors && errors.length > 0) {
                    errorMessage = errors[0].message;
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Error",
                    message: errorMessage,
                    type: "error"
                });
                toastEvent.fire();
            }
            $A.get("e.force:closeQuickAction").fire();
        });
        $A.enqueueAction(action);
    },
})