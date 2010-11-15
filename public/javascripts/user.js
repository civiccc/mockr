var user = function() {
	
    //preload an image
    var cached = []; //stores a referance to the cached image
    function imagePreload(source){
        cached[cached.length] = new Image();
        cached[cached.length].src = source;
    }
    //return browser's view scrolled to from the left
    function getPageScrollLeft(){
        return document.documentElement.scrollLeft || document.body.scrollLeft;
    }
    
    //return browser's view scrolled to from the top
    function getPageScrollTop(){
        return document.documentElement.scrollTop || document.body.scrollTop;
    }
    
    //return browser's viewable width
    function getBrowserWidth(){
        return document.documentElement.clientWidth ||
        document.body.clientWidth ||
        document.body.offsetWidth;
    }
    
    //return browser's viewable height
    function getBrowserHeight(){
        return window.innerHeight ||
        document.documentElement.clientHeight ||
        document.body.clientHeight ||
        document.body.offsetHeight;
    }
    
    //sets a cookie by name and value with days to expire
    function setCookie(name, value, days){
        var expiration; //cookie expiration string
        var date; //current time
        if (!days) {
            expiration = '';
        }
        else {
            date = new Date();
            date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
            expiration = '; expires=' + date.toGMTString();
        }
        document.cookie = name + '=' + value + expiration + '; path=/';
    }
    
    //Retrieve a cookie value by name
    function getCookie(name){
        var varibaleName = name + "=";
        var cookieCrumbs = document.cookie.split(';');
        for (var i = 0; i < cookieCrumbs.length; i++) {
            var crumb = cookieCrumbs[i];
            while (crumb.charAt(0) == ' ') {
                crumb = crumb.substring(1, crumb.length);
            }
            if (crumb.indexOf(varibaleName) === 0) {
                return crumb.substring(varibaleName.length, crumb.length);
            }
        }
        return false;
    }
    
    //removes a cookie
    function removeCookie(name){
        setCookie(name, '', -1);
    }
    
    //returns selected text
    function getSelectedText(){
        var selection = false;
        if (window.getSelection) {
            selection = window.getSelection();
        }
        else if (document.selection) {
            selection = document.selection.createRange();
        }
        if (selection.text) {
            selection = selection.text;
        }
        return selection;
    }
    
    //returns event object
    function getEvent(){
        if (window.event) {
            return window.event;
        }
        else {
            if (arguments.callee) {
                var callerFunc = arguments.callee;
                while (callerFunc) {
                    for (var i = 0; i < callerFunc['arguments'].length; i++) {
                        if (callerFunc['arguments'][i] instanceof Event) {
                            return callerFunc['arguments'][i];
                        }
                    }
                    callerFunc = callerFunc.caller || false;
                }
            }
            else if (document.createEvent) {
                return window.createEvent();
            }
            else {
                return false;
            }
        }
    }

    //returns element that triggered the event
    function getTarget() {
        var e = getEvent();
        var target = e.target || e.srcElement;
        if (target.nodeType == 3) {
            target = target.parentNode;
        }
        return target;
    }

    //lockout function
    function lockout() {
        canselInput();
        canselBubble();
        return false;
    }

    //stops user from interacting with an element
    function denyInput(element,events) {
        var es = events || ['onclick', 'onmousedown', 'onmouseup', 'onkeypress', 'onkeydown', 'onkeyup'];
        for (var i=0; i < es.length; i++) {
            element[es[i]] = lockout;
        }
    }

    //releases a lockout on a selected element
    function allowInput(element,events) {
        var es = events || ['onclick', 'onmousedown', 'onmouseup', 'onkeypress', 'onkeydown', 'onkeyup'];
        for (var i=0; i < es.length; i++) {
            if (element[es[i]] == lockout) {
                element[es[i]] = null;
            }
        }
    }

    //cansels any default browser actions
    function cancelInput() {
        var e = getEvent();
        e.returnValue = false;
        if (e.preventDefault) {
            e.preventDefault();
        }
    }

    //cansels event bubble
    function cancelBubble() {
        var e = getEvent();
        if (e.cancelBubble) {
            e.cancelBubble = true;
            if (e.stopPropagation) {
                e.stopPropagation();
            }
        }
    }

    //returns mouse's left position
    function getMouseLeft() {
        var e = getEvent();
        if (e.pageX) {
            if (e.pageX != getPageScrollLeft() ) {
                return e.pageX;
            }
            else {
                return false;
            }
        }
        else if (e.clientX) {
            return e.clientX + getPageScrollLeft();
        }
        else {
            return false;
        }
    }

    //returns mouse's top position
    function getMouseTop() {
        var e = getEvent();
        if (e.pageY) {
            if (e.pageY != getPageScrollTop()) {
                return e.pageY;
            }
            else {
                return false;
            }
        }
        else if (e.clientY) {
            return e.clientY + getPageScrollTop();
        }
        else {
            return false;
        }
    }

    //returns if right mouse button was clicked
    function getRightClick() {
        var e = getEvent();
        if (e.button == 2) {
            return true;
        }
        else if (e.which == 3) {
            return true;
        }
        else {
            return false;
        }
    }

    //returns keycode for pressed key
    function getKey() {
        var e = getEvent();
        return e.keyCode || e.which;
    }

    //returns key character from pressed key
    function getChar() {
        var e = getEvent();
        var key = getKey();
        switch (key) {
        case 13:
            return "enter";
        case 27:
            return "esc";
        case 37:
            return "left";
        case 38:
            return "up";
        case 39:
            return "right";
        case 40:
            return "down";
        default:
            return String.fromCharCode(key);
        }
    }

    return {
        cookie : {
            set     : setCookie,
            get     : getCookie,
            remove  : removeCookie
        },
        mouse : {
            left       : getMouseLeft,
            top        : getMouseTop,
            rightclick : getRightClick
        },
        keyboard : {
            code      : getKey,
            character : getChar
        },
        browser : {
            left     : getPageScrollLeft,
            top      : getPageScrollTop,
            width    : getBrowserWidth,
            height   : getBrowserHeight,
            cache    : imagePreload,
            selected : getSelectedText,
            event    : getEvent,
            target   : getTarget,
            deny     : denyInput,
            allow    : allowInput,
            cancel   : cancelInput,
            pop      : cancelBubble,
            html     : document.documentElement || document
        }
    };
    
}();