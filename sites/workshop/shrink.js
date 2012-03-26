// TODO: make it bind to a good event, not a timeout
setTimeout(function() {
$(".content").bind("showoff:show", function (event) {
  var content = $(event.target);
  var slide = content.parent(".slide");
  var slideHeight = $(slide).innerHeight();
  var contentHeight = $(content).height();
  console.log("contentHeight", contentHeight, "slideHeight", slideHeight)
  var fudge = 20;
  var tooBig = (contentHeight + fudge > slideHeight);
  if (tooBig) {

    // shrink text
    var ratio = slideHeight / contentHeight - .15; // extra 15% for luck
    var percent = "" + parseInt(ratio * 100) + "%";
    console.log("Shrinking by " + percent);
    content.css("font-size", percent);

    // shrink images
    content.find('img').each(function(i, element) {
      var newHeight = parseInt($(element).height() * ratio);
      var newWidth = parseInt($(element).width() * ratio);

      $(element).css('height', newHeight).css('width', newWidth);
    });
  }

  // shrink pre (non-wrapping) text
  // (do this after the page has shrunk, in case that fixed it already)
  content.find('pre').each(function(i, element) {
    var pre = $(element);
    var code = $(pre.find("code"));
    var codeWidth = code.width();
    var preWidth = pre.width();

    var nominalWidth = preWidth -
      parseInt(pre.css('padding-left')) -
      parseInt(pre.css('padding-right'));

    if (codeWidth > nominalWidth) {
      var ratio = nominalWidth / codeWidth - .035; // extra 3.5% for luck
      var percent = "" + parseInt(ratio * 100) + "%";
      console.log("Shrinking code by " + percent);
      code.css('font-size', percent);
      pre.css('line-height', percent);
    }
  });
});
}, 500);
