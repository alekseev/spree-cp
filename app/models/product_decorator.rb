Product.class_eval do
	def has_option_types?
		!option_types.empty?
	end
end