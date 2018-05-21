<template>
  <div class="layout-padding row justify-center">
   
    <div  class="row justify-center animated rotateIn" style="margin: 20px">
      <img src="statics/settings.png" alt="Settings" width="180" height="115"> <br/>
    </div>


    <div style="width: 500px; max-width: 100vw;" class="animated fadeIn">
      <q-item>


        <div >
          <q-btn outline style="border-radius: 10px; width: 90%; margin-top: 10px" icon="vpn key" color="indigo"  @click="changePassword">Change password</q-btn>
        </div>

        <div >
          <q-btn outline style="border-radius: 10px;  margin-top: 10px" icon="power settings new" color="red"  v-on:click="logout()">Log out</q-btn>
        </div>

      </q-item>
     
        <q-input  dark id="user_name" stack-label="Name" v-model="user.name" color="white" style="border-radius: 10px;padding: 10px; background: #3f51b5; margin: 15px;"/>
        <q-input  dark id="email" stack-label="Email" v-model="user.email" color="white" style="border-radius: 10px;padding: 10px; background: #3f51b5; margin: 15px;"/>

  
      <q-field icon="attach money" helper="Pick a Payment Scheme" label="Payment Scheme">
        <q-option-group type="radio"color="indigo 4" v-model="user.payment_scheme"
          @change = "update"
          :options="[
            { label: 'HOURLY', value: 'HOURLY' },
            { label: 'REAL TIME', value: 'REAL_TIME' }
          ]"
        />
      </q-field>
      <q-field v-if="user.payment_scheme=='REAL_TIME'" icon="vibration" helper="When do you want to get your invoice?" label="Invoiced">
        <q-option-group type="radio" color="indigo 4" v-model="user.invoiced"
          @change = "update"
          :options="[
            { label: 'IMMEDIATELY', value: 'IMMEDIATELY' },
            { label: 'MONTHLY', value: 'MONTHLY' }
          ]"
        />
      </q-field>
    </div>
  </div>
</template>

<script>
  import axios from 'axios';
  import auth from "../auth";
  import constants from "../constants";
  let BASE_URL = DEV ? 'http://localhost:4000' : 'http://localhost:4000';
  import { QInput, QBtn, QIcon, QRadio, QChip, QField, QList, QItem, QItemSide, QItemMain, QItemTile, QOptionGroup } from 'quasar'
  export default {
    components: {
      QInput, QBtn, QIcon, QRadio, QChip, QField, QList, QItem, QItemSide, QItemMain, QItemTile, QOptionGroup
    },
    data: () => {
      return {
        user:{}
      }
    },
    methods : {
      changePassword: function(){
        this.$router.push({ path: `/${this.user.id}/change-password` })
      },
      logout: function() {
        auth.logout(this, { headers: auth.getAuthHeader() });
        constants.showMsg("Successfully Logged out!",'positive')
      },
      update: function() {
        axios.patch(BASE_URL + "/api/users/"+this.user.id,this.user,{ headers :auth.getAuthHeader()})
          .then(response => {
            this.getSettings()
          })
          .catch(error => {
            constants.showMsg("Something went wrong",'negative');
        });
      },
      getSettings: function() {
        axios.get(BASE_URL + "/api/users/current", { headers: auth.getAuthHeader() })
          .then(response => {
            this.user = response.data 
          })
          .catch(error => {
            constants.showMsg("Something went wrong",'negative');
        });
      }
    },
    mounted: function () {
       this.getSettings();
  }
}
</script>

<style>
   .background {
     background: #3f51b5; /* For browsers that do not support gradients */
     border-radius: 25px;

  } 

  .textfeild {
    margin: 10px 20px
  }
</style>
