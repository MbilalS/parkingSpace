webpackJsonp([1],{271:function(e,t,i){"use strict";function n(e){i(343)}Object.defineProperty(t,"__esModule",{value:!0});var a=i(293),o=i(345),s=i(131),r=n,c=s(a.a,o.a,!1,r,null,null);t.default=c.exports},277:function(e,t,i){"use strict";var n=i(2);t.a={leaving_time:null,showMsg:function(e,t){n.B.create[t]({html:e,position:top,timeout:1e4})},getLeavingTime:function(){return this.leaving_time},setLeavingTime:function(e){this.leaving_time=e},dialog:{label:"Parking Time",icon:"warning",handler:function(e){n.a.create({title:"Time about to end!",message:e})}}}},293:function(e,t,i){"use strict";var n=i(133),a=i.n(n),o=i(132),s=i(277),r=i(2);t.a={components:{QInput:r.n,QBtn:r.b,QIcon:r.m,QRadio:r.w,QChip:r.h,QField:r.l,QList:r.t,QItem:r.o,QItemSide:r.q,QItemMain:r.p,QItemTile:r.r,QOptionGroup:r.v},data:function(){return{user:{}}},methods:{changePassword:function(){this.$router.push({path:"/"+this.user.id+"/change-password"})},logout:function(){o.a.logout(this,{headers:o.a.getAuthHeader()}),s.a.showMsg("Successfully Logged out!","positive")},update:function(){var e=this;a.a.patch("http://localhost:4000/api/users/"+this.user.id,this.user,{headers:o.a.getAuthHeader()}).then(function(t){e.getSettings()}).catch(function(e){s.a.showMsg("Something went wrong","negative")})},getSettings:function(){var e=this;a.a.get("http://localhost:4000/api/users/current",{headers:o.a.getAuthHeader()}).then(function(t){e.user=t.data}).catch(function(e){s.a.showMsg("Something went wrong","negative")})}},mounted:function(){this.getSettings()}}},343:function(e,t,i){var n=i(344);"string"==typeof n&&(n=[[e.i,n,""]]),n.locals&&(e.exports=n.locals);i(255)("501c9c58",n,!0)},344:function(e,t,i){t=e.exports=i(254)(void 0),t.push([e.i,".background{background:#3f51b5;border-radius:25px}.textfeild{margin:10px 20px}",""])},345:function(e,t,i){"use strict";var n=function(){var e=this,t=e.$createElement,i=e._self._c||t;return i("div",{staticClass:"layout-padding row justify-center"},[e._m(0),e._v(" "),i("div",{staticClass:"animated fadeIn",staticStyle:{width:"500px","max-width":"100vw"}},[i("q-item",[i("div",[i("q-btn",{staticStyle:{"border-radius":"10px",width:"90%","margin-top":"10px"},attrs:{outline:"",icon:"vpn key",color:"indigo"},on:{click:e.changePassword}},[e._v("Change password")])],1),e._v(" "),i("div",[i("q-btn",{staticStyle:{"border-radius":"10px","margin-top":"10px"},attrs:{outline:"",icon:"power settings new",color:"red"},on:{click:function(t){e.logout()}}},[e._v("Log out")])],1)]),e._v(" "),i("q-input",{staticStyle:{"border-radius":"10px",padding:"10px",background:"#3f51b5",margin:"15px"},attrs:{dark:"",id:"user_name","stack-label":"Name",color:"white"},model:{value:e.user.name,callback:function(t){e.$set(e.user,"name",t)},expression:"user.name"}}),e._v(" "),i("q-input",{staticStyle:{"border-radius":"10px",padding:"10px",background:"#3f51b5",margin:"15px"},attrs:{dark:"",id:"email","stack-label":"Email",color:"white"},model:{value:e.user.email,callback:function(t){e.$set(e.user,"email",t)},expression:"user.email"}}),e._v(" "),i("q-field",{attrs:{icon:"attach money",helper:"Pick a Payment Scheme",label:"Payment Scheme"}},[i("q-option-group",{attrs:{type:"radio",color:"indigo 4",options:[{label:"HOURLY",value:"HOURLY"},{label:"REAL TIME",value:"REAL_TIME"}]},on:{change:e.update},model:{value:e.user.payment_scheme,callback:function(t){e.$set(e.user,"payment_scheme",t)},expression:"user.payment_scheme"}})],1),e._v(" "),"REAL_TIME"==e.user.payment_scheme?i("q-field",{attrs:{icon:"vibration",helper:"When do you want to get your invoice?",label:"Invoiced"}},[i("q-option-group",{attrs:{type:"radio",color:"indigo 4",options:[{label:"IMMEDIATELY",value:"IMMEDIATELY"},{label:"MONTHLY",value:"MONTHLY"}]},on:{change:e.update},model:{value:e.user.invoiced,callback:function(t){e.$set(e.user,"invoiced",t)},expression:"user.invoiced"}})],1):e._e()],1)])},a=[function(){var e=this,t=e.$createElement,i=e._self._c||t;return i("div",{staticClass:"row justify-center animated rotateIn",staticStyle:{margin:"20px"}},[i("img",{attrs:{src:"statics/settings.png",alt:"Settings",width:"180",height:"115"}}),e._v(" "),i("br")])}],o={render:n,staticRenderFns:a};t.a=o}});