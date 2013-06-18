//= require admin/spree_core
$(function() {
	
	// Index Purchase Order
	
	if($('#purchase_orders').length > 0)
	{
		$('#purchase_orders tbody tr').click(function(e){
			window.location = $(this).data('href');
		})
		
		$('#supplier_backorders a.add').on('confirm:complete', function(e, answer){
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
				window.location = $(this).attr('href')+'?'+encodeURI(get_data.join('&'));
			}
			return false;
		});
		
		
	
	}
	

	
	// New/Edit Purchase Order
	
	if($('#purchase_order_lines').length > 0)
	{
		
		// Total
		var update_total = function(){
			var total = 0;
			$('#purchase_order_lines tbody tr').each(function(i,row){
				var inputs = $(row).find('input');
				total += parseInt(inputs.eq(0).val()) * Number(inputs.eq(1).val());
			});
			$('#purchase_order_lines tfoot .purchase_order_cost').text(Math.round(total*100)/100);
			
		};
		
		$('#purchase_order_lines tbody').on('input', 'input', update_total);
		
		update_total();

	}
	
	// Receive Purchase Order
	
	if($('#receive_purchase_order_lines').length > 0)
	{

		var receive_item = $('#receive_purchase_order_lines a.receive').on('click', function(e){
			e.preventDefault();
			var _this = $(this),
				_quantity_input = _this.parent().find('input.quantity')
				_quantity = _this.parent().parent().find('td.quantity')
				_state = _this.parent().parent().find('span.state');
			$.get(_this.attr('href')+'?quantity='+_quantity_input.val(), function(data){
				var pol = data.purchase_order_line;
				_quantity_input.val(pol.quantity - pol.quantity_received);
				_quantity.text(pol.quantity_received+' / '+pol.quantity);
				_state.text(pol.state);
				_state.attr('class', 'state '+pol.state);
			});
			
		});

	}

});