OrdersController.class_eval do
  def populate
    @order = current_order(true)

    variant = Variant.new
    variant.product_id = params[:products].keys.first.to_i
    variant.price = BigDecimal.new("0.0")
    option_values = params[:new_variant]
    option_values.each_value {|id| variant.option_values << OptionValue.find(id)}
    p variant.option_values
    p "!!"
    variant.save
    p "!!"

    params[:products].each do |product_id,variant_id|
      quantity = params[:quantity].to_i if !params[:quantity].is_a?(Hash)
      quantity = params[:quantity][variant.id].to_i if params[:quantity].is_a?(Hash)
      @order.add_variant(variant, quantity) if quantity > 0
    end if params[:products]

    params[:variants].each do |variant_id, quantity|
      quantity = quantity.to_i
      @order.add_variant(variant, quantity) if quantity > 0
    end if params[:variants]

    respond_with(@order) { |format| format.html { redirect_to cart_path } }
  end
end