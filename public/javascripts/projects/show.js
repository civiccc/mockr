$(function() {
  var settings = {
    adjustWidth: false,
    doubleClickMode: false
  };
  $("#mock_lists .text").inlineEditor(
    $.extend(settings, {showEditOnMouseover: true}));
  $("#project_header h1").inlineEditor(
    $.extend(settings, {showEditOnMouseover: false}));
});