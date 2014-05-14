require 'fileutils'

desc "installs everything"
task :install => "install:all"
namespace :install do

  def files(name, *files)
    desc "installs #{name} configuration"
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
  files :dot, *%w[.bash_profile .bashrc .gemrc .gitignore_global .gitconfig .ackrc .rvmrc.dotfile]
  files :bin, "bin/*"

  files :vim, *%w[.vim .vimrc]
  task :vim => [:dot, :bin, :submodules]

  desc "Update all submodules"
  task :submodules do
    sh "git submodule update --init"
  end
end
