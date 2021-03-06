module Minidynamo
	class Model
		module Keys

			# For all the fields with defaults
			attr_writer :write_capacity, :read_capacity

			attr_reader :range_key

			def hash_key
				@hash_key || {:id => :string}
			end

			def hash_key=(key)
				@hash_key = key
				hk = key.keys[0]
				finder_method_name = "find_by_#{hk}".to_sym   
				unless finder_method_name == :find_by_id        
					self.define_singleton_method finder_method_name do |x|
						find_by_id x
					end
				end
				type = key[hk]
				attribute_creator_method_name = "#{type.to_s}_attr".to_sym
				#puts "hk: CALLING #{attribute_creator_method_name} with #{hk}"
				send attribute_creator_method_name, hk 
			end

			def range_key=(key)
				@range_key = key
				rk = key.keys[0]
				type = key[rk]
				attribute_creator_method_name = "#{type.to_s}_attr".to_sym
				#puts "rk: CALLING #{attribute_creator_method_name} with #{rk}"
				send attribute_creator_method_name, rk 
			end

			def hash_key_attribute_name
				hash_key.keys[0]
			end

			def range_key_attribute_name
				range_key.keys[0]
			end

			def hash_key_type
				dynamo_db_table.hash_key.type.to_s.chars.first.to_sym
			end
			
			def hash_range_table?
				! range_key.nil?
			end

		end
	end
end