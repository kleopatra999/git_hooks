class PreCommitTestsHook < PreCommitBaseHook
  def run!
    tests.each do |test|
      test.gsub!(/test\//, '')
      output = %x(cd ./test && ruby #{test})
      parse_test_output(output)
    end
  ensure
    true
  end

  def tests
    Dir['./test/**/*_test.rb']
  end

  def parse_test_output(output)
    @messages += output.scan /Failure:\n(.*)$/
  end

  def format_message(msg)
    "Failed test: #{msg}"
  end
end
