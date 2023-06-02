import { LightningElement, api, wire, track } from 'lwc';
import getRecordList from '@salesforce/apex/SimilarLeadsHelper.getLeads2';

export default class SimilarLeadsCompv1 extends LightningElement {
    @track recList = [];
    @api recordId;
    @wire(getRecordList,{recordId:'$recordId'})
    wiredResponse({data, error}){
        debugger;
        if(data){
            console.log('data-------',JSON.stringify(data));
            this.recList = data;
        }else{
            console.log("Error to fetch Data",error);
        }
    }
}