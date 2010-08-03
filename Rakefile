desc "installs everything"
task :install => "install:all"
namespace :install do

  def install name, *files
    desc "installs #{name} configuration"
    task(name) do
      Dir[*files].collect do |file|
        full = File.join Dir.pwd, file
        Dir.chdir ENV["HOME"] do
          mkdir_p File.dirname(file) 
	  sh "rm #{file}" if (File.exist? file and File.directory? full)
          sh "ln -sf #{full} #{file}"
        end
      end
    end
    task :all => name
  end

  install :irb, ".irbrc", ".config/irb/*.rb"
  install :dot, ".bash_profile", ".bashrc", ".gemrc", ".vimrc", ".vim", ".gitignore", ".gitconfig"
  install :bin, "bin/*"

  desc "installs the custom texmf folder"
  task :texmf do
    system "git submodule init && git submodule update"
    install :texmf_folder, "texmf"
    Rake::Task[:texmf_folder].invoke
  end

  task :all => :texmf
end

