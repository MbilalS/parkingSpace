<template>
  <div class="layout-padding">
    <div class="row justify-center animated bounceIn" style="margin-bottom: 20px">
     <img src="statics/card.png" width="100" height="100">
    </div>
      <div class="card animated fadeIn">
        <div class="card-title bg-indigo text-white" style="margin: 10px; padding: 10px">Please select dates you want to view</div>
        <div class="card-content">
          <q-item>
            <q-item-side icon="access_time" />
            <q-item-main>
              <q-datetime class="no-margin" float-label="Start Date" v-model="start_date" type="date" />
            </q-item-main>
          </q-item>
          <q-item>
            <q-item-side icon="access_time" />
            <q-item-main>
              <q-datetime class="no-margin" float-label="End Date" v-model="end_date" type="date" />
            </q-item-main>
          </q-item>
        <q-btn icon="input" class="full-width" color="indigo-4" v-on:click="getData()">Load</q-btn>
        </br></br>
         



    <div class="row justify-center"v-if="invoices.length>0">
      <q-list highlight inset-separator>
        <div v-for="invoice in invoices">
        <q-item multiline>
          
            <q-item-side avatar="statics/card.png" />
          <q-item-main>        
              <q-item-tile label lines="1"><strong>Invoice #:</strong> {{invoice.id}}</q-item-tile>
              <q-item-tile sublabel lines="3"><strong>Date:</strong> {{invoice.date}}</q-item-tile>
              <q-item-tile sublabel lines="4"><strong>Total Amount:</strong>&euro;{{invoice.total}}</q-item-tile>
              <q-item-tile sublabel lines="2"><strong>Status:</strong> <span style="color:red" v-if="invoice.status=='not paid'"> Not Paid </span> <span style="color:green" v-if="invoice.status=='paid'">Paid </span></q-item-tile>
          </q-item-main>
          <q-item-side right>
            <q-item-tile stamp>view</q-item-tile>
            <q-item-tile icon="pageview" color="indigo" @click="view(invoice.id)"/>
          </q-item-side>
          
          
        </q-item>
        </div>
      </q-list>
    </div>



      </div>
    </div>
  </div>
</template>
<script>
  import axios from "axios";
  import auth from "../auth";
  import constants from "../constants";
  import { QInput,QDatetime,QBtn,QItem,QItemSide,QItemMain,QIcon,QList, QItemTile } from "quasar";
  let BASE_URL = DEV ? "http://localhost:4000" : "http://localhost:4000";
  export default {
    components: { QInput, QDatetime, QBtn, QItem, QItemSide, QItemMain, QIcon, QList, QItemTile},
    data: function() {
      return {
        msg:'',
        start_date: (new Date())-1,
        end_date: new Date(),
        invoices: [],
        columns: [
          { label: 'Parking Area', field: 'location', width: '80px', sort: true },
          { label: 'Start Time', field: 'start_time', width: '150px', sort: true },
          { label: 'End Time', field: 'end', width: '50px', sort: true },
          { label: 'Payment Scheme', field: 'scheme', width: '50px' },
          { label: 'Total Amount', field: 'total', width: '50px',format (value, row) {return "$"+value} }
        ],
        configs: {
          columnPicker: true,
          title: 'Parking Invoices'
        }
    };
  },
     methods: {
      view: function(id) {
        this.$router.push({
              path: `/${id}/payments`,
              query: { redirect: "/invoices" }
            });
      },
      getData: function() {
        this.invoices = [];
           axios.get(BASE_URL + "/api/invoices?start_time="+this.$moment(this.start_date).format("YYYY-MM-DD")+"&end_time="+this.$moment(this.end_date).format("YYYY-MM-DD"),
           { headers: auth.getAuthHeader() })
                .then(response => {
                  this.invoices = response.data
                },(error =>{
                  console.log(error.response.data.msg)
                }));
      } 
    },
    mounted: function() {
      this.getData()
    },
     viewInvoice(){
      console.log("hello")
    }
}
</script>