<template>
  <div class="layout-padding">
   
    <div class="row justify-center animated bounceIn" style="margin-top: 80px">
      <img src="statics/login.png" alt="change password" width="150" height="120" style="margin-bottom: -60px"> <br/>
    </div>

    <div class="background-login"> 
      <q-field icon="account box" helper="Email" :count="30" style="margin-top: 60px">
        <q-input type="email" v-model="username" dark color="white"/>
      </q-field>
      <q-field icon="lock" helper="Password" :count="15">
        <q-input type="password" v-model="password" dark color="white"/>
      </q-field>

      <div >  
       <q-btn outline style="color: #fff;border-radius: 10px; width: 100%; margin-top: 30px" icon="input" color="white" v-on:click="login">Login</q-btn>
      </div>

    </div>
    <!-- <q-btn icon="input" class="full-width" color="indigo 4" v-on:click="login">Log in</q-btn> -->
    <div class="row justify-center">
      <a v-on:click="register">Register here</a>
    </div>
      
  </div>
</template>

<script>
  import auth from './../auth';
  import EventBus from '../event_bus';
  import { QField, QInput, QBtn, QIcon } from 'quasar'
  export default {
    components: {
      QField, QInput, QBtn, QIcon
    },
    data: function () {
      return {
        username: '',
        password: '',
        redirect: '/'
      }
    },
    methods: {
      login: function () {
        auth.login(this, {email: this.username, password: this.password}, this.redirect);
        EventBus.$emit('display', true);
      },
      register: function () {
        this.$router.push({ path: `/signup` })
      }
    },
    mounted: function () {
      EventBus.$emit('display', false);
      if(this.$route.query.redirect) {
        this.redirect = this.$route.query.redirect;
      }
       
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
  .background-login {
    background: #3f51b5; /* For browsers that do not support gradients */
    border-radius: 25px;
    padding: 20px;
    display: block;
    margin: auto;
    width: 90%;
  } 
</style>
