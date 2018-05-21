<template>
    <q-layout>
      <div class="container">
        <div class="body">
          <div class="search-parking animated bounceIn"> 
            <img src="statics/parking.png" class="logo-two" >
          </div>
        </div>
       
        <div class="foot-wraper animated slideInUp" id="animationtow">
          <div class="foot-header" > 
              <div style="text-align:center;" class="visibility-gone" id="title">
                <div> <h5> <strong> <font color="white">Find your parking </font></strong></h5> </div>
              </div>
          </div>

          <div class="foot-body" > 
            <div style="text-align:center; padding-top: 25px" class= "visibility-gone" id="footer-body-content">
              <div> <font color="white"> Some discription about this sceen <br/> and some more discription</font></div>
            </div>
          </div>
          
          <div class="foot-footer"> 
           
              <div style="width: 20%; float:left;">
                <img src="statics/arrow.jpg" width="42" height="42" class="visibility-gone" id="leftarrow" style="transform: rotate(180deg); ">
              </div>

              <div style="width: 60%; float:right;" class="visibility-gone" id="dots">
                <div id="inner" style="padding-top: 10px;" >
                  <div id="inner" style="float:right; margin: 5px"><div id="circle-deactive"/></div>
                  <div id="inner" style="float:right; margin: 5px"><div id="circle-deactive"/></div>
                  <div id="inner" style="float:right; margin: 5px"><div id="circle-deactive"/></div>
                  <div id="inner" style="float:right; margin: 5px"><div id="circle-deactive"/></div>
                  <div id="inner" style="float:right; margin: 5px"><div id="circle"/></div>
                </div>
              </div>

              <div style="width: 20%; float:right; " class="visibility-gone" id="rightarrow">
                <img src="statics/arrow.jpg" width="42" height="42" align="right" @click="dummy">
              </div>
          </div>

        </div>
      </div>
    </q-layout>
</template>
<script>
  import { QLayout } from 'quasar'

  export default {
    name: 'screen1',
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
      document.getElementById('title').className = 'visibility-back centertext animatedfive zoomIn';
      document.getElementById('footer-body-content').className = 'visibility-back centertext animatedfive zoomIn';
      document.getElementById('leftarrow').className = 'visibility-back  animated fadeIn';
      document.getElementById('rightarrow').className = 'visibility-back  animated fadeIn';
      document.getElementById('dots').className = 'visibility-back  animated fadeIn';
    }, 1000);
  }, 
  methods: {
    dummy(){
      document.location.href = 'http://localhost:8080/#/screentwo'
    }
  }
};
</script>

<style lang="css">
.container {
  width: 100%;
  height: 100vh;
}
.body {
  width: 100%;
  height: 70%;
  background-color: white;
}
.foot-wraper
{
  width: 100%;
  height: 30%;
  background-color: #b82d2a;
}
.foot-header {
  width: 100%;
  height: 30%;
  display: flex;
}
.foot-body {
  width: 100%;
  height: 50%;
  display: flex;
}
.foot-footer {
  width: 100%;
  height: 20%;
  background-color: #8f2320;
  display: flex;
}
.search-parking {
  width: 100%;
  height: 100%;
  position: relative;
}
.logo-two {
  width: 200px;
  height: 200px;    
  margin: 0;
  position: absolute;
  top: 50%;
  left: 50%;
  -ms-transform: translate(-50%, -50%);
  transform: translate(-50%, -50%);
}

.centertext {
    display: block;
    margin-left: auto;
    margin-right: auto;
}

  #circle {
    width: 10px;
    height: 10px;
    -webkit-border-radius: 5px;
    -moz-border-radius: 5px;
    border-radius: 5px;
    background: white;
  }
    #circle-deactive {
    width: 10px;
    height: 10px;
    -webkit-border-radius: 5px;
    -moz-border-radius: 5px;
    border-radius: 5px;
    background: #b82d2a;
  }

  #inner {
  display: table;
  margin: 0 auto;
}
.center-me {
    margin: auto;
    display: inline-block; 
    border:1px solid blue;
}
.visibility-gone {
    visibility: hidden
}
.visibility-back {
    visibility: visible
}
</style>

