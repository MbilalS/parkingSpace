<template>
<div class="layout-padding animated pulse">
    
    <div class="row justify-center" style="width: 100%;  margin-bottom: -65px; margin-top: 25px;">
      <div  class="justify-center">
        <img src="statics/signup.png" alt="change password" width="150" height="120"> <br/>
          <!-- <h5>Sign up</h5> -->
      </div>
    </div>

    <!-- <div class="background" style=" padding: 25px; margin: 0px 10px 10px">
    
      <q-field icon="account circle"  label="Name" style="margin-top: 60px">
        <q-input id="name" v-model="user.name" dark color="white" />
      </q-field>

      <q-field icon="email"  label="Email" >
        <q-input id="email" v-model="user.email"  color="white" dark/>
      </q-field>

      <q-field icon="lock"  label="Password" >
        <q-input type="password" v-model="user.password" dark color="white"/>
      </q-field>

      <q-field icon="lock"  label="Conform Password" >
        <q-input type="password" v-model="user.password_confirmation" dark color="white"/>
      </q-field>

    </div> -->

    <div class="background" style=" padding: 25px; margin: 0px 10px 10px">
  
      <q-input id="name" stack-label="Name" color="white" v-model="user.name" style="border-radius: 10px; margin-top: 60px; padding: 10px; background: #fff;"/>
      <q-input id="name" stack-label="Email" color="white" v-model="user.email" style="border-radius: 10px; padding: 10px; background: #fff;"/>
      <q-input id="name" stack-label="Password" color="white" v-model="user.password" style="border-radius: 10px; padding: 10px; background: #fff;"/>
      <q-input id="name" stack-label="Conform Password" color="white" v-model="user.password_confirmation" style="border-radius: 10px; padding: 10px; background: #fff;"/>
     
    <div >
       <q-btn outline style="color: #fff;border-radius: 10px; width: 100%; margin-top: 10px" icon="input" color="white" v-on:click="submit">Submit</q-btn>
    </div>
    
    </div>



    <div class="row justify-center">
      <a v-on:click="login">Already have an account? Login here</a>
    </div>
      
  </div>
</template>

<script>
  import axios from 'axios';
  import auth from "../auth";
  import constants from "../constants";
  import EventBus from '../event_bus';
  import { QInput, QDatetime, QBtn, QItem, QItemSide, QItemMain, QIcon, QField } from 'quasar'
  let BASE_URL = DEV ? 'http://localhost:4000' : 'http://localhost:4000';
  export default {
    components: {
      QInput, QDatetime, QBtn, QItem, QItemSide, QItemMain, QIcon, QField
    },
    data: function() {
      return {
      user:{}
      }
    },
    methods: {
      submit: function() {
        axios.post(BASE_URL + "/api/users/",this.user)
          .then(response => {
            constants.showMsg(response.data.msg,'positive');
            this.$router.push({ path: `/login` })
          })
          .catch(error => {
            constants.showMsg("Something went wrong",'negative');
        });
      },
      login: function () {
        this.$router.push({ path: `/login` })
      }
    },
    mounted: function() {
      EventBus.$emit('display', false);
    }
  }
</script>
<style>
  a {
    padding-top: 15px;
    color: #7986cb;
  }
  a:hover {
    color: #a57fc0;
  }
  .icon-color {
    color: #3f51b5
  }

   .background {
     background: #3f51b5; /* For browsers that do not support gradients */
     border-radius: 25px;

  } 

  .textfeild {
    margin: 10px 20px
  }
</style>
