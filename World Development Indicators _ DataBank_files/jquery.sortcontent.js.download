/**
 *jQuery Plugin SortContent
 *
 * https://github.com/abdennour/jquery.sortContent
 * @author Abdennour TOUMI<abdennour.toumi@estifeda.com>
 * @requires JQuery
 * @param options {Object} override default values
 * @constructor
 */
/*!
 * jQuery Plugin SortContent
 * Copyright (c) 2013-2014 Estifèda <abdennour.toumi@estifeda.com>
 * The MIT License
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
 
 (function($) {
   var methdSorContent={
                                             hakikaAsl:function(elAsl){
                                             //strategy,asc,helper,helperxp,target,format,weight,update
                                             return elAsl;
                                             },
			ctyy:function(e,args){
				return args.target(e).parent();
			},updateNiheya:function($th,arryB3dTertib,args){
				/*methdSorContent.realSelected($th).each(function(i,e){
					 args['update']($(e),arryB3dTertib[i].scld,arryB3dTertib[i].wcumul);
				});*/
				var e={};
				var eprv={};
			    for(var i=0;i<arryB3dTertib.length;i++){
			    	e.ui=arryB3dTertib[i].e;
			    	e.scale=arryB3dTertib[i].scld;
			    	e.weightcumul=arryB3dTertib[i].wcumul;
			    	e.weight=arryB3dTertib[i].w;
			    	if(i==0){
			    		args['update'](e);
			    	}else{
			    		eprv.ui=arryB3dTertib[i-1].e;
				    	eprv.scale=arryB3dTertib[i-1].scld;
				    	eprv.weightcumul=arryB3dTertib[i-1].wcumul;
				    	eprv.weight=arryB3dTertib[i-1].w;
			    		args['update'](e,eprv);
			    	}
			    	
			    }
			    
			},
			targetFn:function($this){
				return methdSorContent.realSelected($this);
			},
			init:function(args,$th){
				
				if(args.helperxp && !args.helper){
					args.helper=args.helperxp.get;
					
				}
				
				var defau={
						strategy:'',
						asc:true,
						helper:function($child){
							return $child.html();
						},
						helperxp:{get:function($child){
							$child.html()
						},set:function(){
							//($child,html)
							//$child.html(html)
						}
							
						},
						target:function($child,index){
							return $child;
						},format:function(html){
							return html.toLowerCase().replace(/(<([^>]+)>)/ig, "");
						},weight:function(formatted,index){
							if(isFinite(formatted)){
								return parseInt(formatted);
							}else if(formatted!=="" || typeof formatted ==='string'){
								return formatted.charCodeAt(0);
							}else{
								return index;
							}
						},update:function(tge,scale,wgt){
							if(1===2){
								console.log($(tge),scale,wgt);
							}
							
						}
				};
				
				/**
				 * target : 'this','parent',
				 */
				
				
				return $.extend({}, methdSorContent.hakikaAsl(defau), args);;
			},sortHtmlArray:function(arry,$th,args,indexJedid,wgt,scl){
				if(!wgt){
					wgt='w';
				}
				if(!scl){
					scl='scld';
				}
				var wght=[];
				if(!indexJedid){
					indexJedid='tertib'
				}
				
				arry= arry.sort(function(a, b){
			    	 var nameA=args.format(a.html), nameB=args.format(b.html)
			    	// wght.push(args['weight'](nameB)-args['weight'](nameA))
			    	// console.log(args['weight'](nameB)-args['weight'](nameA));
			    	 if (nameA < nameB) //sort string ascending
			    	  return -1 
			    	 if (nameA > nameB)
			    	  return 1
			    	 return 0 //default return value (no sorting)
			    	});
				      arry[0][wgt]=0;
				      arry[0][wgt+'cumul']=0;
				      var cumlw=0;
	                   for(var i=0;i<arry.length;i++){
						arry[i][indexJedid]=i;
						if(i>0){
							arry[i][wgt]=args['weight'](args['format'](arry[i].html),i)-args['weight'](args['format'](arry[i-1].html),i)	
						   arry[i][wgt+'cumul']=cumlw+arry[i][wgt];
							cumlw=cumlw+arry[i][wgt+'cumul'];
						}
							
						
						
					     }
	                   arry[0][scl]=0;
	                   arry[arry.length-1][scl]=1;
	                   var wmx=arry[arry.length-1][wgt+'cumul'];
	                   for(var i=0;i<arry.length;i++){
							
							if(wmx!==0){
								arry[i][scl]=arry[i][wgt+'cumul']/wmx;
							}
                        }
	                
				
				return arry;
			},
			startegyswcht:function(stg){
				var switchwer='';
				if('|PER_PARENT|BY_PARENT|x|'.indexOf('|'+stg+'|')!==-1){
					switchwer='x';
				}
				return switchwer;
			},
			update:function(arryHTML,$this,args){
				var switchwer=methdSorContent.startegyswcht(args['strategy']);
				return methdSorContent['setHTML'+switchwer](arryHTML,$this,args);
			}
			,setHTML:function(arryHTML,jqparent,args){
				//console.log(arryHTML);
				methdSorContent.realSelected(jqparent).each(function(i,e){
					args['target']($(e),i).html(arryHTML[i].thtml);
					arryHTML[i].newjq=args['target']($(e),i).get(0);
					args['helperxp']['set']($(e),arryHTML[i].html)
			     });
				return arryHTML;
			},setHTMLx:function(arryHTML,$this,args){
				/*PER_PARENT*/
				var mx=$this.abdennourgp();
				var subarr=[];
				var j=0;
				for(var p=0;p<Object.keys(mx).length;p++){
					subarr=arryHTML.filter(function (el) {return el.ctx===mx[p]});
					subarr=methdSorContent.sortHtmlArray(subarr, $this, args, 'xtertib','xw','xsc');
					for(var k=0;k<methdSorContent.adedKeysInt(mx[p])+1;k++){
						args['target']($(mx[p][k]),subarr[parseInt(k)].tertib).html(subarr[parseInt(k)].thtml);
						args['helperxp']['set']($(mx[p][k]),subarr[parseInt(k)].html)
						arryHTML[j].newjq=args['target']($(mx[p][k]),subarr[parseInt(k)].tertib).get(0);	
						j++;
					}
				}
				return arryHTML;
			},getHtml:function(jqparent,args){
				var tmp=[];
				methdSorContent.realSelected(jqparent).each(function(i,e){
			    	 tmp.push({e:$(e),html:args.helper($(e)),thtml:args['target']($(e),i).html(),ctx:args['target']($(e),i).parent().get(0)});
			     });
				//console.log(tmp);
				return tmp;
			},realSelected:function(jq){
				if(jq.length<=1){
					return jq.children();
				}else{
					return jq;
				}
			},adedKeysInt:function(obj){
				 var kn=0;
                                                             while(obj[kn+'']){ 
                                                                             kn++;
                                                                }
                                                                return kn-1;
			}
	};
	$.fn.sortContent=function(args){
		var tmp;
		args=methdSorContent.init(args,$(this));
	     tmp=methdSorContent.sortHtmlArray(methdSorContent.getHtml($(this),args),$(this),args);
	     if(!args['asc']){
	    	 tmp.reverse();
	     }
	     
	     tmp=methdSorContent.update(tmp, $(this),args);
	     methdSorContent.updateNiheya($(this),tmp, args);
	     
	};
	/**
	 * @return matrix m[0]=>1st parent ;m[0][1] 2nd child in 1st prarent
	 */
	$.fn.abdennourgp=function(){
		var tmp={};
		var all=$(this);
		var inc=0;
		var allp=$(this).parent();
		 for(var i=0;i<allp.length;i++){ 
		       tmp[''+i]=allp.eq(i).get(0) ;
		          
		    }
		    
		     for(var i=0;i<allp.length;i++){ 
		    	 inc=0;
		       for(var j=0;j<all.length;j++){
		       
		          if(all.eq(j).parent().eq(0).get(0)===tmp[''+i]){
		                tmp[i+''][inc+'']=all.eq(j).get(0);
		                inc++;
		          }
		           
		       }

		    }
		    
		return tmp;
		};
 
 })(jQuery);
