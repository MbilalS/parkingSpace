<template>
  <q-layout> 
      <div class="animation-wrapper">
          <div class="inner-animation-wrapper animated bounceIn" id="animation">
            <img src="statics/icon.png" class="logo">
          </div>
      </div>
  </q-layout>
</template>

<script>
import { QLayout } from 'quasar'

export default {
  name: 'splash',
  components: {
    QLayout
  },
  created() {}, 
  mounted: function() {
    setTimeout(function() {
      document.getElementById('animation').classList.remove('bounceIn')
      document.getElementById('animation').classList.add('bounceOut')
    }, 2000)

    setTimeout(function() {
      document.location.href = 'http://localhost:8080/#/s1'
    }, 3100)
  }
};
</script>

<style lang="css">
.logo {
  width: 250px;
  height: 250px;
  position: absolute;
  left: 50%;
  top: 50%;
  margin-left: -125px;
  margin-top: -125px;
}
.animation-wrapper {
  height: 100vh;
  background-color: white;
}
.inner-animation-wrapper {
  width: 100%;
  height: 100%;
  display: flex;
}



</style>
