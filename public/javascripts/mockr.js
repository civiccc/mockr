var mockr = function() {
    var mockView;
    var sidebar;
    
    // .highlight() : creates a highlighted section by clicking and dragging
    // .initialize() : binds user highlight to the page (start,size,stop)
    // .create()    : create a new highlighted section
    // .clear()     : removes all highlighted sections
    // .selected()  : returns the area highlighted by the user
    var highlight = function(){
        var area;  // area highlighted by user
        var dom;   // userlight dom element
        var x ;    // vertical mouse data
        var y;     // horizontal mouse data

        function initialize() {
          x = {};
          y = {};
          mockView.mousedown(function(event){
            event.preventDefault();
            start();
          });
          mockView.mousemove(size);
          mockView.mouseup(stop);
        }
        function getArea(){
            return area;
        }
        function clear(){
            $('#mock div.highlight').animate({opacity:0}, 500,null,function(){
                $(this).remove();
            });
            $('#area').remove();
            $('#add_feedback_form').parents("div.module").
              removeClass("commenting");
            area = null;
            dom = null;
        }
        function create(o){
            return $('<div class="highlight"></div>').css({
                left     : o.x || 0,
                top      : o.y || 0,
                opacity  : 0.4,
                width    : o.width,
                height   : o.height
            }).attr({
                id:o.id
            }).appendTo(mockView)[0];
        }

        function start(){
            x.start = getX();
            y.start = getY();
            clear();
            dom = $('<div id="area" class="highlight"></div>')[0];
            mockView.append(dom);
            $(dom).css({
                left     : x.start,
                top      : y.start,
                opacity  : 0.4,
                width    : 2,
                height   : 2
            });
        }
        function getX() {
          return user.mouse.left() - mockView.offset().left +
                  $('#mock').scrollLeft();
        }
        function getY() {
          return user.mouse.top() - mockView.offset().top + 
                  $('#mock').scrollTop();
        }
        function size(){
            if (!y.start && !x.start) return false;
            x.drag = getX();
            y.drag = getY();
            $(dom).css({
                left   : x.start < x.drag ? x.start : x.drag,
                top    : y.start < y.drag ? y.start : y.drag,
                width  : Math.abs( x.start - x.drag ),
                height : Math.abs( y.start - y.drag )
            });
        }
        function stop(){
            startCommenting();
            $("<div id='click_tooltip'>" +
              "Click to comment</div>").appendTo("#show_sidebar");
            var o = {
                x : x.start < x.drag ? x.start : x.drag,
                y : y.start < y.drag ? y.start : y.drag,
                width : $(dom).width(),
                height : $(dom).height()
            };
            x = {};
            y = {};
            if (o.width < 10 || o.height < 10) {
                clear();
                dom = null;
            }
            else {
                area = o;
                $('#comment_x').val(o.x||0);
                $('#comment_y').val(o.y||0);
                $('#comment_width').val(o.width||0);
                $('#comment_height').val(o.height||0);
            }
        }
        
        return {
            initialize : initialize,
            create    : create,
            clear     : clear,
            area      : getArea,
        };
    }();

    this.startCommenting = function(){
      $('#add_feedback_form').parents("div.module").addClass("commenting");
      $('#comment_text').focus();
    }

    function toggleSidebar() {
      if ($(document.body).hasClass('fullscreen')) {
        showSidebar();
      } else {
        hideSidebar();
      }
    }

    function showSidebar() {
      $.cookie('sidebar', 1);
      if ($(document.body).hasClass('fullscreen')) {
        sidebar.animate({left: '0'}, 'fast');
        mockView.animate({left: '0'}, 'fast');
        $(document.body).toggleClass('fullscreen');
      }
    }

    function hideSidebar() {
      $.cookie('sidebar', 0);
      if (!$(document.body).hasClass('fullscreen')) {
        sidebar.animate({left: '-400px'}, 'fast');
        mockView.animate({left: '-400px'}, 'fast');
        $(document.body).toggleClass('fullscreen');
      }
    }

    function initializeFeedbackFilter() {
      $("#feedback_filter").change(function(event) {
        location.href = "?feedback_filter=" + event.target.value
      })
    }

    function initializeTextareas() {
      $("textarea").keydown(function(event) {
        if (user.keyboard.character() == "enter") {
          $(this).height($(this).height() + 24);
        }
      });   
    }
    
    function initializeChildComments() {
      $("#comments_list .replylink").click(function() {
        $(this).parents(".comment_node").find(".reply").
          slideToggle().find('textarea').focus();
      });
      $(".comment_node form").submit(function(e) {
        e.preventDefault();
        var form = $(this);
        var submitComment = function() {
          form.ajaxSubmit({success: function(text) {
            var commentNode = form.parents(".comment_node");
            var comment = $(text).hide();
            var ul = commentNode.find("#children_comments_list");
            if (ul.length == 0) {
              commentNode.find(".reply_container").
                before("<ul id='children_comments_list'></ul>");
            }
            commentNode.find("#children_comments_list").append(comment);
            //FB.XFBML.parse();
            comment.slideDown(500);
            form.find("textarea").val("");
          }});
        }
        $("#comments_list .highlighted .reply").slideUp(500, submitComment);
      })
    }
    
    function earlierComment() {
      var elem = $("#comments_list>li.highlighted")
      if (elem.length > 0) {
        elem = elem.next();
      } else {
        elem = $("#comments_list>li:first-child")
      }
      if (elem.length > 0)
        highlightComment(elem);
    }
    
    function laterComment() {
      var elem = $("#comments_list>li.highlighted")
      if (elem.length > 0) {
        elem = elem.prev();
        if (elem.length > 0)
          highlightComment(elem);
      }
    }

    function reply() {
      $("#comments_list .highlighted .reply").
        slideToggle().find('textarea').focus();
    }

    function undoReply() {
      $("#comments_list .highlighted .reply").slideToggle();      
    }

    function nextMock() {
      href = $("#next_link").attr("href");
      if (href)
        location.href = href;
    }
    
    function prevMock() {
      href = $("#prev_link").attr("href");
      if (href)
        location.href = href;
    }

    function highlightFeeling(feeling) {
      highlight.clear();
      $("#comments_list>li." + feeling).each(function(i, elem) {
        highlightElem($(elem));
      });
    }

    function initializeFeedbackHighlight() {
      $("#stats_list>li").each(function(i, elem) {
        var className = $(elem).attr("class");
        $(elem).click(function() {
          highlightFeeling(className);          
        });
      })
    }

    function highlightElem(elem, scrollTo) {
      if (elem.attr('box')) {
        var box = elem.attr('box').split('_');
        var id = elem.attr('id');
        var high = highlight.create({
            x: box[0],
            y: box[1],
            width: box[2],
            height: box[3],
            id: id
        });
        if (scrollTo)
          scrollToElem(high);
      }      
    }

    function highlightComment(elem) {
      $("#comments_list>li").removeClass('highlighted');
      elem.addClass('highlighted');
      highlight.clear();
      highlightElem(elem, true);
    }
    
    function initializeComments() {
      $("#comments_list>li").click(function(){
        highlightComment($(this));
      });
    }
    
    function adjustDimensions() {
      setTimeout(function() {
        height = user.browser.height() - $('#header').height() - 1;
        width = user.browser.width() - $("#sidebar").width();
        if (width == 0)
          width = user.browser.width() - 400;
        $("#sidebar").height(height);
        $("#mock").height(height);
        $("#mock").width(width);        
      }, 500)
    }
    
    function expandAll() {
      $("#comments_list > li").removeClass("read");
    }
    
    function collapseAll() {
      $("#comments_list > li").addClass("read");
    }

    function scrollToElem(elem) {
      boxTop = parseInt(elem.style.top);
      mockTop = parseInt($('#mock').height() / 2);
      boxLeft = parseInt(elem.style.left);
      mockLeft = parseInt($('#mock').width() / 2);
      position = {
        top:  Math.max(boxTop - mockTop, 0), 
        left: Math.max(boxLeft - mockLeft, 0)        
      }
      $(elem).css({opacity: 0});
      // TODO: Find a built in bounds function.
      if (position.top < $('#mock').scrollTop() ||
          position.top > $('#mock').scrollTop() + $('#mock').height()) {
        pause = 400;
      } else {
        pause = 0;
      }
      $('#mock').scrollTo(position, pause, {axis: 'xy', onAfter: function() {
        $(elem).animate({opacity: 0.7}, 200).animate({opacity: 0.4}, 200);
      }});
    }

    function initialize() {
        mockView = $("#mock");
        sidebar = $('#sidebar');
        
        highlight.initialize();
        adjustDimensions();
        initializeFeedbackFilter();
        initializeTextareas();
        initializeComments();
        initializeChildComments();
        initializeFeedbackHighlight();
    }

    return {
        initialize:       initialize,
        highlight:        highlight,
        startCommenting:  startCommenting,
        adjustDimensions:    adjustDimensions,
        hideSidebar:      hideSidebar,
        showSidebar:      showSidebar,
        toggleSidebar:    toggleSidebar,
        earlierComment:   earlierComment,
        laterComment:     laterComment,
        prevMock:         prevMock,
        nextMock:         nextMock,
        reply:            reply,
        undoReply:        undoReply,
        expandAll:        expandAll,
        collapseAll:      collapseAll
    };
}();

var KeyboardShortcuts = {
  setup: function() {
    $(document.body).shortkeys({
      "f": function() {
        mockr.toggleSidebar();
      },
      "k": function() {
        mockr.laterComment();
      },
      "j": function() {
        mockr.earlierComment();
      },
      "p": function() {
        mockr.prevMock();
      },
      "n": function() {
        mockr.nextMock();
      },
      "r": function() {
        mockr.reply();
      }
      // TODO: Figure out how to make escape work in shortkeys.
      // "esc", function() {
      //   mockr.undoReply();
      // }
    })
  }
}

var Flash = {
  setup: function() {
    window.setTimeout(function() {
      $("#notice").animate({top: -100});
    }, 2000);
  }
}
$(function() {
  mockr.initialize();
  KeyboardShortcuts.setup();
  Flash.setup();
});

$(window).resize(mockr.adjustDimensions);
