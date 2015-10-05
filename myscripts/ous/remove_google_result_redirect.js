var url = window.location.href.toLowerCase(); 
if (url.indexOf("www.google.com.hk") >= 0 || url.indexOf("www.google.com") >= 0 || url.indexOf("/search") >= 0) 
{ 

//	alert(url);

    var all = document.querySelectorAll("*"); 
// 	alert(all.length + all[0]);
    for (var i = 0; i < all.length; i ++) 
    { 
	//	console.log(all[i]);
	// alert(all[i]);
	break;
        // all[i].onmousedown = null; 
	//	all[i].setAttribute("onmousedown", " ");
		
	//	all[i].onmousedown = function() {
			// alert("nowamagic");	
			// console.log("nowamagic");
	//	}
		
    }

opera.addEventListener('BeforeEvent', function(userJSEvent) {
        if (userJSEvent != null) {
	     //  alert(userJSEvent.element);
	     var evt = userJSEvent.event; 
	    if (userJSEvent.event.type == 'click') {
	     		console.log(userJSEvent.event);
			if (evt.srcElement.tagName == 'A' && evt.srcElement.className == 'l') {
				evt.srcElement.onmousedown = null;
                                var redir_url = evt.srcElement.href;
				console.log(evt.srcElement.href);
				// evt.srcElement.href='http://www.qtchina.net';
				var rupos = redir_url.indexOf('url=');
				// alert(rupos);
				var half_real_url = redir_url.substring(rupos + 4, redir_url.length);
				//alert(real_url);
				var endpos = half_real_url.indexOf('&');
				// alert(endpos);
				var enc_real_url = half_real_url.substring(0, endpos);
				var real_url = decodeURIComponent(enc_real_url);
					
				// alert(enc_real_url + real_url);
				if (evt.srcElement.getAttribute('old_href') == null) {	
				    evt.srcElement.setAttribute('old_href', evt.srcElement.href);
				    evt.srcElement.href = real_url;
					evt.srcElement.title = real_url;
				}
				evt.srcElement.target = "_blank";
                                    evt.srcElement.setAttribute('onmousedown', '');
                        }
		}
	}
	  //userJSEvent.element.text = userJSEvent.element.text
    	//	.replace(/function\s+window\.onload\(/g,'window.onload = function(');
	 },
	 false);
}
