(function() {
  function showDialogFor(elem) {
    var html = $('#dialog-helper').html();
    var title = 'DIALOG  TITLE WOOOO';
    $('<div></div>').appendTo('body').html(html).dialog({
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
      if(res.saved) {
        console.log("Saved!");
      } else {
        elem.addClass('ajax-error');
        alert(res.errors);
      }
    }).fail(function(res) {
      elem.addClass('ajax-error');
    }).always(function(res) {
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
        console.log(e);
        showDialogFor($(e.currentTarget).parent());
      }
    });
  });
})();
