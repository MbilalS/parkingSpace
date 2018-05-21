webpackJsonp([19],{273:function(t,e,i){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var n=i(295),a=i(349),o=i(131),s=o(n.a,a.a,!1,null,null,null);e.default=s.exports},277:function(t,e,i){"use strict";var n=i(2);e.a={leaving_time:null,showMsg:function(t,e){n.B.create[e]({html:t,position:top,timeout:1e4})},getLeavingTime:function(){return this.leaving_time},setLeavingTime:function(t){this.leaving_time=t},dialog:{label:"Parking Time",icon:"warning",handler:function(t){n.a.create({title:"Time about to end!",message:t})}}}},295:function(t,e,i){"use strict";var n=i(133),a=i.n(n),o=i(132),s=i(134),l=i(277),c=i(2);e.a={components:{QDatetime:c.k,QInput:c.n,QBtn:c.b,QIcon:c.m,QRadio:c.w,QChip:c.h,QField:c.l,QList:c.t,QItem:c.o,QItemSide:c.q,QItemMain:c.p,QItemTile:c.r,QOptionGroup:c.v},data:function(){return{user:{},leaving_time:"",payment_scheme:"",message:null,visible:!1,destination:"",location:{}}},methods:{startParking:function(){""!=this.leaving_time&&(this.leaving_time=this.$moment(this.leaving_time).format("YYYY-MM-DD HH:mm:ss")),this.$moment(this.leaving_time).diff(this.$moment(),"minutes")<2?l.a.showMsg("Leaving time should be more than 2 minutes","negative"):a.a.post("http://localhost:4000/api/parkings",{longitude:this.location.lng,latitude:this.location.lat,leaving_time:this.leaving_time,payment_scheme:this.payment_scheme},{headers:o.a.getAuthHeader()}).then(function(t){}).catch(function(t){l.a.showMsg(t.response.data.msg,"negative")})},getSettings:function(){var t=this;navigator.geolocation.getCurrentPosition(function(e){t.location.lng=e.coords.longitude,t.location.lat=e.coords.latitude}),a.a.get("http://localhost:4000/api/users/current",{headers:o.a.getAuthHeader()}).then(function(e){t.user=e.data,t.payment_scheme=e.data.payment_scheme}).catch(function(t){console.log("user error: "+t)})}},created:function(){s.a.$emit("page","Start")},mounted:function(){var t=this;if(this.getSettings(),l.a.getLeavingTime()?this.leaving_time=l.a.getLeavingTime():this.leaving_time=new Date(this.$moment().add(1,"hours")),o.a.socket){var e=o.a.getChannel("user:");e.join().receive("ok",function(t){console.log("Joined successfully",t)}).receive("error",function(t){console.log("Unable to join",t)}),e.on("requests",function(e){t.message=e,t.visible=!0}),e.on("notifications",function(e){t.visible=!1,"Parking Started"==e.msg?(l.a.showMsg(e.msg,"positive"),e.invoice_id?t.$router.push({path:"/"+e.invoice_id+"/payments",query:{redirect:"/status"}}):t.$router.push({path:"/status"})):l.a.showMsg(e.msg,"negative")})}}}},349:function(t,e,i){"use strict";var n=function(){var t=this,e=t.$createElement,i=t._self._c||e;return i("div",[t.visible?i("div",{staticClass:"layout-padding"},[i("allocation-notification",{attrs:{message:t.message}})],1):t._e(),t._v(" "),t.visible?t._e():i("div",{staticClass:"layout-padding"},[i("map-display",{attrs:{location:t.location,destination:t.destination},on:{"update:location":function(e){t.location=e},"update:destination":function(e){t.destination=e}}}),t._v(" "),i("q-field",{attrs:{icon:"attach money",helper:"Choose a Payment Scheme",label:"Payment Scheme"}},[i("q-option-group",{attrs:{type:"radio",color:"indigo",options:[{label:"HOURLY",value:"HOURLY"},{label:"REAL TIME",value:"REAL_TIME"}]},model:{value:t.payment_scheme,callback:function(e){t.payment_scheme=e},expression:"payment_scheme"}})],1),t._v(" "),i("q-item",[i("q-item-side",{attrs:{icon:"access_time"}}),t._v(" "),i("q-item-main",[i("q-datetime",{staticClass:"no-margin",attrs:{format24h:"","float-label":"Leaving Time",type:"time"},model:{value:t.leaving_time,callback:function(e){t.leaving_time=e},expression:"leaving_time"}})],1)],1),t._v(" "),i("q-btn",{staticClass:"full-width",attrs:{icon:"input",color:"indigo 4"},on:{click:function(e){t.startParking()}}},[t._v("\n      Start Parking\n    ")])],1)])},a=[],o={render:n,staticRenderFns:a};e.a=o}});