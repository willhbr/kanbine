(function() {
  function issueToJSON(elem) {
    var data = {
      id: elem.data('id'),
      down: elem.next().data('id'),
      up: elem.prev().data('id'),
      status_id: elem.parents('.kanban-column').data('id')
    };
    return data;
  }
  function updateStatusPosition(elem) {
    elem.removeClass('ajax-error');
    var dat = issueToJSON(elem);
    $.post(
      '/kanbine/issues/update_status_position',
      dat
    ).done(function(res) {
      if(res.saved) {
        console.log("Saved!");
      } else {
        alert(res.errors);
      }
    }).fail(function(res) {
      elem.addClass('ajax-error');
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
