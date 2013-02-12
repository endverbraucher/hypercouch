//= require jquery
//= require jquery_ujs
//= require jquery_rotate

$(document).ready(function(){

  $(".remark-refresh").click(function () {

    $("img", this).rotate({
      duration: 1500,
      angle: 0,
      animateTo:360,
      callback: function() {
        $(".m-hero-remark").hide().html("Perlen vor die Säue").fadeIn("slow");
      }
    });
  })
});