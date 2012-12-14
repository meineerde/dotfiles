require 'fileutils'

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

  desc "Setup SublimeText2"
  task :sublime do
  end

  desc "Sublime Configuration"
  task :sublime_config do
    sublime_path = "#{ENV['HOME']}/Library/Application Support/Sublime Text 2"
    df_dir = File.expand_path("../sublime", __FILE__)

    FileUtils.ln_sf("#{df_dir}/Preferences.sublime-settings", "#{sublime_path}/Packages/User/Preferences.sublime-settings")
  end

  desc "Install SublimeText2 Plugins"
  task :sublime_plugins do
    require 'json'
    package_control = "#{ENV['HOME']}/Library/Application Support/Sublime Text 2/Packages/User/Package Control.sublime-settings"
    packages = JSON.parse(File.read(package_control))

    packages["installed_packages"] = [
      "AdvancedNewFile",
      "CTags",
      "Git",
      "LaTeXTools",
      "SideBarEnhancements",
      "SublimeTODO",
      "Theme - Soda",
      "TODO Control",
      "Tomorrow Color Schemes"
    ]

    File.open(package_control, "w") do |f|
      f.write(JSON.pretty_generate(packages))
    end
  end

  sublime_path = "#{ENV['HOME']}/Library/Application Support/Sublime Text 2"
  if File.exist?(sublime_path)
    task :sublime => :sublime_config
    if File.exist?("#{sublime_path}/Packages/User/Package Control.sublime-settings")
      task :sublime => :sublime_plugins
    end
  end


  task :all => [:texmf, :sublime]
end

