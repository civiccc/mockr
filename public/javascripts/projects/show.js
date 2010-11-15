$(function() {
  var settings = {
    adjustWidth: false,
    doubleClickMode: false, 
    showEditOnMouseover: false
  };
  $("#mock_lists h2").inlineEditor(settings);
  $("#project_header h1").inlineEditor(settings);
});