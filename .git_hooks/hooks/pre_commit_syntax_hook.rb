class PreCommitSyntaxHook < PreCommitBaseHook
  def run!
    ruby_regexp = Regexp.new(config['syntax']['ruby'])
    ignore_regexp = Regexp.new(config['syntax']['ignore'])
    changed_files.each do |file|
      if file =~ ruby_regexp && file !~ ignore_regexp
        output = %x(ruby -c #{file} 2>&1)
        messages << output if $? != 0
      end
    end
    messages.empty?
  end
end
