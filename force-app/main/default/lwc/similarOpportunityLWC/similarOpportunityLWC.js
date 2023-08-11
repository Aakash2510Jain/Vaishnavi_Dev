import { LightningElement,wire, api, track } from 'lwc';
import getRecordList from '@salesforce/apex/similarOpportunityHelper.getOpportunitiesData';

export default class SimilarOpportunityLWC extends LightningElement {
    

    @track recList = [];
    @api url = '';
    @api recordId;
    @wire(getRecordList,{recordId:'$recordId'})
    wiredResponse(result){
        if(result.data){
            debugger;
            console.log('Contacts-------',result.data);
            //this.recList = [];
            for(let i =0; i<result.data.length; i++){
                let rec = {...result.data[i]};
                rec.sourceType = rec.Source_Type__c;
                rec.url = 'https://vaishnavigroup--dev.sandbox.lightning.force.com/lightning/r/Opportunity__c/'+rec.Id+'/view';
                this.recList.push(rec);
                console.log('this.recList[i].url -- ' , rec );
            }
             
        }else{
            console.log("Error to fetch Fund",result);
        }
    }
}