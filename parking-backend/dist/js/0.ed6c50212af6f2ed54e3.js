webpackJsonp([0],{275:function(t,e,a){"use strict";function i(t){a(351)}Object.defineProperty(e,"__esModule",{value:!0});var n=a(297),s=a(353),o=a(131),r=i,c=o(n.a,s.a,!1,r,null,null);e.default=c.exports},277:function(t,e,a){"use strict";var i=a(2);e.a={leaving_time:null,showMsg:function(t,e){i.B.create[e]({html:t,position:top,timeout:1e4})},getLeavingTime:function(){return this.leaving_time},setLeavingTime:function(t){this.leaving_time=t},dialog:{label:"Parking Time",icon:"warning",handler:function(t){i.a.create({title:"Time about to end!",message:t})}}}},297:function(t,e,a){"use strict";var i=a(133),n=a.n(i),s=(a(132),a(277)),o=a(134),r=a(2);e.a={components:{QInput:r.n,QDatetime:r.k,QBtn:r.b,QItem:r.o,QItemSide:r.q,QItemMain:r.p,QIcon:r.m,QField:r.l},data:function(){return{user:{}}},methods:{submit:function(){var t=this;n.a.post("http://localhost:4000/api/users/",this.user).then(function(e){s.a.showMsg(e.data.msg,"positive"),t.$router.push({path:"/login"})}).catch(function(t){s.a.showMsg("Something went wrong","negative")})},login:function(){this.$router.push({path:"/login"})}},mounted:function(){o.a.$emit("display",!1)}}},351:function(t,e,a){var i=a(352);"string"==typeof i&&(i=[[t.i,i,""]]),i.locals&&(t.exports=i.locals);a(255)("321f3fca",i,!0)},352:function(t,e,a){e=t.exports=a(254)(void 0),e.push([t.i,"a{padding-top:15px;color:#7986cb}a:hover{color:#a57fc0}.icon-color{color:#3f51b5}.background{background:#3f51b5;border-radius:25px}.textfeild{margin:10px 20px}",""])},353:function(t,e,a){"use strict";var i=function(){var t=this,e=t.$createElement,a=t._self._c||e;return a("div",{staticClass:"layout-padding animated pulse"},[t._m(0),t._v(" "),a("div",{staticClass:"background",staticStyle:{padding:"25px",margin:"0px 10px 10px"}},[a("q-input",{staticStyle:{"border-radius":"10px","margin-top":"60px",padding:"10px",background:"#fff"},attrs:{id:"name","stack-label":"Name",color:"white"},model:{value:t.user.name,callback:function(e){t.$set(t.user,"name",e)},expression:"user.name"}}),t._v(" "),a("q-input",{staticStyle:{"border-radius":"10px",padding:"10px",background:"#fff"},attrs:{id:"name","stack-label":"Email",color:"white"},model:{value:t.user.email,callback:function(e){t.$set(t.user,"email",e)},expression:"user.email"}}),t._v(" "),a("q-input",{staticStyle:{"border-radius":"10px",padding:"10px",background:"#fff"},attrs:{id:"name","stack-label":"Password",color:"white"},model:{value:t.user.password,callback:function(e){t.$set(t.user,"password",e)},expression:"user.password"}}),t._v(" "),a("q-input",{staticStyle:{"border-radius":"10px",padding:"10px",background:"#fff"},attrs:{id:"name","stack-label":"Conform Password",color:"white"},model:{value:t.user.password_confirmation,callback:function(e){t.$set(t.user,"password_confirmation",e)},expression:"user.password_confirmation"}}),t._v(" "),a("div",[a("q-btn",{staticStyle:{color:"#fff","border-radius":"10px",width:"100%","margin-top":"10px"},attrs:{outline:"",icon:"input",color:"white"},on:{click:t.submit}},[t._v("Submit")])],1)],1),t._v(" "),a("div",{staticClass:"row justify-center"},[a("a",{on:{click:t.login}},[t._v("Already have an account? Login here")])])])},n=[function(){var t=this,e=t.$createElement,a=t._self._c||e;return a("div",{staticClass:"row justify-center",staticStyle:{width:"100%","margin-bottom":"-65px","margin-top":"25px"}},[a("div",{staticClass:"justify-center"},[a("img",{attrs:{src:"statics/signup.png",alt:"change password",width:"150",height:"120"}}),t._v(" "),a("br")])])}],s={render:i,staticRenderFns:n};e.a=s}});