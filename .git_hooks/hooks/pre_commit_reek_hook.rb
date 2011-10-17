class PreCommitReekHook < PreCommitBaseHook
  def run!
    require 'reek'
    examiner = Reek::Examiner.new(ruby_files)
    examiner.smells.each do |smell|
      @messages << "#{smell.source}:#{smell.lines.first} #{smell.context} #{smell.message} (#{smell.smell_class})"
    end
  rescue LoadError
    @messages << "Reek is not installed. Please run `gem install reek`"
  ensure
    return true
  end
end
