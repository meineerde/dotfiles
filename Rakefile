require 'fileutils'

desc "installs everything"
task :install => "install:all"
namespace :install do

  def files(name, *files)
    desc "installs #{name} configuration"
    task(name) do
      Dir[*files].collect do |file|
        full = File.join File.dirname(__FILE__), File.basename(file, '.dotfile')
        Dir.chdir ENV["HOME"] do
          mkdir_p File.dirname(file)
          File.delete(file) if (File.exist? file and File.directory? full)
          sh "ln -sf #{full} #{file}"
        end
      end
    end
    task :all => name
  end

  files :irb, ".irbrc", ".config/irb/*.rb"
  files :dot, *%w(.bash_profile .bashrc .gemrc .gitignore_global .gitconfig .ackrc .rvmrc.dotfile)
  files :bin, "bin/*"

  desc "Update all submodules"
  task :submodules do
    system "git submodule init && git submodule update"
  end

  desc "installs the custom texmf folder"
  task :texmf => :submodules do
    files :texmf_folder, "texmf"
    Rake::Task[:texmf_folder].invoke
  end

  desc "Setup SublimeText2"
  task :sublime do
  end

  desc "Sublime Configuration"
  task :sublime_config do
    sublime_path = "#{ENV['HOME']}/Library/Application Support/Sublime Text 2"
    df_dir = File.expand_path("../sublime", __FILE__)

    FileUtils.ln_sf(df_dir, "#{sublime_path}/Packages/User") if File.exist?(sublime_path)
  end
  task :sublime => :sublime_config

  task :all => [:texmf, :sublime]
end

