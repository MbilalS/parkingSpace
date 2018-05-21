<template>
	<div class="layout-padding">
		<map-display :location.sync="location" :destination.sync="destination"></map-display>
		<div>
			<q-btn icon="input" class="full-width" color="indigo 4" v-on:click="submitSearchRequest()">Search</q-btn>
		</div >
		<q-list inset-separator v-if="spaces.length>0">
			<div v-for="(space,index) in spaces">
				 <q-collapsible indent icon="beenhere" :class="space.zone_name "  :label="space.location + ' (' +space.available_slots
 + ' spaces)'" @open="draw_space(index)" @close="redraw()">
						<div class="result">
							<p> <b>Zone:</b> {{space.zone_name}} </p>
							<p> <b>{{space.distance}} metres</b> from {{destination}} </p>
              <div v-if="!space.fee">
								<p v-if="space.prices.hourly"> <b>Price 1:</b> &euro;{{space.prices.hourly}} per hour</p>
								<p v-if="space.prices.realtime"> <b>Price 2:</b> &euro;{{space.prices.realtime}} per 5mins</p>
                <p v-if="space.prices.free && space.prices.unlimited"> <b>Price: </b>Free Unlimited</p>
                <p v-if="space.prices.free && !space.prices.unlimited"> <b>Price: </b>Free Limited</p>
							</div>
							<div v-if="space.fee">
								<p v-if="space.fee.hourly_amount"> <b>Hourly:</b> &euro;  {{space.fee.hourly_amount}} </p>
								<p v-if="space.fee.realtime_amount"> <b>Real-Time:</b> &euro;  {{space.fee.realtime_amount}} </p>
                <p v-if="space.fee.free">  <b>Free</b> </p>
							</div>
						</div>
				 </q-collapsible>
			</div>
			</q-list>
		<q-item>
			<q-item-side icon="near me"/> 
			<q-item-main>
				<q-input :attributes="{id:'search_box'}"  v-model="destination" float-label="Destination"/>
			</q-item-main>
		</q-item>
		<q-item>
			<q-item-side icon="access_time" />
			<q-item-main>
				<q-datetime class="no-margin" format24h float-label="Leaving Time" v-model="leaving_time" type="time"
					@change="timeChanged($event)" />
			</q-item-main>
		</q-item>
	</div>
</template>

<script>
import axios from "axios";
import constants from "../constants";
import EventBus from "../event_bus";
import {
  QInput,
  QDatetime,
  QBtn,
  QItem,
  QItemSide,
  QItemMain,
  QIcon,
  QList,
  QCollapsible
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
    QList,
    QCollapsible
  },
  data: function() {
    return {
      destination: "",
      location: {},
      leaving_time: "",
      spaces: []
    };
  },
  methods: {
    timeChanged: value => {
      constants.setLeavingTime(value);
    },

    submitSearchRequest: function() {
      this.spaces = [];
      if (this.leaving_time != "") {
        this.leaving_time = this.leaving_time.split(".")[0].replace("T", " ");
      }
      axios
        .get(
          BASE_URL +
            "/api/parkings?destination=" +
            this.destination +
            "&leaving_time=" +
            this.leaving_time
        )
        .then(
          response => {
            this.spaces = response.data.spaces;
            EventBus.$emit("location", response.data.location);
            this.location = response.data.location;
            EventBus.$emit("draw", this.spaces);
          },
          error => {
            constants.showMsg(error.response.data.msg, "warning");
            EventBus.$emit("redraw", this.spaces);
          }
        );
    },
    redraw: function() {
      EventBus.$emit("redraw", this.spaces);
    },
    draw_space: function(index) {
      EventBus.$emit("draw_space", this.spaces, index);
    }
  },
  mounted: function() {
     EventBus.$emit("page", "Search");
      EventBus.$on("destination", destination => {
       this.destination = destination;
     });
  }
};
</script>
<style>
.A i {
  color: #f65314;
}
.B i {
  color: #105990;
}
.C,
.D i {
  color: green;
}
</style>
