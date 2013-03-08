//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require bootstrap
//= require turbolinks

jQuery(function($) {
    $('div.btn-group').each(function(){
        var group   = $(this);
        var form    = group.parents('form').eq(0);
        var name    = group.attr('data-toggle-name');
        var hidden  = $('input[name="' + name + '"]', form);
        $('button', group).each(function(){
          var button = $(this);
          button.on('click', function(){
              hidden.val($(this).val());
          });
          if(button.val() == hidden.val()) {
            button.addClass('active');
          }
        });
      });
});

$(document).on('click', '#sidebarTabs a', function(event) {
  event.preventDefault();
  $(this).tab('show');
});

$(document).on('click', '.edit-Button', function(event) {
  event.preventDefault();

  $(this).closest('.tab-pane').find(".delete-button").fadeToggle("fast");
});

$(document).on('ajax:success','.delete-button', function() {
    $(this).closest('li').fadeOut('slow');
});