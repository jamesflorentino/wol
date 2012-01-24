/*
* Ease by Grant Skinner. Oct 27, 2011
* Visit http://easeljs.com/ for documentation, updates and examples.
*
* Equations derived from work by Robert Penner.
*
* Copyright (c) 2011 Grant Skinner
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
(function(a){var b=function(){throw"Ease cannot be instantiated."};b.linear=function(a){return a},b.none=b.linear,b.get=function(a){return a<-1&&(a=-1),a>1&&(a=1),function(b){return a==0?b:a<0?b*(b*-a+1+a):b*((2-b)*a+(1-a))}},b.getPowIn=function(a){return function(b){return Math.pow(b,a)}},b.getPowOut=function(a){return function(b){return 1-Math.pow(1-b,a)}},b.getPowInOut=function(a){return function(b){return(b*=2)<1?.5*Math.pow(b,a):1-.5*Math.abs(Math.pow(2-b,a))}},b.quadIn=b.getPowIn(2),b.quadOut=b.getPowOut(2),b.quadInOut=b.getPowInOut(2),b.cubicIn=b.getPowIn(3),b.cubicOut=b.getPowOut(3),b.cubicInOut=b.getPowInOut(3),b.quartIn=b.getPowIn(4),b.quartOut=b.getPowOut(4),b.quartInOut=b.getPowInOut(4),b.quintIn=b.getPowIn(5),b.quintOut=b.getPowOut(5),b.quintInOut=b.getPowInOut(5),b.sineIn=function(a){return 1-Math.cos(a*Math.PI/2)},b.sineOut=function(a){return Math.sin(a*Math.PI/2)},b.sineInOut=function(a){return-0.5*(Math.cos(Math.PI*a)-1)},b.getBackIn=function(a){return function(b){return b*b*((a+1)*b-a)}},b.backIn=b.getBackIn(1.7),b.getBackOut=function(a){return function(b){return--b*b*((a+1)*b+a)+1}},b.backOut=b.getBackOut(1.7),b.getBackInOut=function(a){return a*=1.525,function(b){return(b*=2)<1?.5*b*b*((a+1)*b-a):.5*((b-=2)*b*((a+1)*b+a)+2)}},b.backInOut=b.getBackInOut(1.7),b.circIn=function(a){return-(Math.sqrt(1-a*a)-1)},b.circOut=function(a){return Math.sqrt(1- --a*a)},b.circInOut=function(a){return(a*=2)<1?-0.5*(Math.sqrt(1-a*a)-1):.5*(Math.sqrt(1-(a-=2)*a)+1)},b.bounceIn=function(a){return 1-b.bounceOut(1-a)},b.bounceOut=function(a){return a<1/2.75?7.5625*a*a:a<2/2.75?7.5625*(a-=1.5/2.75)*a+.75:a<2.5/2.75?7.5625*(a-=2.25/2.75)*a+.9375:7.5625*(a-=2.625/2.75)*a+.984375},b.bounceInOut=function(a){return a<.5?b.bounceIn(a*2)*.5:b.bounceOut(a*2-1)*.5+.5},b.getElasticIn=function(a,b){var c=Math.PI*2;return function(d){if(d==0||d==1)return d;var e=b/c*Math.asin(1/a);return-(a*Math.pow(2,10*(d-=1))*Math.sin((d-e)*c/b))}},b.elasticIn=b.getElasticIn(1,.3),b.getElasticOut=function(a,b){var c=Math.PI*2;return function(d){if(d==0||d==1)return d;var e=b/c*Math.asin(1/a);return a*Math.pow(2,-10*d)*Math.sin((d-e)*c/b)+1}},b.elasticOut=b.getElasticOut(1,.3),b.getElasticInOut=function(a,b){var c=Math.PI*2;return function(d){var e=b/c*Math.asin(1/a);return(d*=2)<1?-0.5*a*Math.pow(2,10*(d-=1))*Math.sin((d-e)*c/b):a*Math.pow(2,-10*(d-=1))*Math.sin((d-e)*c/b)*.5+1}},b.elasticInOut=b.getElasticInOut(1,.3*1.5),a.Ease=b})(window)