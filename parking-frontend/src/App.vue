<template>
  <!-- Don't drop "q-app" class -->
  <div id="q-app">
    <!-- <navigation-layout> </navigation-layout> -->
    <router-view />
    <q-layout :view="'lHh Lpr lFf'">
        <q-tabs slot="footer" color="indigo">
            <q-route-tab slot="title" icon="my location" to="/" replace label="Parking" />
            <q-route-tab slot="title" icon="local_parking" to="/start" replace label="Start" />
            <q-route-tab slot="title" icon="settings" to="/status" replace label="Status" />
            <q-route-tab slot="title" icon="receipt" to="/invoices" replace label="Invoices" />
            <q-route-tab slot="title" icon="settings" to="/settings" replace label="Settings" />
        </q-tabs>
    </q-layout>
  </div>
</template>

<script>
/*
 * Root component
 */
  import { QLayout, QTabs, QRouteTab } from 'quasar'
  import EventBus from './event_bus'
  export default {
    components: { QLayout, QTabs, QRouteTab 
    },
    data: function(){
      return {
          display: false 
      }
    },
    mounted: function() {
      // var firstRun = window.localStorage.getItem('firstRun');
      // if (firstRun == undefined) {
      //   window.localStorage.setItem('firstRun', 1);
      //   this.$router.push({ path: `/s0` })
      // }
      // else {
      //   this.display = true;
      // }
      // EventBus.$on('display', value => {
      //   this.display = value;
      // })
    }
}
</script>

<style>
</style>
