(function() {
  function showDialogFor(elem) {
    var dialog = $('#dialog-helper').clone();
    var title = 'Edit #' + elem.data('id');
    var fields = elem.find('#fields').children();
    for(var i = 0; i < fields.length; i++) {
      var field = $(fields[i]);
      var name = field.attr('id');
      var value = field.html();
      console.log(name, value);
      dialog.find('#field-' + name).html(value);
    }
    dialog.dialog({
      modal: true, title: title, autoOpen: true,
      width: 300, resizable: true,
      buttons: {
        'Save': function(){},
        'Cancel': function (event, ui) {
            $(this).dialog('close');
        }
      },
      close: function (event, ui) {
          $(this).remove();
      }
    });
  }
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
      if(!res.saved) {
        elem.addClass('ajax-error');
        var msg = res.errors.join('<br>');
        $("<div>" + msg + "</div>").dialog({
          title: 'Error updating #' + dat.id,
          buttons: { 'Ok': function () { $(this).dialog('close'); } }
        });
      }
    }).fail(function(res) {
      elem.addClass('ajax-error');
    });
  }
  var allowClick = true;
  $(document).ready(function() {
    $('#kanban-container').find('.kanban-column .sortable').sortable({
      connectWith: '.kanban-column .sortable',
      revert: 100,
      placeholder: 'placeholder',
      distance: 10,
      start: function(event, ui) {
        allowClick = false;
        ui.placeholder.height(ui.helper.height())
      },
      stop: function(ev, ui) {
        allowClick = true;
        updateStatusPosition(ui.item);
      }
    });
    $('.kanban-row .issue-subject').on('click', function(e) {
      if(allowClick) {
        showDialogFor($(e.currentTarget).parent());
      }
    });
  });
})();
