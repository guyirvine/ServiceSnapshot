require 'test/unit'
require "helper_functions"


class GetParamTest < Test::Unit::TestCase
    
    
    def setup
        ENV.delete("param")
    end

	def test_get_param_symbol
        params = Hash.new
        params[:param] = "param symbol"
        
        param = get_param( params, :param, "usage" )
        
        assert_equal "param symbol", param
    end
    
    def test_get_param_env
        params = Hash.new
        ENV["param"] = "param env"
        
        param = get_param( params, :param, "usage" )
        
        assert_equal "param env", param
    end
    
    
    def test_get_param_symbol_over_env
        params = Hash.new
        params[:param] = "param symbol"
        ENV["param"] = "param env"
        
        param = get_param( params, :param, "usage" )
        
        assert_equal "param symbol", param
    end
    
    def test_get_param_not_present
        params = Hash.new

        exception_raised = false
        begin
            param = get_param( params, :param, "usage" )
            rescue ParameterMissingError=>e
            assert_equal e.message, "*** Could not find parameter, param, for command, test_get_param_not_present\n*** usage\n*** Try :param=>'YourValue'\n"

            exception_raised = true
        end
        
		assert_equal true, exception_raised
	end
    
    
end
