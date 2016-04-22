(function() {
  $(document).ready(function() {
    $('#kanban-container').find('.kanban-column .sortable').sortable({
      connectWith: '.kanban-column .sortable',
      revert: 100,
      placeholder: 'placeholder',
      start: function(event, ui) {
        ui.placeholder.height(ui.helper.height())
      },
      stop: function(ev, ui) {
        // stopped
      }
    });
  });
})();
