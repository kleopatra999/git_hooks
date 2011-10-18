require 'tmpdir'
require 'fileutils'
require 'rubygems'

require 'pre_commit_base_hook'
require 'pre_commit_docs_hook'
require 'pre_commit_syntax_hook'
require 'pre_commit_flay_hook'
require 'pre_commit_flog_hook'
require 'pre_commit_reek_hook'
require 'pre_commit_roodi_hook'
require 'pre_commit_saikuro_hook'
require 'pre_commit_specs_hook'


class PreCommitHook
  attr_reader :success

  def initialize(repo, config)
    @repo, @config = repo, config
    @hooks, @messages = [], []
    hooks_config = @config['hooks'] && @config['hooks']['pre-commit']
    hooks_config.each do |key, value|
      klass_name = "PreCommit#{key.capitalize}Hook"
      if value
        klass = Object.const_get(klass_name)
        @hooks << klass.new(@repo, tmp_repo, @config)
      end
    end
  end

  def run!
    @success = true
    create_tmp_repo! if need_tmp_repo?

    hide_stderr do
      @hooks.each do |hook| 
        @success &&= hook.run! 
        @messages += hook.formatted_messages
      end
    end

    remove_tmp_repo! if need_tmp_repo?
    puts @messages
  end

  def need_tmp_repo?
    @hooks.any?{|h| h.need_tmp_repo?}
  end

  def create_tmp_repo!
    remove_tmp_repo!
    FileUtils.cp_r(@repo, tmp_repo)
    system "cd #{tmp_repo} && git reset --hard HEAD > /dev/null"
  end

  def remove_tmp_repo!
    FileUtils.rm_rf(tmp_repo)
  end

  def tmp_repo
    @tmp_repo ||= File.join(Dir.tmpdir, 'git_hooks_tmp_repo')
  end

  # some gems prints warning messages, which shouldn't be displayed
  def hide_stderr
    stderr = $stderr
    $stderr = StringIO.new
    yield
  ensure
    $stderr = stderr
  end
end
