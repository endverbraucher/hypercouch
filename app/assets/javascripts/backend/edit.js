// = require jquery
// = require jquery_ujs
// = require codemirror
// = require codemirror/modes/markdown
// = require codemirror/modes/gfm

jQuery(function($) {
	$('div.btn-group').each(function(){
	    var group   = $(this);
	    var form    = group.parents('form').eq(0);
	    var name    = group.attr('data-toggle-name');
	    var hidden  = $('input[name="' + name + '"]', form);
	    $('button', group).each(function(){
	      var button = $(this);
	      button.live('click', function(){
	          hidden.val($(this).val());
	      });
	      if(button.val() == hidden.val()) {
	        button.addClass('active');
	      }
	    });
	  });
});

var myCodeMirror = CodeMirror.fromTextArea(post_mdown, {lineWrapping: true});