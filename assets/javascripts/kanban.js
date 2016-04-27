(function() {
  var projectID;

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

  function showDialogWithErrors(values, res, dialogCreator) {
    if(!res.saved) {
      var diag = dialogCreator();

      var newForm = diag.find('form');
      for(var i = 0; i < values.length; i++) {
        newForm.find("[name='" + values[i].name + "']").val(values[i].value);
      }
      var errs = diag.find('#issue-errors');
      var msg = res.errors !== undefined ? res.errors.join('<br>') : res.responseText;
      errs.text(msg);
      errs.show();
    }
  }

  function saveIssue(id, elem, form) {
    var values = form.serializeArray();
    $.post(
      '/kanbine/projects/' + projectID + '/' + id + '/update',
      form.serialize()
    ).done(function(res) {
      if(res.saved) {
        var cont = $(res.html).html();
        elem.html(cont);
      }
    }).always(function(res) {
      showDialogWithErrors(values, res, function() {
        return showUpdateDialogFor(elem);
      });
    });
  }
  function createIssue(statusID, form) {
    var values = form.serializeArray();
    $.post(
      '/kanbine/projects/' + projectID + '/create',
      form.serialize()
    ).done(function(res) {
      if(res.saved) {
        $('#kb-col-' + statusID + ' .sortable').prepend($(res.html))
      }
    }).always(function(res) {
      showDialogWithErrors(values, res, function() {
        return showCreateDialogForStatus(statusID);
      });
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
  function showUpdateDialogFor(elem) {
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
    return dialog;
  }
  function showCreateDialogForStatus(statusID) {
    var dialog = $('#dialog-helper').clone();
    dialog.find('#issue_status_id').val(statusID);
    var title = 'New Issue';
    dialog.dialog({
      modal: true, title: title, autoOpen: true,
      width: 300, resizable: true,
      buttons: {
        'Save': function(event, ui) {
          createIssue(statusID, dialog.find('form').first());
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
    return dialog;
  }
  function issueToJSON(elem) {
    var data = {
      issue_id: elem.data('id'),
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
      '/kanbine/projects/' + projectID + '/update_status_position',
      dat
    ).always(function(res) {
      showErrors(elem, res);
    });
  }
  function setContainerWidth() {
    var container = $('#kanban-container');
    var children = container.children('.kanban-column');
    var count = children.length + 0.5;
    var width = children.width();
    container.width(count * width);
  }
  function disableDialogFormSubmit() {
    $(document).on('submit', '#dialog-helper form', function(e) {
      e.preventDefault();
    });
  }
  var allowClick = true;
  $(document).ready(function() {
    projectID = $('#kanban-container').data('project');
    setContainerWidth();
    disableDialogFormSubmit();
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
        showUpdateDialogFor($(e.currentTarget).parent());
      }
    });
    $('.add-issue').on('click', function(e) {
      e.preventDefault();
      showCreateDialogForStatus($(this).parents('.kanban-column').data('id'));
    });
  });
})();
