$(function() {
  var pageToFetch = 2,
      prevQueryLength = 0,
      userId;

  $(".more").click(function() {
    $(this).addClass("loading");
    $.get("/home/mock_set", {page: pageToFetch}, function(data) {
      $(".more").removeClass("loading");
      if (data.trim().length > 0) {
        $("#mock_set").append(data);
      }
      if (pageToFetch === TOTAL_PAGES) {
        $(".more").hide();
      }
      filter_users();
      pageToFetch++;
    });
  });

  $('#show_all_projects').click(function(evt) {
    evt.preventDefault();
    $('#all_projects').show();
    $('#show_all_projects').hide();
  });

  $('.project_filter').keyup(function() {
    var $projects = $('.project_list li');
    var filter = $.trim($(this).val());

    if (filter) {
      filterRegexp = new RegExp(filter ,'i');
      $projects
        .filter(':visible')
        .filter(function() { return !filterRegexp.test(this.textContent); })
        .hide();

      if (filter.length <= prevQueryLength) {
        $projects
          .filter(':hidden')
          .filter(function() { return filterRegexp.test(this.textContent); })
          .show();
      }
    } else {
      $projects.show();
    }

    prevQueryLength = filter.length;
  });

  $('.author_link').click(function(e) {
    e.preventDefault();
    var $this = $(this);

    userId = $this.data('author');
    filterUsers();

    $('.author_link').removeClass('selected');
    $this.addClass('selected');
  });

  var filterUsers = function() {
    if (userId) {
      $('.mock_grid li')
        .hide()
        .filter('[data-author=' + userId + ']')
        .show();
    } else {
      $('.mock_grid li').show();
    }
  }

});
