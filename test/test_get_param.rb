require 'minitest/autorun'
require 'helper_functions'

# GetParamTest
class GetParamTest < Minitest::Test
  def setup
    ENV.delete('param')
  end

  def test_get_param_symbol
    params = {}
    params[:param] = 'param symbol'
    param = get_param(params, :param, 'usage')

    assert_equal 'param symbol', param
  end

  def test_get_param_env
    ENV['param'] = 'param env'
    param = get_param({}, :param, 'usage')
    assert_equal 'param env', param
  end

  def test_get_param_symbol_over_env
    params = {}
    params[:param] = 'param symbol'
    ENV['param'] = 'param env'
    param = get_param(params, :param, 'usage')

    assert_equal 'param symbol', param
  end

  def test_get_param_not_present
    exception_raised = false
    begin
      get_param({}, :param, 'usage')
    rescue ParameterMissingError => e
      str = '*** Could not find parameter, param, for command, ' \
            "test_get_param_not_present\n*** usage\n*** Try " \
            ":param=>'YourValue'"
      assert_equal e.message, str
      exception_raised = true
    end
    assert_equal true, exception_raised
  end
end
