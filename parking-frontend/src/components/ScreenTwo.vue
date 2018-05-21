<template>
    <q-layout>
      <div class="container-screentwo">
        <div class="body-screentwo">
          <div class="search-parking-screentwo animated bounceIn"> 
            <img src="statics/card.png" class="logo-two" @click="dummy">
          </div>
        </div>
       
        <div class="foot-wraper-screentwo" id="animationtow">
          <div class="foot-header-screentwo" > 
              <div style="text-align:center;" class="visibility-gone-screentwo" id="title">
                <div> <h5> <strong> <font color="white">Pay your parking</font></strong></h5> </div>
              </div>
          </div>

          <div class="foot-body-screentwo" > 
            <div style="text-align:center; padding-top: 25px" class= "visibility-gone-screentwo" id="footer-body-content">
              <div> <font color="white"> Some discription about this sceen <br/> and some more discription</font></div>
            </div>
          </div>
          
          <div class="foot-footer-screentwo"> 
           
              <div style="width: 20%; float:left;">
                <img src="statics/arrow.jpg" width="42" height="42" class="visibility-back-screentwo" id="leftarrow" style="transform: rotate(180deg); ">
              </div>

              <div style="width: 60%; float:right;" class="visibility-back-screentwo" id="dots">
                <div id="inner" style="padding-top: 10px;" >
                  <div id="inner" style="float:right; margin: 5px"><div id="circle-deactive"/></div>
                  <div id="inner" style="float:right; margin: 5px"><div id="circle-deactive"/></div>
                  <div id="inner" style="float:right; margin: 5px"><div id="circle-deactive"/></div>
                  <div id="inner" style="float:right; margin: 5px"><div id="circle"/></div>
                  <div id="inner" style="float:right; margin: 5px"><div id="circle-deactive"/></div>
                </div>
              </div>

              <div style="width: 20%; float:right; " class="visibility-back-screentwo" id="rightarrow">
                <img src="statics/arrow.jpg" width="42" height="42" align="right">
              </div>
          </div>

        </div>
      </div>
    </q-layout>
</template>
<script>
  import { QLayout } from 'quasar'

  export default {
    name: 'NAV',
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
      document.getElementById('title').className = 'visibility-back-screentwo centertext-screentwo animatedfive zoomIn';
      document.getElementById('footer-body-content').className = 'visibility-back-screentwo centertext-screentwo animatedfive zoomIn';
    }, 250);
  }, 
  methods: {
    dummy(){
      console.log("hello")
    }
  }
};
</script>

<style lang="css">
.container-screentwo {
  width: 100%;
  height: 100vh;
     border: none;
    border-color: transparent;
}
.body-screentwo {
  width: 100%;
  height: 70%;
  background-color: white;
     border: none;
    border-color: transparent;
}
.foot-wraper-screentwo
{
  width: 100%;
  height: 30%;
  background-color: #b82d2a;;
     border: none;
    border-color: transparent;
}
.foot-header-screentwo {
  width: 100%;
  height: 30%;
  display: flex;
}
.foot-body-screentwo {
  width: 100%;
  height: 50%;
     border: none;
    border-color: transparent;
  display: flex;
}
.foot-footer-screentwo {
  width: 100%;
  height: 20%;
  background-color: #8f2320;
  display: flex;
     border: none;
    border-color: transparent;
}
.search-parking-screentwo {
  width: 100%;
  height: 100%;
  position: relative;
     border: none;
    border-color: transparent;
}
.logo-two-screentwo {
  width: 200px;
  height: 200px;    
  margin: 0;
  position: absolute;
  top: 50%;
  left: 50%;
  -ms-transform: translate(-50%, -50%);
  transform: translate(-50%, -50%);
     border: none;
    border-color: transparent;
}

.centertext-screentwo {
    display: block;
    margin-left: auto;
    margin-right: auto;
       border: none;
    border-color: transparent;
}

  #circle-screentwo {
    width: 10px;
    height: 10px;
    -webkit-border-radius: 5px;
    -moz-border-radius: 5px;
    border-radius: 5px;
    background: white;
       border: none;
    border-color: transparent;
  }
    #circle-deactive-screentwo {
    width: 10px;
    height: 10px;
    -webkit-border-radius: 5px;
    -moz-border-radius: 5px;
    border-radius: 5px;
    background: #b82d2a;
       border: none;
    border-color: transparent;
  }

  #inner-screentwo {
  display: table;
  margin: 0 auto;
     border: none;
    border-color: transparent;
}
.center-me-screentwo {
    margin: auto;
    display: inline-block; 
    border:1px solid blue;
       border: none;
    border-color: transparent;
}
.visibility-gone-screentwo {
    visibility: hidden
}
.visibility-back-screentwo {
    visibility: visible
}
</style>

