(function() {
  function showErrors(elem, res) {
    if(!res.saved) {
      elem.addClass('ajax-error');
      console.log(res);
      var msg = res.errors !== undefined ? res.errors.join('<br>') : res.responseText;
      $("<div>" + msg + "</div>").dialog({
        title: 'Error updating #' + elem.data('id'),
        buttons: { 'Ok': function () { $(this).dialog('close'); } }
      });
    }
  }
  function saveIssue(id, elem, form) {
    $.post(
      '/kanbine/issues/' + id + '/update',
      form.serialize()
    ).done(function(res) {
      if(res.saved) {
        var cont = $(res.html).html();
        elem.html(cont);
      }
    }).always(function(res) {
      showErrors(elem, res);
    });
  }
  function insertIssueIntoDialog(elem, dialog) {
    var fields = elem.find('#fields').children();
    for(var i = 0; i < fields.length; i++) {
      var field = $(fields[i]);
      var name = field.attr('id');
      var value = field.html();
      var target = dialog.find('#issue_' + name);
      target.val(value);
    }
  }
  function showDialogFor(elem) {
    var dialog = $('#dialog-helper').clone();
    var id = elem.data('id');
    var title = 'Edit #' + id;
    insertIssueIntoDialog(elem, dialog);
    dialog.dialog({
      modal: true, title: title, autoOpen: true,
      width: 300, resizable: true,
      buttons: {
        'Save': function(event, ui) {
          saveIssue(id, elem, dialog.find('form').first());
          $(this).dialog('close');
        },
        'Cancel': function(event, ui) {
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
    ).always(function(res) {
      showErrors(elem, res);
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
    $(document).on('click', '.kanban-row .issue-subject', function(e) {
      if(allowClick) {
        showDialogFor($(e.currentTarget).parent());
      }
    });
  });
})();
