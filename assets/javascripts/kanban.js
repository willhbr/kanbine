(function() {
  $(document).ready(function() {
    $('#kanban-container').find('.kanban-column .sortable').sortable({
      connectWith: '.kanban-column .sortable',
      revert: true,
      over: function(ev, ui) {
        $('.kanban-column .sortable').removeClass('hovering');
        $(this).addClass('hovering');
      }
    });
  });
})();
