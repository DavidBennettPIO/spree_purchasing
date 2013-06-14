//= require admin/spree_core
$(function() {
	
	$('fieldset[data-hook="supplier_backorders"] a.add').on('confirm:complete', function(e, answer){
		e.preventDefault();
		if(answer){
			var backorder_table = $(this).closest('table'),
				supplier_id = $(this).data('supplier-id'),
				checkbox_selecter = 'input[name="backorder_'+supplier_id+'"]:checked',
				get_data = ['purchase_order[supplier_id]='+supplier_id];
			
			backorder_table.find(checkbox_selecter).each(function(i,checkbox){
				var get_s = 'purchase_order[purchase_order_lines_attributes]['+i+']';
				get_data.push(get_s+'[quantity]='+$(checkbox).data('quantity'));
				get_data.push(get_s+'[price]='+$(checkbox).data('price'));
				get_data.push(get_s+'[variant_id]='+$(checkbox).data('variant-id'));
				get_data.push(get_s+'[order_id]='+$(checkbox).data('order-id'));
			});
			alert(get_data.join('&'));
			window.location = $(this).attr('href')+'?'+encodeURI(get_data.join('&'));
		}
		return false;
	});
	

	
	// New Purchase Order
	
	if($('fieldset#purchase_order_lines').length > 0)
	{
		
		var update_total = function(){
			var total = 0;
			$('fieldset#purchase_order_lines tbody tr').each(function(i,row){
				var inputs = $(row).find('input');
				total += parseInt(inputs.eq(0).val()) * Number(inputs.eq(1).val());
			});
			$('fieldset#purchase_order_lines tfoot .purchase_order_cost').text(Math.round(total*100)/100);
			
		};
		
		$('fieldset#purchase_order_lines tbody').on('input', 'input', update_total);
		
		
		
		update_total();
		
		
	}

});