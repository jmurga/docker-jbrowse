define(["dojo/_base/declare","dojo/_base/array","dijit/focus","JBrowse/View/Dialog/WithActionBar","dojo/on","dijit/form/Button"],function(l,i,g,k,h,j){return l(k,{refocus:false,autofocus:false,_fillActionBar:function(a){},show:function(){this.inherited(arguments);var a=this;this._extraEvents=[];var b=((dijit||{})._underlay||{}).domNode;if(b){this._extraEvents.push(h(b,"click",dojo.hitch(this,"hideIfVisible")))}this._extraEvents.push(h(document.body,"keydown",function(c){if([dojo.keys.ESCAPE,dojo.keys.ENTER].indexOf(c.keyCode)>=0){a.hideIfVisible()}}));g.focus(this.closeButtonNode)},hideIfVisible:function(){if(this.get("open")){this.hide()}},hide:function(){this.inherited(arguments);i.forEach(this._extraEvents,function(a){a.remove()})}})});