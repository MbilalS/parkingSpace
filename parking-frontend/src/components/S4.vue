<template>
    <q-layout>
      <div class="container-s4">
        <div class="body-s4">
          <div class="search-parking-s4 animated bounceIn"> 
            <img src="statics/positivePurple.png" class="logo-two" width="200" height="200">
          </div>
        </div>
       
        <div class="foot-wraper-s4" id="animationtow">
          <div class="foot-header-s4" > 
              <div style="text-align:center;" class="visibility-gone-s4" id="title">
                <div> <h5> <strong> <font color="white">Lets Get Started</font></strong></h5> </div>
              </div>
          </div>

          <div class="foot-body-s4" > 
            <div style="text-align:center; padding-top: 25px" class= "visibility-gone-s4" id="footer-body-content">
              <div> <font color="white"> You are all set<br/> Lets start the app</font></div>
            </div>
          </div>
          
          <div class="foot-footer-s4"> 
           
              <div style="width: 20%; float:left;">
                <img src="statics/arrow.png" width="42" height="42" class="visibility-back-s4" id="leftarrow" style="transform: rotate(180deg);" @click="dummyback">
              </div>

              <div style="width: 60%; float:right;" class="visibility-back-s4" id="dots">
                <div id="inner" style="padding-top: 10px;" >
                  <div id="inner" style="float:right; margin: 5px"><div id="circle"/></div>
                  <div id="inner" style="float:right; margin: 5px"><div id="circle-deactive"/></div>
                  <div id="inner" style="float:right; margin: 5px"><div id="circle-deactive"/></div>
                  <div id="inner" style="float:right; margin: 5px"><div id="circle-deactive"/></div>
                </div>
              </div>

              <div style="width: 20%; float:right; " class="visibility-back" id="rightarrow">
                <!-- <img src="statics/arrow.jpg" width="42" height="42" align="right" @click="dummy"> -->
                <div style="text-align: center; padding-top: 10px;">
                  <label @click="dummy"><font size=3 color="white"> Finish </font> </label>
                </div>
              </div>
          </div>

        </div>
      </div>
    </q-layout>
</template>
<script>
  import { QLayout } from 'quasar'
  import EventBus from '../event_bus'

  export default {
    name: 's4',
    components: {
      QLayout
    },
  created() {},
  mounted: function() {
    // setTimeout(function() {
    //   document.getElementById('animation').classList.remove('bounceIn')
    //   document.getElementById('animation').classList.add('bounceOut')
    // }, 2000)

    // setTimeout(function() {
    //   document.location.href = 'http://localhost:8080/#/nav'
    // }, 3100)
    setTimeout(function(){ 
      document.getElementById('title').className = 'visibility-back-s4 centertext-s4 animatedfive zoomIn';
      document.getElementById('footer-body-content').className = 'visibility-back-s4 centertext-s4 animatedfive zoomIn';
    }, 250);
  }, 
  methods: {
    dummy(){
      document.location.href = 'http://localhost:8080/#/'
      EventBus.$emit('display', true);
    },
    dummyback(){
       document.location.href = 'http://localhost:8080/#/s2'
    }
  }
};
</script>

<style lang="css">
.container-s4 {
  width: 100%;
  height: 100vh;
}
.body-s4 {
  width: 100%;
  height: 70%;
  background-color: white;
}
.foot-wraper-s4
{
  width: 100%;
  height: 30%;
  background-color: #485dcf;
}
.foot-header-s4 {
  width: 100%;
  height: 30%;
  display: flex;
}
.foot-body-s4 {
  width: 100%;
  height: 50%;
  display: flex;
}
.foot-footer-s4 {
  width: 100%;
  height: 20%;
  background-color: #3f51b5;
  display: flex;
}
.search-parking-s4 {
  width: 100%;
  height: 100%;
  position: relative;
}
.logo-two-s4 {
  width: 200px;
  height: 200px;    
  margin: 0;
  position: absolute;
  top: 50%;
  left: 50%;
  -ms-transform: translate(-50%, -50%);
  transform: translate(-50%, -50%);
}

.centertext-s4 {
    display: block;
    margin-left: auto;
    margin-right: auto;
}

  #circle-s4 {
    width: 10px;
    height: 10px;
    -webkit-border-radius: 5px;
    -moz-border-radius: 5px;
    border-radius: 5px;
    background: white;
  }
    #circle-deactive-s4 {
    width: 10px;
    height: 10px;
    -webkit-border-radius: 5px;
    -moz-border-radius: 5px;
    border-radius: 5px;
    background: #485dcf;
  }

  .inner-s4 {
  display: table;
  margin: 0 auto;
}
.center-me-s4 {
    margin: auto;
    display: inline-block; 
    border:1px solid blue;
}
.visibility-gone-s4 {
    visibility: hidden
}
.visibility-back-s4 {
    visibility: visible
}
</style>

