<template>
  <div class="layout-padding">
    
   <div  class="row justify-center animated slideInDown" style="margin: 20px">
      <img src="statics/changepassword.png" alt="No active parking" width="150" height="150"> <br/>
    </div>

    <div class="background animated slideInUp" style=" padding: 25px; margin: 10px">
      <q-input type="password" stack-label="Password" color="white" v-model="password" style="border-radius: 10px;padding: 10px; background: #fff;"/>
      <q-input type="password" stack-label="Re enter password" color="white" v-model="confirmation" style="border-radius: 10px;padding: 10px; background: #fff;"/>
     
      <div >
        <q-btn outline style="color: #fff;border-radius: 10px; width: 100%; margin-top: 10px" icon="input" color="white"  v-on:click="submitNewPassword()">Change password</q-btn>
      </div>
    
    </div>

  </div>
</template>

<script>
  import axios from 'axios';
  import auth from "../auth";
  import constants from "../constants";
  import { QInput, QDatetime, QBtn, QItem, QItemSide, QItemMain, QIcon,Toast,
  Dialog } from 'quasar'
  let BASE_URL = DEV ? 'http://localhost:4000' : 'http://localhost:4000';
  export default {
    components: {
      QInput, QDatetime, QBtn, QItem, QItemSide, QItemMain, QIcon
    },
    data: function() {
      return {
      user_id: "",
      password: "",
      confirmation: ""
      }
    },
    methods: {
      submitNewPassword: function() {
        axios.patch(BASE_URL + "/api/users/"+this.user_id+"/change-password",
        {password: this.password, password_confirmation: this.confirmation},{headers :auth.getAuthHeader()})
          .then(response => {
            this.password = "";
            this.confirmation = "";
            constants.showMsg(response.data.msg, "positive");
            this.$router.push("/settings")
          })
          .catch(error => {
            constants.showMsg("Password Mismatch", "negative");
        });
      }
    },
    mounted: function() {
      this.user_id = this.$route.params.id;
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
