require File.dirname(__FILE__) + '/abstract_unit'
require 'stringio'

class CleanLoggerTest < Test::Unit::TestCase
  def setup
    @out = StringIO.new
    @logger = Logger.new(@out)
  end

  def test_format_message
    @logger.error 'error'
    assert_equal "error\n", @out.string
  end

  def test_silence
    # Without yielding self.
    @logger.silence do
      @logger.debug  'debug'
      @logger.info   'info'
      @logger.warn   'warn'
      @logger.error  'error'
      @logger.fatal  'fatal'
    end

    # Yielding self.
    @logger.silence do |logger|
      logger.debug  'debug'
      logger.info   'info'
      logger.warn   'warn'
      logger.error  'error'
      logger.fatal  'fatal'
    end

    # Silencer off.
    Logger.silencer = false
    @logger.silence do |logger|
      logger.warn   'unsilenced'
    end
    Logger.silencer = true

    assert_equal "error\nfatal\nerror\nfatal\nunsilenced\n", @out.string
  end
  
  def test_datetime_format
    @logger.formatter = Logger::Formatter.new
    @logger.datetime_format = "%Y-%m-%d"
    @logger.debug 'debug'
    assert_match(/D, \[\d\d\d\d-\d\d-\d\d#\d+\] DEBUG -- : debug/, @out.string)
  end
end
