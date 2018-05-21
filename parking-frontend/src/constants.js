import { Toast, Dialog } from 'quasar'
export default {
  leaving_time: null,
  showMsg: function (msg, type) {
    Toast.create[type]({html: msg, position: top, timeout: 10000})
  },
  getLeavingTime: function () {
    return this.leaving_time
  },
  setLeavingTime: function (time) {
    this.leaving_time = time
  },
  dialog: {
    label: 'Parking Time',
    icon: 'warning',
    handler (msg) {
      Dialog.create({
        title: 'Time about to end!',
        message: msg
      })
    }
  }
}