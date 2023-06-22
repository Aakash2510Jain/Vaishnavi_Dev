({
    onPageReferenceChange : function(component, event, helper) {
        debugger;
        var myPageRef = component.get("v.pageReference");
        var leadIds = myPageRef.state.c__listofLeads;            
        if(leadIds!=null && leadIds!=undefined){
           // helper.pullAccount(component);
           let childAuraId = component.find("childAuraId");
           childAuraId.getLeadIds(leadIds);
        }
    }
 })