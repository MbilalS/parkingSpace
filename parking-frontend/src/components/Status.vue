<template>
  <div class="layout-padding " id="view-flex">
    <div class="row justify-center">
      

      <div  v-if="status.id"> 
        <div  class="row justify-center animated flipInY" style="margin: 20px">
          <img src="statics/activeparking.png" alt="No active parking" width="120" height="120"> <br/>
       </div>
        <q-card inline class="full-width animated fadeIn" color="indigo"  >
          <q-card-title class="justify-center">
            Parked at:  {{status.location}}
            <span slot="subtitle" v-if="status.payment_scheme == 'HOURLY'" >{{status.time_left}} Minutes left </span>
            <span slot="subtitle" v-if="status.payment_scheme != 'HOURLY'">{{status.elapsed_time}} Minutes elapsed</span>
          </q-card-title>
          <q-card-main>
            <table class="q-table">
              <tbody>
                <tr>
                  <th class="text-left">Start Time:</th>
                  <td class="text-right">{{status.start_time}}</td>
                </tr>
                <tr v-if="status.payment_scheme == 'HOURLY'">
                  <th class="text-left">End Time:</th>
                  <td class="text-right">{{status.end_time}}</td>
                </tr>
                <tr>
                  <th class="text-left">Payment Scheme:</th>
                  <td class="text-right">{{status.payment_scheme}}</td>
                </tr>
                <tr v-if="status.payment_scheme == 'HOURLY'">
                  <th class="text-left">Fee:</th>
                  <td class="text-right">€{{status.amount}}</td>
                </tr>
                <tr v-if="status.payment_scheme!='HOURLY'">
                  <th class="text-left">Fee Estimation:</th>
                  <td class="text-right">€{{status.estimate}}</td>
                </tr>
              </tbody>
            </table> 
          </q-card-main>
          <q-card-separator />
          <q-card-actions align="around" v-if="status.payment_scheme=='HOURLY'">
            <q-btn incon="credit card" flat v-on:click="extendPeriod">Extend</q-btn>
            <q-btn icon="input" flat v-on:click="endPeriod">End</q-btn>
          </q-card-actions>

          <q-card-actions align="around" v-if="status.payment_scheme!='HOURLY'">
            <q-btn icon="input" flat v-on:click="endPeriod">End</q-btn>
          </q-card-actions>
        </q-card>
      </div>

      <div class="floating-label" v-if="!status.id">

          <div  class="justify-center animated shake" style="margin: 20px">
            <img src="statics/sad.png" alt="No active parking" width="300" height="240"> <br/>
          </div>
          <br/> <br/>

          <div  class="justify-center" style="text-align: center;">
              <label>It seems like there is no active <br/> </label>
              <label>  parking right now <br/> </label>
              <label>  Please check this page later </label>
          </div>
        
      </div>

    </div>
  </div>
</template>

<script>
import axios from "axios";
import auth from "../auth";
import constants from "../constants";
import {
  QInput,
  QDatetime,
  QBtn,
  QItem,
  QItemSide,
  QItemMain,
  QIcon,
  QCard,
  QCardTitle,
  QCardActions,
  QCardSeparator,
  QCardMain,
  Dialog
} from "quasar";
let BASE_URL = DEV ? "http://localhost:4000" : "http://localhost:4000";
export default {
  components: {
    QInput,
    QDatetime,
    QBtn,
    QItem,
    QItemSide,
    QItemMain,
    QIcon,
    QCard,
    QCardTitle,
    QCardActions,
    QCardSeparator,
    QCardMain,
    Dialog
  },
  data: function() {
    return {
      status: {},
      msg: ""
    };
  },
  methods: {
    extendPeriod: function () {
      var that = this;
      Dialog.create({
        title: "Confirm",
        message: "Are you sure you want to extend your parking period?",
        buttons: [
          {
            label: "Yes",
            handler () {
              axios
                .patch(
                  BASE_URL + `/api/parkings/${that.status.id}/extend`,
                  { status: that.status },
                  { headers: auth.getAuthHeader() }
                )
                .then(response => {
                  this.getStatus();
                })
                .catch(error => {
                  constants.showMsg(error.response.data.msg, "negative");
                });
            }
          },
          {
            label: "No",
            handler() {}
          }
        ]
      });
    },
    endPeriod: function () {
      var that = this;
      Dialog.create({
        title: "Confirm",
        message: "Are you sure you want to end your parking period?",
        buttons: [
          {
            label: "Yes",
            handler() {
              axios
                .patch(
                  BASE_URL + `/api/parkings/${that.status.id}/end`,
                  { status: that.status },
                  { headers: auth.getAuthHeader() }
                )
                .then(response => {

                })
                .catch(error => {
                  constants.showMsg(error.response.data.msg, "negative");
                });
            }
          },
          {
            label: "No",
            handler() {}
          }
        ]
      });
    },
    getStatus: function() {
      axios
        .get(BASE_URL + "/api/parkings/status", {
          headers: auth.getAuthHeader()
        })
        .then(
          response => {
            this.status = response.data;
          },
          error => {
            this.msg = error.response.data.msg;
          }
        );
    }
  },
  mounted: function() {
    //query the backend for the total amount
    if (auth.socket) {
      var channel = auth.getChannel("user:");
      channel
        .join()
        .receive("ok", resp => {
          console.log("Joined successfully", resp);
        })
        .receive("error", resp => {
          console.log("Unable to join", resp);
        });
      channel.on("notifications", payload => {
        if (payload.msg == "Parking Ended") {
          constants.showMsg(payload.msg, "positive");
          if (payload.invoice_id) {
            this.$router.push({
              path: `/${payload.invoice_id}/payments`,
              query: { redirect: "/invoices" }
            });
          } else {
            constants.showMsg(payload.msg, "positive");
            this.$router.push({
              path: `/invoices`
            });
          }
        } else {
          constants.dialog.handler(payload.msg);
        }
      });

      channel.on("extension", payload => {
        if (payload.invoice_id) {
          this.$router.push({
            path: `/${payload.invoice_id}/payments`,
            query: { redirect: "/status" }
          });
        } else {
          this.$router.push({ path: `/invoices` });
        }
      });
    }
    this.getStatus();
  }
};
</script>