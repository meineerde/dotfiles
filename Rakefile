require 'fileutils'

task :update => "update:submodules"
namespace :update do
  desc "Update all submodules"
  task :submodules do
    sh "git submodule update --init"
  end
end

desc "Install everything"
task :install => "update"
task :install => "install:all"
namespace :install do
  def files(name, *files)
    desc "Install #{name} configuration"
    task(name) do
      Dir[*files].collect do |file|
        full = File.join File.dirname(__FILE__), file.sub(/\.dotfile$/,'')
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

  dot_files = %w[bin]
  dot_files += %w[.bash_profile .bashrc .gemrc .gitignore_global .ackrc .rvmrc.dotfile]
  dot_files += %w[.gitconfig .gitconfig_holgerjust.de .gitconfig_plan.io]
  files :dot, *dot_files

  files :vim, *%w[.vim .vimrc]
end
