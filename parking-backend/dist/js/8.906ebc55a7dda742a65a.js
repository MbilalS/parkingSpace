webpackJsonp([8],{268:function(t,i,e){"use strict";function a(t){e(334)}Object.defineProperty(i,"__esModule",{value:!0});var o=e(290),s=e(336),r=e(131),n=a,d=r(o.a,s.a,!1,n,null,null);i.default=d.exports},290:function(t,i,e){"use strict";var a=e(2);i.a={name:"screen1",components:{QLayout:a.s},created:function(){},mounted:function(){setTimeout(function(){document.getElementById("title").className="visibility-back centertext animatedfive zoomIn",document.getElementById("footer-body-content").className="visibility-back centertext animatedfive zoomIn",document.getElementById("leftarrow").className="visibility-back  animated fadeIn",document.getElementById("rightarrow").className="visibility-back  animated fadeIn",document.getElementById("dots").className="visibility-back  animated fadeIn"},1e3)},methods:{dummy:function(){document.location.href="http://localhost:8080/#/screentwo"}}}},334:function(t,i,e){var a=e(335);"string"==typeof a&&(a=[[t.i,a,""]]),a.locals&&(t.exports=a.locals);e(255)("5b508847",a,!0)},335:function(t,i,e){i=t.exports=e(254)(void 0),i.push([t.i,".container{width:100%;height:100vh}.body{width:100%;height:70%;background-color:#fff}.foot-wraper{width:100%;height:30%;background-color:#b82d2a}.foot-header{height:30%}.foot-body,.foot-header{width:100%;display:-webkit-box;display:-ms-flexbox;display:flex}.foot-body{height:50%}.foot-footer{width:100%;height:20%;background-color:#8f2320;display:-webkit-box;display:-ms-flexbox;display:flex}.search-parking{width:100%;height:100%;position:relative}.logo-two{width:200px;height:200px;margin:0;position:absolute;top:50%;left:50%;-webkit-transform:translate(-50%,-50%);transform:translate(-50%,-50%)}.centertext{display:block;margin-left:auto;margin-right:auto}#circle{background:#fff}#circle,#circle-deactive{width:10px;height:10px;border-radius:5px}#circle-deactive{background:#b82d2a}#inner{display:table;margin:0 auto}.center-me{margin:auto;display:inline-block;border:1px solid blue}.visibility-gone{visibility:hidden}.visibility-back{visibility:visible}",""])},336:function(t,i,e){"use strict";var a=function(){var t=this,i=t.$createElement,e=t._self._c||i;return e("q-layout",[e("div",{staticClass:"container"},[e("div",{staticClass:"body"},[e("div",{staticClass:"search-parking animated bounceIn"},[e("img",{staticClass:"logo-two",attrs:{src:"statics/parking.png"}})])]),t._v(" "),e("div",{staticClass:"foot-wraper animated slideInUp",attrs:{id:"animationtow"}},[e("div",{staticClass:"foot-header"},[e("div",{staticClass:"visibility-gone",staticStyle:{"text-align":"center"},attrs:{id:"title"}},[e("div",[e("h5",[e("strong",[e("font",{attrs:{color:"white"}},[t._v("Find your parking ")])],1)])])])]),t._v(" "),e("div",{staticClass:"foot-body"},[e("div",{staticClass:"visibility-gone",staticStyle:{"text-align":"center","padding-top":"25px"},attrs:{id:"footer-body-content"}},[e("div",[e("font",{attrs:{color:"white"}},[t._v(" Some discription about this sceen "),e("br"),t._v(" and some more discription")])],1)])]),t._v(" "),e("div",{staticClass:"foot-footer"},[e("div",{staticStyle:{width:"20%",float:"left"}},[e("img",{staticClass:"visibility-gone",staticStyle:{transform:"rotate(180deg)"},attrs:{src:"statics/arrow.jpg",width:"42",height:"42",id:"leftarrow"}})]),t._v(" "),e("div",{staticClass:"visibility-gone",staticStyle:{width:"60%",float:"right"},attrs:{id:"dots"}},[e("div",{staticStyle:{"padding-top":"10px"},attrs:{id:"inner"}},[e("div",{staticStyle:{float:"right",margin:"5px"},attrs:{id:"inner"}},[e("div",{attrs:{id:"circle-deactive"}})]),t._v(" "),e("div",{staticStyle:{float:"right",margin:"5px"},attrs:{id:"inner"}},[e("div",{attrs:{id:"circle-deactive"}})]),t._v(" "),e("div",{staticStyle:{float:"right",margin:"5px"},attrs:{id:"inner"}},[e("div",{attrs:{id:"circle-deactive"}})]),t._v(" "),e("div",{staticStyle:{float:"right",margin:"5px"},attrs:{id:"inner"}},[e("div",{attrs:{id:"circle-deactive"}})]),t._v(" "),e("div",{staticStyle:{float:"right",margin:"5px"},attrs:{id:"inner"}},[e("div",{attrs:{id:"circle"}})])])]),t._v(" "),e("div",{staticClass:"visibility-gone",staticStyle:{width:"20%",float:"right"},attrs:{id:"rightarrow"}},[e("img",{attrs:{src:"statics/arrow.jpg",width:"42",height:"42",align:"right"},on:{click:t.dummy}})])])])])])},o=[],s={render:a,staticRenderFns:o};i.a=s}});