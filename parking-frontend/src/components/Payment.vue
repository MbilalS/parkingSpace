<template>
  <q-layout>
    <div class="container-payments" id="parent"> 
     <div class="row justify-center animated pulse" style="margin-top: 10px">
      <img src="statics/invoice.png" alt="Confirm Parking" width="100" height="100"> <br/>
     </div>

      <div class="head animate fadeIn" id="head">
        <div style="float: left; padding-top: 40px; padding-left: 20px;"> 
          <label><strong> Invoice #:</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{{invoice.id}} </label> <br/>
          <label> <strong> Date:</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {{invoice.date}} </label> <br/>
          <label > <strong> Status:</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style="color:red" v-if="invoice.status=='not paid'">Not Paid </span> <span style="color:green" v-if="invoice.status=='paid'"> Paid </span> </label> <br/> 
        </div>
      </div>

      <div class="body animated pulse" id="content-body" >

        <q-data-table :data="invoice.details" :config="configs" :columns="columns" > </q-data-table>

        <div style="text-align:right; padding-top: 10px; padding-right: 20px;" id="totalprice"> 
          <label> <font size="2">Total amount: <strong>€{{invoice.total}} </strong></font></label> <br/>
        </div>

        <div id="buttons-container"  style="float: right; padding-top: 10px; padding-right: 10px"> 
          <div style="float: right; padding: 5px" v-if="invoice.status=='paid'"><q-btn icon="input" color="indigo 4" v-on:click="cancel">Close</q-btn> </div>
          <div style="float: right; padding: 5px" v-if="invoice.status=='not paid'"><q-btn icon="input" color="indigo 4" v-on:click="pay">Pay</q-btn> </div>
        </div>
      </div>
    </div>
  </q-layout>
</template>

<script>
  import axios from 'axios';
  import auth from '../auth';
 import { QLayout, QInput, QDatetime, QBtn, QItem, QItemSide, QItemMain, QIcon, QDataTable } from 'quasar';
  let BASE_URL = DEV ? 'http://localhost:4000' : 'http://localhost:4000';
  export default {
    components: {
    QLayout, QInput, QDatetime, QBtn, QItem, QItemSide, QItemMain, QIcon, QDataTable
    },
    data: function() {
      return {
        invoice: {},
      columns: [
        { label: "Date", field: "date", width: "80px", sort: true },
        { label: "Location", field: "location", width: "80px", sort: true },
        { label: "Payment Scheme", field: "payment_scheme", width: "50px" },
        { label: "Start Time",field: "start_time", width: "150px", sort: true },
        { label: "End Time", field: "end_time", width: "50px", sort: true },
        { label: "Unit Price", field: "unit_price", width: "50px", sort: true },
        {label: "Amount", field: "amount", width: "50px",
          format(value, row) {
            return "€" + value;
          }
        }

      ],
      configs: {
        columnPicker: true,
        title: "Invoice Details"
      },
        redirect:"/invoices"
      }
    },
    props: ['message'],
    methods: {
      pay: function() {
        console.log('tag', 'paying')
            axios.patch(BASE_URL+`/api/invoices/${this.invoice.id}/pay`,
                {invoice: this.invoice}, {headers: auth.getAuthHeader()})
            .then (response => {
                this.$router.push(this.redirect);
            })
            .catch(e => {
                // 
            })
          // }
      },
      cancel: function() {
        console.log('tag', 'paying')
            this.$router.push(this.redirect);
      }
    },
    mounted: function() {

      axios.get(BASE_URL+`/api/invoices/${this.$route.params.id}`, {headers: auth.getAuthHeader()})
            .then (response => {
                this.invoice = response.data;
                console.log('tag', this.invoice)
            })
            .catch(e => {
                // 
            })
      if(this.$route.query.redirect) {
        this.redirect = this.$route.query.redirect;
      }
    }
  }
</script>


<style>
.container-payments {
  width: 100%;
  height: 100vh;
}
.head {
  width: 100%;
  height: 15%;
}
.body {
  width: 100%;
  height: 85%;
  margin-top: 30px;
}
</style>
