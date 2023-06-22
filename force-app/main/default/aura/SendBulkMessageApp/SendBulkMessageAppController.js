({
	 onPageReferenceChange : function(component, event, helper) {
        debugger;
         var myParam = component.get("v.listofLeads");
      //  var myPageRef = component.get("v.pageReference");
        var leadIds = component.get("v.listofLeads");            
        if(leadIds!=null && leadIds!=undefined){
    var myLwcComponent = component.find("myLwc");
               if (myLwcComponent) {
      myLwcComponent.set("v.myParam", myParam);
    } else {
      // If the LWC component is not yet rendered, handle the value change event
      component.addEventHandler("render", function() {
        myLwcComponent = component.find("myLwc");
        myLwcComponent.setParam(myParam);
      });
    }
            
        }
    }
})