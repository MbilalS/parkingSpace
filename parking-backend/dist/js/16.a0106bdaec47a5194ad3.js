webpackJsonp([16],{260:function(t,e,i){"use strict";function r(t){i(310)}Object.defineProperty(e,"__esModule",{value:!0});var a=i(282),s=i(312),n=i(131),o=r,c=n(a.a,s.a,!1,o,null,null);e.default=c.exports},282:function(t,e,i){"use strict";var r=i(132),a=i(134),s=i(2);e.a={components:{QField:s.l,QInput:s.n,QBtn:s.b,QIcon:s.m},data:function(){return{username:"",password:"",redirect:"/"}},methods:{login:function(){r.a.login(this,{email:this.username,password:this.password},this.redirect),a.a.$emit("display",!0)},register:function(){this.$router.push({path:"/signup"})}},mounted:function(){a.a.$emit("display",!1),this.$route.query.redirect&&(this.redirect=this.$route.query.redirect)}}},310:function(t,e,i){var r=i(311);"string"==typeof r&&(r=[[t.i,r,""]]),r.locals&&(t.exports=r.locals);i(255)("199c0249",r,!0)},311:function(t,e,i){e=t.exports=i(254)(void 0),e.push([t.i,"a{padding-top:15px;color:#7986cb}a:hover{color:#a57fc0}.background-login{background:#3f51b5;border-radius:25px;padding:20px;display:block;margin:auto;width:90%}",""])},312:function(t,e,i){"use strict";var r=function(){var t=this,e=t.$createElement,i=t._self._c||e;return i("div",{staticClass:"layout-padding"},[t._m(0),t._v(" "),i("div",{staticClass:"background-login"},[i("q-field",{staticStyle:{"margin-top":"60px"},attrs:{icon:"account box",helper:"Email",count:30}},[i("q-input",{attrs:{type:"email",dark:"",color:"white"},model:{value:t.username,callback:function(e){t.username=e},expression:"username"}})],1),t._v(" "),i("q-field",{attrs:{icon:"lock",helper:"Password",count:15}},[i("q-input",{attrs:{type:"password",dark:"",color:"white"},model:{value:t.password,callback:function(e){t.password=e},expression:"password"}})],1),t._v(" "),i("div",[i("q-btn",{staticStyle:{color:"#fff","border-radius":"10px",width:"100%","margin-top":"30px"},attrs:{outline:"",icon:"input",color:"white"},on:{click:t.login}},[t._v("Login")])],1)],1),t._v(" "),i("div",{staticClass:"row justify-center"},[i("a",{on:{click:t.register}},[t._v("Register here")])])])},a=[function(){var t=this,e=t.$createElement,i=t._self._c||e;return i("div",{staticClass:"row justify-center animated bounceIn",staticStyle:{"margin-top":"80px"}},[i("img",{staticStyle:{"margin-bottom":"-60px"},attrs:{src:"statics/login.png",alt:"change password",width:"150",height:"120"}}),t._v(" "),i("br")])}],s={render:r,staticRenderFns:a};e.a=s}});