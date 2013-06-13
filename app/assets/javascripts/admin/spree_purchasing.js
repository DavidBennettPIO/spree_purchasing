//= require admin/spree_core
$(function() {
	$('form fieldset[data-hook="admin_backorders"] a.add').click(function(e){
		e.preventDefault();
		$(this).closest('form').submit();
	});
});