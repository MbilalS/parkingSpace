import Vue from 'vue'
import VueRouter from 'vue-router'
import auth from './auth'

const requireAuth = (to, _from, next) => {
  if (!auth.authenticated()) {
    next({
      path: '/login',
      query: { redirect: to.fullPath }
    })
  }
  else {
    next()
  }
}

const afterAuth = (_to, from, next) => {
  if (auth.authenticated()) {
    next(from.path)
  }
  else {
    next()
  }
}

Vue.use(VueRouter)

function load (component) {
  // '@' is aliased to src/components
  return () => import(`@/${component}.vue`)
}

Vue.component('allocation-notification', load('Notification'))
Vue.component('map-display', load('Map'))
Vue.component('navigation-layout', load('NavigationLayout'))

export default new VueRouter({
  /*
   * NOTE! VueRouter "history" mode DOESN'T works for Cordova builds,
   * it is only to be used only for websites.
   *
   * If you decide to go with "history" mode, please also open /config/index.js
   * and set "build.publicPath" to something other than an empty string.
   * Example: '/' instead of current ''
   *
   * If switching back to default "hash" mode, don't forget to set the
   * build publicPath back to '' so Cordova builds work again.
   */

  mode: 'hash',
  scrollBehavior: () => ({ y: 0 }),

  routes: [
    { path: '/', component: load('Search') },
    { path: '/login', component: load('Login'), beforeEnter: afterAuth },
    { path: '/start', component: load('Start'), beforeEnter: requireAuth },
    { path: '/status', component: load('Status'), beforeEnter: requireAuth },
    { path: '/invoices', component: load('Invoices'), beforeEnter: requireAuth },
    { path: '/settings/:id', component: load('Settings'), beforeEnter: requireAuth },
    { path: '/signup', component: load('UserCreation'), beforeEnter: afterAuth },
    { path: '/:id/change-password', component: load('ChangePassword'), beforeEnter: requireAuth },
    { path: '/settings', component: load('Settings'), beforeEnter: requireAuth },
    { path: '/:id/payments', component: load('Payment'), beforeEnter: requireAuth },
    // onBoarding screens
    { path: '/s0', component: load('SplashScreen') }, // this will trigger this onBoarding.. change it later
    { path: '/s1', component: load('S1') },
    { path: '/s2', component: load('S2') },
    { path: '/s3', component: load('S3') },
    { path: '/s4', component: load('S4') },
    { path: '/splashscreen', component: load('SplashScreen') },
    // Always leave this last one
    { path: '*', component: load('Error404') } // Not found
  ]
})
