class PreCommitBaseHook
  attr_reader :messages, :repo, :tmp_repo, :config

  def initialize(repo, tmp_repo, config)
    @repo, @tmp_repo, @config = repo, tmp_repo, config
    @messages = []
  end

  def run!
    raise "#{self.class}#run!: implement me"
  end

  def need_tmp_repo?
    false
  end

  def ruby_files
    changed_files.find_all {|f| f =~ /\.rb$/ }
  end
  
  def changed_files
    @changed_files ||= %x(git diff --cached --name-only).split("\n")
  end
end
