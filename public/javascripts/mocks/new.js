$(function() {
    $('#mock_creation_form').fileupload({
        dataType: 'json',
        url: '/mocks',
        singleFileUploads: false,
        done: function (e, data) {
          window.location = '/?uploaded=1';
        },
        start: function (e) {
          $(this).addClass('submitted');
        },
        fail: function (e, data) {
          window.location = '/?uploaded=0';
        },
        dragover: function(e, data) {
          $(document.body).addClass("dragging");
        }
    });
    $(document.body).bind('dragleave', function() {
      $(document.body).removeClass("dragging");
    });
});
