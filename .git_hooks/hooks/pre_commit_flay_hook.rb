class PreCommitFlayHook < PreCommitBaseHook
  def run!
    require 'flay'
    flay = Flay.new
    flay.process(*ruby_files)

    # hack to get flay output
    stdout = $stdout
    flay_io = StringIO.new
    $stdout = flay_io
    # print flay output to flay_io instead of stdout
    flay.report
    $stdout = stdout

    @messages << flay_io.string.split("\n").reject{|l| l =~ /^Total score|^\s*$/}.join("\n")
  rescue LoadError
    @messages << "Flay is not installed. Please run `gem install flay`"
  ensure
    return true
  end
end
