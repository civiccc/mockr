$(function() {
  var pageToFetch = 2;
  var prevQueryLength = 0;
  var user_id = undefined;

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

  $('.author_link').click(function() {
    user_id = $(this).attr("data-author");
    filter_users();
    $('.author_link').attr("data-selected", false);
    $(this).attr('data-selected', true);
    return false;
  });

  filter_users = function(){
    if (user_id) {
      $('.mock_grid li').hide();
      $('.mock_grid li[data-author=' + user_id + ']').show();
    } else {
      $('.mock_grid li').show();
    }
  }

});
