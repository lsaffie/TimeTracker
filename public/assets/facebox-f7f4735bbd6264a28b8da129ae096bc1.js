/*
 * Facebox (for jQuery)
 * version: 1.2 (05/05/2008)
 * @requires jQuery v1.2 or later
 *
 * Examples at http://famspam.com/facebox/
 *
 * Licensed under the MIT:
 *   http://www.opensource.org/licenses/mit-license.php
 *
 * Copyright 2007, 2008 Chris Wanstrath [ chris@ozmm.org ]
 *
 * Usage:
 *
 *  jQuery(document).ready(function() {
 *    jQuery('a[rel*=facebox]').facebox()
 *  })
 *
 *  <a href="#terms" rel="facebox">Terms</a>
 *    Loads the #terms div in the box
 *
 *  <a href="terms.html" rel="facebox">Terms</a>
 *    Loads the terms.html page in the box
 *
 *  <a href="terms.png" rel="facebox">Terms</a>
 *    Loads the terms.png image in the box
 *
 *
 *  You can also use it programmatically:
 *
 *    jQuery.facebox('some html')
 *    jQuery.facebox('some html', 'my-groovy-style')
 *
 *  The above will open a facebox with "some html" as the content.
 *
 *    jQuery.facebox(function($) {
 *      $.get('blah.html', function(data) { $.facebox(data) })
 *    })
 *
 *  The above will show a loading screen before the passed function is called,
 *  allowing for a better ajaxy experience.
 *
 *  The facebox function can also display an ajax page, an image, or the contents of a div:
 *
 *    jQuery.facebox({ ajax: 'remote.html' })
 *    jQuery.facebox({ ajax: 'remote.html' }, 'my-groovy-style')
 *    jQuery.facebox({ image: 'stairs.jpg' })
 *    jQuery.facebox({ image: 'stairs.jpg' }, 'my-groovy-style')
 *    jQuery.facebox({ div: '#box' })
 *    jQuery.facebox({ div: '#box' }, 'my-groovy-style')
 *
 *  Want to close the facebox?  Trigger the 'close.facebox' document event:
 *
 *    jQuery(document).trigger('close.facebox')
 *
 *  Facebox also has a bunch of other hooks:
 *
 *    loading.facebox
 *    beforeReveal.facebox
 *    reveal.facebox (aliased as 'afterReveal.facebox')
 *    init.facebox
 *    afterClose.facebox
 *
 *  Simply bind a function to any of these hooks:
 *
 *   $(document).bind('reveal.facebox', function() { ...stuff to do after the facebox and contents are revealed... })
 *
 */
(function(e){function t(t){if(e.facebox.settings.inited)return!0;e.facebox.settings.inited=!0,e(document).trigger("init.facebox"),i();var n=e.facebox.settings.imageTypes.join("|");e.facebox.settings.imageTypesRegexp=new RegExp(".("+n+")$","i"),t&&e.extend(e.facebox.settings,t),e("body").append(e.facebox.settings.faceboxHtml);var r=[new Image,new Image];r[0].src=e.facebox.settings.closeImage,r[1].src=e.facebox.settings.loadingImage,e("#facebox").find(".b:first, .bl").each(function(){r.push(new Image),r.slice(-1).src=e(this).css("background-image").replace(/url\((.+)\)/,"$1")}),e("#facebox .close").click(e.facebox.close),e("#facebox .close_image").attr("src",e.facebox.settings.closeImage)}function n(){var e,t;return self.pageYOffset?(t=self.pageYOffset,e=self.pageXOffset):document.documentElement&&document.documentElement.scrollTop?(t=document.documentElement.scrollTop,e=document.documentElement.scrollLeft):document.body&&(t=document.body.scrollTop,e=document.body.scrollLeft),new Array(e,t)}function r(){var e;return self.innerHeight?e=self.innerHeight:document.documentElement&&document.documentElement.clientHeight?e=document.documentElement.clientHeight:document.body&&(e=document.body.clientHeight),e}function i(){var t=e.facebox.settings;t.loadingImage=t.loading_image||t.loadingImage,t.closeImage=t.close_image||t.closeImage,t.imageTypes=t.image_types||t.imageTypes,t.faceboxHtml=t.facebox_html||t.faceboxHtml}function s(t,n){if(t.match(/#/)){var r=window.location.href.split("#")[0],i=t.replace(r,"");if(i=="#")return;e.facebox.reveal(e(i).html(),n)}else t.match(e.facebox.settings.imageTypesRegexp)?o(t,n):u(t,n)}function o(t,n){var r=new Image;r.onload=function(){e.facebox.reveal('<div class="image"><img src="'+r.src+'" /></div>',n)},r.src=t}function u(t,n){e.get(t,function(t){e.facebox.reveal(t,n)})}function a(){return e.facebox.settings.overlay==0||e.facebox.settings.opacity===null}function f(){if(a())return;return e("#facebox_overlay").length==0&&e("body").append('<div id="facebox_overlay" class="facebox_hide"></div>'),e("#facebox_overlay").hide().addClass("facebox_overlayBG").css("opacity",e.facebox.settings.opacity).click(function(){e(document).trigger("close.facebox")}).fadeIn(200),!1}function l(){if(a())return;return e("#facebox_overlay").fadeOut(200,function(){e("#facebox_overlay").removeClass("facebox_overlayBG"),e("#facebox_overlay").addClass("facebox_hide"),e("#facebox_overlay").remove()}),!1}e.facebox=function(t,n){e.facebox.loading(),t.ajax?u(t.ajax,n):t.image?o(t.image,n):t.div?s(t.div,n):e.isFunction(t)?t.call(e):e.facebox.reveal(t,n)},e.extend(e.facebox,{settings:{opacity:.2,overlay:!0,loadingImage:"/facebox/loading.gif",closeImage:"/facebox/closelabel.png",imageTypes:["png","jpg","jpeg","gif"],faceboxHtml:'    <div id="facebox" style="display:none;">       <div class="popup">         <div class="content">         </div>         <a href="#" class="close"><img src="/facebox/closelabel.png" title="close" class="close_image" /></a>       </div>     </div>'},loading:function(){t();if(e("#facebox .loading").length==1)return!0;f(),e("#facebox .content").empty(),e("#facebox .body").children().hide().end().append('<div class="loading"><img src="'+e.facebox.settings.loadingImage+'"/></div>'),e("#facebox").css({top:n()[1]+r()/10,left:e(window).width()/2-205}).show(),e(document).bind("keydown.facebox",function(t){return t.keyCode==27&&e.facebox.close(),!0}),e(document).trigger("loading.facebox")},reveal:function(t,n){e(document).trigger("beforeReveal.facebox"),n&&e("#facebox .content").addClass(n),e("#facebox .content").append(t),e("#facebox .loading").remove(),e("#facebox .body").children().fadeIn("normal"),e("#facebox").css("left",e(window).width()/2-e("#facebox .popup").width()/2),e(document).trigger("reveal.facebox").trigger("afterReveal.facebox")},close:function(){return e(document).trigger("close.facebox"),!1}}),e.fn.facebox=function(n){function r(){e.facebox.loading(!0);var t=this.rel.match(/facebox\[?\.(\w+)\]?/);return t&&(t=t[1]),s(this.href,t),!1}if(e(this).length==0)return;return t(n),this.bind("click.facebox",r)},e(document).bind("close.facebox",function(){e(document).unbind("keydown.facebox"),e("#facebox").fadeOut(function(){e("#facebox .content").removeClass().addClass("content"),e("#facebox .loading").remove(),e(document).trigger("afterClose.facebox")}),l()})})(jQuery);