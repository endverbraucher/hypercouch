var claims = [
  "bin neugierig.",
  "löse gern Probleme.",
  "liebe Dresden.",
  "studierte einst in Trier.",
  "wohne jetzt Köln.",
  "liebe gut benutzbare Dinge.",
  "beobachte Menschen.",
  "beobachte Maschinen.",
  "mach mal eine Pause.",
  ];

$(document).ready(function(){
  $(".remark-refresh").click(function () {
    event.preventDefault();

    $("svg", this).rotate({
      duration: 1100,
      angle: 0,
      animateTo:360,
      callback: function() {
        $(".m-hero-remark").hide().html(claims.shift()).fadeIn();

        if (claims.length == 0) {
          $(".remark-refresh").remove();
        };
      }
    });
  })
});