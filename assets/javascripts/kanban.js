(function() {
  function bindDraggable(domElems) {
    domElems.draggable({
      containment: '#kanban-container',
      cursor: 'move',
      snap: '#kanban-container',
      revert: 'invalid'
    });
  }

  function moveIssue(issueElem, target) {
    var issue = $(issueElem);
    var column = $(target);
    issue.remove();
    issue.css({
      position: 'relative',
      left: '',
      top: ''
    })
    column.append(issue);
  }

  $(document).ready(function() {
    bindDraggable($('.draggable'));

    $('.droppable').droppable({
      drop: function(ev, ui) {
        moveIssue(ui.draggable, ev.target);
      },
      hoverClass: 'hovering'
    });
  });
})();
