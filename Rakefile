desc "installs everything"
task :install => "install:all"
namespace :install do

  def files(name, *files)
    desc "installs #{name} configuration"
    task(name) do
      Dir[*files].collect do |file|
        full = File.join File.dirname(__FILE__), file
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
  files :dot, *%w(.bash_profile .bashrc .gemrc .global_gitignore .gitconfig .ackrc .rvmrc)
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

  task :all => [:texmf]
end

