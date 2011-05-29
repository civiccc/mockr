$(function() {
  var pageToFetch = 2;

  $(".more").click(function() {
    $(this).addClass("loading");
    $.get("/home/mock_set", {page: pageToFetch}, function(data) {
      $(".more").removeClass("loading");
      if (data.trim().length > 0) {
        $(data).insertBefore('.more');
      }
      if (pageToFetch == TOTAL_PAGES) {
        $(".more").hide();
      }
      pageToFetch++;
    });
  });
});
