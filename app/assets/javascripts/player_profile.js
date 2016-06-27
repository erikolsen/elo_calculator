$(document).on('page:change', function () {
  $("#tabs").tabs({
    heightStyle: 'fill',
    active: localStorage.getItem("currentTabIndex"),
    activate: function(event, ui) {
      localStorage.setItem("currentTabIndex", ui.newTab[0].dataset["tabIndex"]);
    }
  });
});
