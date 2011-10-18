class PreCommitSpecsHook < PreCommitBaseHook
  def run!
    unless rspec_installed?
      messages << "RSpec is not install. To install it run `gem install rspec`"   
      return true
    end
    require 'nokogiri'
    html = %x(#{rspec_command})
    parse_html(html)
  rescue LoadError
    messages << "Specs hook requires nokogiri. To install it run `gem install nokogiri`"
  ensure
    #FileUtils.rm output_file
    true
  end

  def rspec_installed?
    system "which rspec > /dev/null"
  end

  def format_message(msg)
    "Failed spec: #{msg}"
  end

  def rspec_command
    files = Dir['./spec/**/*_spec.rb'].join(" ")
    "rspec --format=html #{files}"
  end

  def parse_html(html)
    doc = Nokogiri::HTML(html)
    doc.css('div.rspec-report div.results div.example_group').each do |group|
      group_name = group.css('dt').first.text
      group.css('dl dd.example span.failed_spec_name').each do |example|
        messages << "#{group_name} #{example.text}"	
      end
    end
  end
end
