<template>
    <q-layout>
      <div class="container-searchparking">
        <div class="body-searchparking">
          <div class="search-parking-searchparking animated bounceIn"> 
            <img src="statics/card.png" class="logo-two" width="200" height="200">
          </div>
        </div>
       
        <div class="foot-wraper-searchparking" id="animationtow">
          <div class="foot-header-searchparking" > 
              <div style="text-align:center;" class="visibility-gone-searchparking" id="title">
                <div> <h5> <strong> <font color="white">Pay your parking</font></strong></h5> </div>
              </div>
          </div>

          <div class="foot-body-searchparking" > 
            <div style="text-align:center; padding-top: 25px" class= "visibility-gone-searchparking" id="footer-body-content">
              <div> <font color="white"> Select your payment Scheme <br/> and pay Monthly or Immediately</font></div>
            </div>
          </div>
          
          <div class="foot-footer-searchparking"> 
           
              <div style="width: 20%; float:left;">
                <img src="statics/arrow.png" width="42" height="42" class="visibility-back-searchparking" id="leftarrow" style="transform: rotate(180deg);" @click="dummyback">
              </div>

              <div style="width: 60%; float:right;" class="visibility-back-searchparking" id="dots">
                <div id="inner" style="padding-top: 10px;" >
                  <div id="inner" style="float:right; margin: 5px"><div id="circle-deactive"/></div>
                  <div id="inner" style="float:right; margin: 5px"><div id="circle"/></div>
                  <div id="inner" style="float:right; margin: 5px"><div id="circle-deactive"/></div>
                  <div id="inner" style="float:right; margin: 5px"><div id="circle-deactive"/></div>
                </div>
              </div>

              <div style="width: 20%; float:right; " class="visibility-back" id="rightarrow">
                <img src="statics/arrow.png" width="42" height="42" align="right" @click="dummy">
              </div>
          </div>

        </div>
      </div>
    </q-layout>
</template>
<script>
  import { QLayout } from 'quasar'

  export default {
    name: 's3',
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
      document.getElementById('title').className = 'visibility-back-searchparking centertext-searchparking animatedfive zoomIn';
      document.getElementById('footer-body-content').className = 'visibility-back-searchparking centertext-searchparking animatedfive zoomIn';
    }, 250);
  }, 
  methods: {
    dummy(){
       document.location.href = 'http://localhost:8080/#/s4'
    },
    dummyback(){
       document.location.href = 'http://localhost:8080/#/s2'
    }
  }
};
</script>

<style lang="css">
.container-searchparking {
  width: 100%;
  height: 100vh;
}
.body-searchparking {
  width: 100%;
  height: 70%;
  background-color: white;
}
.foot-wraper-searchparking
{
  width: 100%;
  height: 30%;
  background-color: #485dcf;
}
.foot-header-searchparking {
  width: 100%;
  height: 30%;
  display: flex;
}
.foot-body-searchparking {
  width: 100%;
  height: 50%;
  display: flex;
}
.foot-footer-searchparking {
  width: 100%;
  height: 20%;
  background-color: #3f51b5;
  display: flex;
}
.search-parking-searchparking {
  width: 100%;
  height: 100%;
  position: relative;
}
.logo-two-searchparking {
  width: 200px;
  height: 200px;    
  margin: 0;
  position: absolute;
  top: 50%;
  left: 50%;
  -ms-transform: translate(-50%, -50%);
  transform: translate(-50%, -50%);
}

.centertext-searchparking {
    display: block;
    margin-left: auto;
    margin-right: auto;
}

  #circle-searchparking {
    width: 10px;
    height: 10px;
    -webkit-border-radius: 5px;
    -moz-border-radius: 5px;
    border-radius: 5px;
    background: white;
  }
    #circle-deactive-searchparking {
    width: 10px;
    height: 10px;
    -webkit-border-radius: 5px;
    -moz-border-radius: 5px;
    border-radius: 5px;
    background: #485dcf;
  }

  #inner-searchparking {
  display: table;
  margin: 0 auto;
}
.center-me-searchparking {
    margin: auto;
    display: inline-block; 
    border:1px solid blue;
}
.visibility-gone-searchparking {
    visibility: hidden
}
.visibility-back-searchparking {
    visibility: visible
}
</style>

