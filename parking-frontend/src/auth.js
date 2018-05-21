import axios from 'axios'
import {Socket} from 'phoenix'
import { Toast, Dialog } from 'quasar'
let BASE_URL = DEV ? 'http://localhost:4000' : 'http://localhost:4000'
let SOCKET_URL = DEV ? 'ws://localhost:4000' : 'ws://localhost:4000'
export default {
  user: { role: '', username: '' },
  socket: null,
  login: function (context, creds, redirect) {
    axios.post(BASE_URL + '/api/sessions', creds)
      .then(response => {
        this.username = creds.email
        this.user.role = response.data.role
        window.localStorage.setItem('token-' + this.username, response.data.token)
        window.localStorage.setItem('username', this.username)
        if (redirect) {
          context.$router.push({path: redirect})
        }

        this.socket = new Socket(SOCKET_URL + '/socket', {params: {token: response.data.token}})
        this.socket.connect()
      })
      .catch( error => {
        Toast.create['negative']({html: 'Unknown email or password', position: 'top', timeout: 10000})
      })
  },
  logout: function (context, options) {
    axios.delete(BASE_URL + '/api/sessions/1', options)
      .then(response => {
        window.localStorage.removeItem('token-' + this.username)
        window.localStorage.removeItem('firstRun')
        this.user.authenticated = false
        this.user.username = ''
        this.socket = null
        context.$router.push({path: '/'})
      }).catch(error => {
        console.log(error)
      })
  },
  getChannel: function (prefix) {
    var token = window.localStorage.getItem('token-' + this.username)
    var channel = this.socket.channel(prefix + this.username, { guardian_token: token })
    return channel
  },
  authenticated: function () {
    // this.username = this.getUsername()
    const jwt = window.localStorage.getItem('token-' + this.username)
    return !!jwt
  },
  getUsername: function () {
    const username = window.localStorage.getItem('username')
    return username || ''
  },
  getAuthHeader: function () {
    return {
      'Authorization': window.localStorage.getItem('token-' + this.username)
    }
  }
}
