(function() {
  function moveIssue(issueElem, target) {
    var issue = $(issueElem);
    var column = $(target);
    issue.remove();
    issue.css({ position: '', left: '', top: '' });
    column.append(issue);
  }

  $(document).ready(function() {
    $('.draggable').draggable({
      containment: '#kanban-container',
      cursor: 'move',
      snap: '#kanban-container'
    });

    $('.droppable').droppable({
      drop: function(ev, ui) {
        moveIssue(ui.draggable, ev.target);
      }
    })
  });
})();
