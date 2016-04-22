(function() {
  function issueToJSON(elem) {
    var data = {
      id: elem.data('id')
    };
    return data;
  }
  function updateStatusPosition(elem) {
    var dat = issueToJSON(elem);
    $.post(
      '/kanbine/issues/update_status_position',
      dat
    ).done(function(res) {

    }).fail(function(res) {

    }).always(function(res) {

    });
  }

  $(document).ready(function() {
    $('#kanban-container').find('.kanban-column .sortable').sortable({
      connectWith: '.kanban-column .sortable',
      revert: 100,
      placeholder: 'placeholder',
      start: function(event, ui) {
        ui.placeholder.height(ui.helper.height())
      },
      stop: function(ev, ui) {
        updateStatusPosition(ui.item);
      }
    });
  });
})();
