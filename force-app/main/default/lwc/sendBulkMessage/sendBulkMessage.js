import { LightningElement, track, wire, api } from 'lwc';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';
import searchLeadList from '@salesforce/apex/SendBulkMessageController.searchLeadList';
import findTemplates from '@salesforce/apex/SendBulkMessageController.smsTemplates';
import sendMessage from '@salesforce/apex/SendBulkMessageController.sendMessage';

export default class SendBulkMessage extends NavigationMixin(LightningElement) {
    @api leadId;
    @track leads;
    @track error;     
    @api myParam; 
    selectedTempId;
    selectedTemplate;
    templateRecords = [];
    urlParm = window.location.href;

    debugger;

    @wire(findTemplates)
    wiredRecords({ error, data }) {
        if (data) {
            this.error = undefined;
        //    this.templateRecords = data;
            this.templateRecords = data.map(record => ({ value: record.Id, label: record.Name }));
        } else if (error) {
            this.error = error;
            this.templateRecords = undefined;
        }
    }

    @wire(searchLeadList, {sleadIds: window.location.href})
    wiredLeads({data, error}){
        debugger;
        if(data){
            this.leads = data;
            this.error = undefined;
        }
        else if (error) {
            this.error = error;
            this.leads = undefined;
        }
    }
//     @wire(CurrentPageReference)
//     handlePageReference(pageRef) {
//       // Access the URL parameter value using the pageRef state
//       const myParam = pageRef.state.listofLeads;
//       if (myParam) {
//         this.myParam = myParam;
//       }
//     }

//     @api setParam(param) {
//     // Use the parameter value as needed
//     debugger;
//     console.log(param);
//     this.myParam = param;

//   }
handleTempChange(event){
    debugger;
    this.selectedTemplate = event.detail.value;
}

//  getObjectById(id) {
//     return templateRecords.find(templateRecords => templateRecords.Id === id);
//   }

sendWhatsappMessage(event){
    sendMessage({ temId: this.selectedTemplate, IdList: this.urlParm })
    .then(result => {
      this.contacts = result;
    })
    .catch(error => {
      // Handle error if necessary
    });
}

}