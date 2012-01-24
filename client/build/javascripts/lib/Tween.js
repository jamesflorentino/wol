/*
* Tween by Grant Skinner. Mar 7, 2011
* Visit http://easeljs.com/ for documentation, updates and examples.
*
*
* Copyright (c) 2010 Grant Skinner
* 
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use,
* copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the
* Software is furnished to do so, subject to the following
* conditions:
* 
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* OTHER DEALINGS IN THE SOFTWARE.
*/
/**
* The TweenJS Javascript library provides a simple but powerful tweening interface. It allows you to chain tweens and
 * actions together to create complex sequences. For example:<br/>
 * Tween.get(target).wait(500).to({alpha:0,visible:false},1000).call(onComplete);<br/>
 * This tween will wait 0.5s, tween the target's alpha property to 0 over 1s, set it's visible to false, then call the onComplete function.
* @module TweenJS
**/
//TODO: when CSS is true, use the style property for all prop targets.
(function(a){Tween=function(a,b){this.initialize(a,b)};var b=Tween.prototype;Tween.NONE=0,Tween.LOOP=1,Tween.REVERSE=2,Tween._tweens=[],Tween.cssSuffixMap={top:"px",left:"px",bottom:"px",right:"px",width:"px",height:"px",opacity:""},Tween.get=function(a,b){return new Tween(a,b)},Tween.tick=function(a,b){var c=Tween._tweens;for(var d=c.length-1;d>=0;d--){var e=c[d];if(b&&!e.ignoreGlobalPause)continue;e.tick(e._useTicks?1:a)}},Ticker&&Ticker.addListener(Tween,!1),Tween.removeTweens=function(a){if(!a.tweenjs_count)return;var b=Tween._tweens;for(var c=b.length-1;c>=0;c--)b[c]._target==a&&b.splice(c,1);a.tweenjs_count=0},Tween._register=function(a,b){var c=a._target;if(b)c&&(c.tweenjs_count=c.tweenjs_count?c.tweenjs_count+1:1),Tween._tweens.push(a);else{c&&c.tweenjs_count--;var d=Tween._tweens.indexOf(a);d!=-1&&Tween._tweens.splice(d,1)}},b.ignoreGlobalPause=!1,b.loop=!1,b.cssSuffixMap=null,b.duration=0,b._paused=!1,b._curQueueProps=null,b._initQueueProps=null,b._steps=null,b._actions=null,b._prevPosition=0,b._prevPos=-1,b._prevIndex=-1,b._target=null,b._css=!1,b._useTicks=!1,b.initialize=function(a,b){this._target=a,b&&(this._useTicks=b.useTicks,this._css=b.css,this.ignoreGlobalPause=b.ignoreGlobalPause,this.loop=b.loop,b.override&&Tween.removeTweens(a)),this._curQueueProps={},this._initQueueProps={},this._steps=[],this._actions=[],this._catalog=[],Tween._register(this,!0)},b.wait=function(a){if(a==null||a<=0)return this;var b=this._cloneProps(this._curQueueProps);return this._addStep({d:a,p0:b,e:this._linearEase,p1:b})},b.to=function(a,b,c){if(isNaN(b)||b<0)b=0;return this._addStep({d:b||0,p0:this._cloneProps(this._curQueueProps),e:c,p1:this._cloneProps(this._appendQueueProps(a))})},b.call=function(a,b,c){return this._addAction({f:a,p:b?b:[this],o:c?c:this._target})},b.set=function(a,b){return this._addAction({f:this._set,o:this,p:[a,b?b:this._target]})},b.play=function(a){return this.call(a.setPaused,[!1],a)},b.pause=function(a){return a||(a=this),this.call(a.setPaused,[!0],a)},b.setPosition=function(a,b){b==null&&(b=1);var c=a,d=!1;c>=this.duration&&(this.loop?c%=this.duration:(c=this.duration,d=!0));if(c==this._prevPos)return d;if(c!=this._prevPos)if(d)this._updateTargetProps(null,1);else if(this._steps.length>0){for(var e=0,f=this._steps.length;e<f;e++)if(this._steps[e].t>c)break;var g=this._steps[e-1];this._updateTargetProps(g,(c-g.t)/g.d)}var h=this._prevPos;return this._prevPos=c,this._prevPosition=a,b!=0&&this._actions.length>0&&(this._useTicks?this._runActions(c,c):b==1&&c<h?(h!=this.duration&&this._runActions(h,this.duration),this._runActions(0,c,!0)):this._runActions(h,c)),d&&this.setPaused(!0),d},b.tick=function(a){if(this._paused)return;this.setPosition(this._prevPosition+a)},b.setPaused=function(a){if(this._paused==!!a)return;this._paused=!!a,Tween._register(this,!a)},b.w=b.wait,b.t=b.to,b.c=b.call,b.s=b.set,b.toString=function(){return"[Tween]"},b.clone=function(){throw"Tween can not be cloned."},b._updateTargetProps=function(a,b){if(this._css)var c=this.cssSuffixMap||Tween.cssSuffixMap;var d,e,f,g;!a&&b==1?d=e=this._curQueueProps:(a.e&&(b=a.e(b,0,1,1)),d=a.p0,e=a.p1);for(n in this._initQueueProps)(f=d[n])==null&&(d[n]=f=this._initQueueProps[n]),(g=e[n])==null&&(e[n]=g=f),f==g||b==0||b==1||typeof f!="number"?b==1&&(f=g):f+=(g-f)*b,this._target[n]=c&&c[n]?f+c[n]:f},b._runActions=function(a,b,c){var d=a,e=b,f=-1,g=this._actions.length,h=1;a>b&&(d=b,e=a,f=g,g=h=-1);while((f+=h)!=g){var i=this._actions[f],j=i.t;(j==e||j>d&&j<e||c&&j==a)&&i.f.apply(i.o,i.p)}},b._appendQueueProps=function(a){if(this._css)var b=this.cssSuffixMap||Tween.cssSuffixMap;var c,d;for(var e in a){if(this._initQueueProps[e]==null)if(b&&(c=b[e])!=null){var f=this._target[e],g=f.length-c.length;if((d=f.substr(g))!=c)throw"TweenJS Error: Suffixes do not match. ("+c+":"+d+")";this._initQueueProps[e]=parseInt(f.substr(0,g))}else this._initQueueProps[e]=this._target[e];this._curQueueProps[e]=a[e]}return this._curQueueProps},b._cloneProps=function(a){var b={};for(var c in a)b[c]=a[c];return b},b._addStep=function(a){return a.d>0&&(this._steps.push(a),a.t=this.duration,this.duration+=a.d),this},b._addAction=function(a){return a.t=this.duration,this._actions.push(a),this},b._set=function(a,b){for(var c in a)b[c]=a[c]},a.Tween=Tween})(window)