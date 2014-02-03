// HTML5 Shims...
document.createElement('main');
document.createElement('footer');

$(document).ready(function () {
  $('[data-toggle-selector]').on('click', function (event) {
		event.preventDefault();
    var toToggle = $(event.target).data('toggle-selector');
    var originallyVisible = $(toToggle).hasClass('visible');
    $('.toc').removeClass('visible');
    $(toToggle).toggleClass('visible', !originallyVisible);
    return false;
  });

  $('.toggler').on('click', function (e) {
    e.preventDefault();
    $(this).closest('.collapsable').toggleClass('closed');
  });

  $('.expand-all').on('click', function (e) {
    e.preventDefault();
    $('.closed').removeClass('closed');
    $('.expand-all').remove();
  });
});
