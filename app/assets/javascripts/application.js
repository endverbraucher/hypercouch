//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require jquery.turbolinks
//= require jquery_rotate
//= require hero_remark

String.prototype.rot13 = function(){
    return this.replace(/[a-zA-Z]/g, function(c){
        return String.fromCharCode((c <= "Z" ? 90 : 122) >= (c = c.charCodeAt(0) + 13) ? c : c - 26);
    });
};

$(document).ready(function(){
  $('.twitter-link').after('<li><a href="mailto:'+ 'unyyb@fybt.vb'.rot13() +'?subject=Guten Tag!">sag Hallo!</a></li>');
});