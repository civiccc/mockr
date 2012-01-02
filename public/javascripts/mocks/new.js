$(function() {
    $('#mock_creation_form').fileupload({
        dataType: 'json',
        url: '/mocks',
        singleFileUploads: false,
        done: function (e, data) {
          result = data.result;
          if (result.mocks_count == 1) {
            window.location = '/mocks/' + result.mock_ids[0];
          } else {
            window.location = '/projects/' + result.project_id;
          }
        },
        start: function (e) {
          $(this).addClass('submitted');
        },
        fail: function (e, data) {
          window.location = window.location + '?failed=1';
        }
    });
    var dragCount = 0;

    $(document.body).bind('dragenter', function(e) {
      $(document.body).addClass("dragging");
      dragCount += 1;
    });
    $(document.body).bind('dragleave', function(e) {
      dragCount -= 1;
      if (dragCount == 0) {
        $(document.body).removeClass("dragging");
      }
    });
});
