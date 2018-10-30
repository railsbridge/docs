$(document).ready(function () {
  function saveCheckboxValue (hashcode, value) {
    try {
      localStorage['checkbox_' + hashcode] = value;
    } catch (e) { }
  }

  function fetchCheckboxValue (hashcode) {
    try {
      return localStorage['checkbox_' + hashcode];
    } catch (e) {
      return false;
    }
  }

  var $checkboxes = $('.big_checkbox');

  $checkboxes.each(function () {
    var $checkbox = $(this);
    var content = $checkbox.closest('.step').text();
    var hashcode = md5(content);
    $checkbox.data('hashcode', hashcode);
    $checkbox.prop('checked', fetchCheckboxValue(hashcode) === 'true');
  });

  $checkboxes.on('change', function (event) {
    var $checkbox = $(event.target);
    saveCheckboxValue($checkbox.data('hashcode'), $checkbox.prop('checked'));
  });
});
