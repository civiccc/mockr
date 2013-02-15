$(function() {
  var pageToFetch = 2;
  var prevQueryLength = 0;

  $(".more").click(function() {
    $(this).addClass("loading");
    $.get("/home/mock_set", {page: pageToFetch}, function(data) {
      $(".more").removeClass("loading");
      if (data.trim().length > 0) {
        $(data).insertBefore('.more');
      }
      if (pageToFetch === TOTAL_PAGES) {
        $(".more").hide();
      }
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
});
