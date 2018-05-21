<template>
  <div>
    <div class="layout-padding" v-if="visible">
      <allocation-notification :message="message" ></allocation-notification>
    </div>
    <div class="layout-padding" v-if="!visible">
      
		<map-display :location.sync="location" :destination.sync="destination"></map-display>
      <q-field icon="attach money" helper="Choose a Payment Scheme" label="Payment Scheme">
      <q-option-group type="radio" color="indigo" v-model="payment_scheme"
          :options="[
            { label: 'HOURLY', value: 'HOURLY' },
            { label: 'REAL TIME', value: 'REAL_TIME' }
          ]"
        />
    </q-field>
    <q-item>
      <q-item-side icon="access_time" />
      <q-item-main>
        <q-datetime class="no-margin" format24h float-label="Leaving Time" v-model="leaving_time" type="time" />
      </q-item-main>
    </q-item>
    <q-btn icon="input" class="full-width" color="indigo 4" v-on:click="startParking()">
      Start Parking
    </q-btn>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import auth from "../auth";
import EventBus from "../event_bus";
import constants from "../constants";
import {
  QDatetime,
  QInput,
  QBtn,
  QIcon,
  QRadio,
  QChip,
  QField,
  QList,
  QItem,
  QItemSide,
  QItemMain,
  QItemTile,
  QOptionGroup
} from "quasar";

let BASE_URL = DEV ? "http://localhost:4000" : "http://localhost:4000";
export default {
  components: {
    QDatetime,
    QInput,
    QBtn,
    QIcon,
    QRadio,
    QChip,
    QField,
    QList,
    QItem,
    QItemSide,
    QItemMain,
    QItemTile,
    QOptionGroup
    
  },
  data: function() {
    return {
      user: {},
      leaving_time: "",
      payment_scheme: "",
      message: null,
      visible: false,
      destination: "",
      location: {}
    };
  },
  methods: {
    startParking: function() {
      if (this.leaving_time != "") {
        this.leaving_time = this.$moment(this.leaving_time).format(
          "YYYY-MM-DD HH:mm:ss"
        );
      }

      if (this.$moment(this.leaving_time).diff(this.$moment(), "minutes") < 2) {
        constants.showMsg(
          "Leaving time should be more than 2 minutes",
          "negative"
        );
      } else {
        axios
          .post(
            BASE_URL + "/api/parkings",
            {
              longitude: this.location.lng,
              latitude: this.location.lat,
              leaving_time: this.leaving_time,
              payment_scheme: this.payment_scheme
            },
            { headers: auth.getAuthHeader() }
          )
          .then(response => {})
          .catch(error => {
            constants.showMsg(error.response.data.msg, "negative");
          });
      }
    },
    getSettings: function() {
      navigator.geolocation.getCurrentPosition(position => {
        this.location.lng = position.coords.longitude;
        this.location.lat = position.coords.latitude;
      });
      axios
        .get(BASE_URL + "/api/users/current", { headers: auth.getAuthHeader() })
        .then(response => {
          this.user = response.data;
          this.payment_scheme = response.data.payment_scheme;
        })
        .catch(error => {
          console.log("user error: " + error);
        });
    }
  },
  created: function() {
    EventBus.$emit("page", "Start");
  },
  mounted: function() {
    this.getSettings();
    if (constants.getLeavingTime()) {
      this.leaving_time = constants.getLeavingTime();
    } else {
      this.leaving_time = new Date(this.$moment().add(1, "hours"));
    }

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

      channel.on("requests", payload => {
        this.message = payload;
        this.visible = true;
      });
      channel.on("notifications", payload => {
        this.visible = false;

        if (payload.msg == "Parking Started") {
          constants.showMsg(payload.msg, "positive");
          if (payload.invoice_id) {
            this.$router.push({
              path: `/${payload.invoice_id}/payments`,
              query: { redirect: "/status" }
            });
          } else {
            this.$router.push({ path: `/status` });
          }
        } else {
          constants.showMsg(payload.msg, "negative");
        }
      });
    }
  }
};
</script>