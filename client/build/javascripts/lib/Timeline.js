/*
* Timeline by Grant Skinner. Mar 7, 2011
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
* The Tween Javascript library provides a retained graphics mode for canvas 
* including a full, hierarchical display list, a core interaction model, and 
* helper classes to make working with Canvas much easier.
* @module TweenJS
**/
(function(a){Timeline=function(a,b,c){this.initialize(a,b,c)};var b=Timeline.prototype;b.ignoreGlobalPause=!1,b.duration=0,b.loop=!1,b._paused=!0,b._tweens=null,b._labels=null,b._prevPosition=0,b._prevPos=0,b._useTicks=!1,b.initialize=function(a,b,c){this._tweens=[],a&&this.addTween.apply(this,a),this.setLabels(b),this.setPaused(!1),c&&(this._useTicks=c.useTicks,this.loop=c.loop,this.ignoreGlobalPause=c.ignoreGlobalPause)},b.addTween=function(a){var b=arguments.length;if(b>1){for(var c=0;c<b;c++)this.addTween(arguments[c]);return arguments[0]}return b==0?null:(this.removeTween(a),this._tweens.push(a),a.setPaused(!0),a._paused=!1,a.duration>this.duration&&(this.duration=a.duration),a)},b.removeTween=function(a){var b=arguments.length;if(b>1){var c=!0;for(var d=0;d<b;d++)c=c&&this.removeTween(arguments[d]);return c}if(b==0)return!1;var e=this._tweens.indexOf(a);return e!=-1?(this._tweens.splice(e,1),a.duration>=this.duration&&this.updateDuration(),!0):!1},b.addLabel=function(a,b){this._labels[a]=b},b.setLabels=function(a){this._labels=a?a:{}},b.gotoAndPlay=function(a){this.setPaused(!1),this._goto(a)},b.gotoAndStop=function(a){this.setPaused(!0),this._goto(a)},b.setPosition=function(a){var b=this.loop?a%this.duration:a,c=!this.loop&&a>=this.duration;this._prevPosition=a,this._prevPos=b;for(var d=0,e=this._tweens.length;d<e;d++){this._tweens[d].setPosition(b);if(b!=this._prevPos)return!1}return c&&this.setPaused(!0),c},b.setPaused=function(a){if(this._paused==!!a)return;this._paused=!!a,Tween._register(this,!a)},b.updateDuration=function(){this.duration=0;for(var a=0,b=this._tweens.length;a<b;a++)tween=this._tweens[a],tween.duration>this.duration&&(this.duration=tween.duration)},b.tick=function(a){this.setPosition(this._prevPosition+a)},b.toString=function(){return"[Timeline]"},b.clone=function(){throw"Timeline can not be cloned."},b._goto=function(a){var b=parseFloat(a);isNaN(b)&&(b=this._labels[a]),b!=null&&this.setPosition(b)},a.Timeline=Timeline})(window)