// = require jquery
// = require jquery_ujs
// = require twitter/bootstrap/bootstrap-dropdown
// = require twitter/bootstrap/bootstrap-alert
// = require twitter/bootstrap/bootstrap-tab
// = require twitter/bootstrap/bootstrap-button

$('.delete_button').live ('ajax:success', function() {
	$(this).closest('.item').fadeOut('fast');
});