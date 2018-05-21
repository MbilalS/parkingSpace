<template>
  <div class="layout-padding">
    <div class="row justify-center">
     <div class="row justify-center animated bounceIn" style="margin-top: 10px">
      <img src="statics/confirm.png" alt="Confirm Parking" width="150" height="150"> <br/>
     </div>

      <div style="width: 100%; height: 100px; margin-bottom: 10px; margin-top: 10px; text-align: center">
        <h5>Confirm Parking</h5>
      </div>

      <div>
        <table class="q-table">
              <tbody>
                <tr>
                  <th class="text-left">Parking At:</th>
                  <td class="text-right">{{message.location}}</td>
                </tr>
                <tr>
                  <th class="text-left">Zone: </th>
                  <td class="text-right"> {{message.zone_name}}</td>
                </tr>
                <tr v-if="message.payment_scheme == 'HOURLY'">
                  <th class="text-left">Payment Scheme:</th>
                  <td class="text-right"> Hourly</td>
                </tr>
                <tr v-if="message.payment_scheme != 'HOURLY'">
                  <th class="text-left">Payment Scheme:</th>
                  <td class="text-right"> Real Time</td>
                </tr>
                <tr v-if="message.payment_scheme == 'HOURLY'">
                  <th class="text-left">Fee:</th>
                  <td class="text-right">&euro;{{message.amount}}</td>
                </tr>
                <tr v-if="message.payment_scheme != 'HOURLY'">
                  <th class="text-left">Fee:</th>
                  <td class="text-right">&euro;{{message.amount}}</td>
                </tr>
              </tbody>
            </table> 
      </div>

      <div class="row justify-center"> 
        <div >
          <q-btn id="acceptbtn"  outline style="border-radius: 10px; width: 100%; margin-top: 10px;" icon="check" color="indigo"   v-on:click="submitDecision({status: 'accepted'})"> Confirm</q-btn>
        </div>

        <div style="margin-left: 10px">
          <q-btn id="rejectbtn" outline style="border-radius: 10px;  margin-top: 10px" icon="close" color="red"  v-on:click="submitDecision({status: 'rejected'})"> Cancel</q-btn>
        </div>
      </div>
    
    </div>
  </div>
</template>

<script>
  import axios from 'axios'
  import auth from '../auth'
  import { QInput, QDatetime, QBtn, QItem, QItemSide, QItemMain, QIcon, QLayout, QTabs, QList, QCollapsible } from 'quasar'
  let BASE_URL = DEV ? 'http://localhost:4000' : 'http://localhost:4000';
  export default {
    components: {
      QInput, QDatetime, QBtn, QItem, QItemSide, QItemMain, QIcon, QLayout, QTabs, QList, QCollapsible
    },
    data: function() {
      return {
        name: "",
        zone: "",
        distance: "",
        fee: "",
        visible: true
      }
    },
    props: ['message'],
    methods: {
      submitDecision: function(decision) {
        axios.patch(BASE_URL+`/api/parkings/${this.message.id}`,
          {status: decision.status}, {headers: auth.getAuthHeader()})
        .then (response => {
          
        })
        .catch(e => {
        
        })
      }
    },
  }
</script>

<<style>

</style>
