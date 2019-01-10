require 'rake/clean'

task(:test) { }

def source_version
  File.read(File.expand_path("../VERSION", __FILE__)).strip
end

if defined?(Gem)
  GEMS_AND_ROOT_DIRECTORIES = {
    "sandbox-sinatra" => ".",
  }

  def package(gem, ext='')
    "pkg/#{gem}-#{source_version}" + ext
  end


  directory 'pkg/'
  CLOBBER.include('pkg')

  GEMS_AND_ROOT_DIRECTORIES.each do |gem, directory|
    file package(gem, '.gem') => ["pkg/", "#{directory + '/' + gem}.gemspec"] do |f|
      sh "cd #{directory} && gem build #{gem}.gemspec"
      mv directory + "/" + File.basename(f.name), f.name
    end

    file package(gem, '.tar.gz') => ["pkg/"] do |f|
      sh <<-SH
        git archive \
          --prefix=#{gem}-#{source_version}/ \
          --format=tar \
          HEAD -- #{directory} | gzip > #{f.name}
      SH
    end
  end

  namespace :package do
    GEMS_AND_ROOT_DIRECTORIES.each do |gem, directory|
      desc "Build #{gem} packages"
      task gem => %w[.gem .tar.gz].map { |e| package(gem, e) }
    end

    desc "Build all packages"
    task all: GEMS_AND_ROOT_DIRECTORIES.keys
  end

  namespace :install do
    GEMS_AND_ROOT_DIRECTORIES.each do |gem, directory|
      desc "Build and install #{gem} as local gem"
      task gem => package(gem, '.gem') do
        sh "gem install #{package(gem, '.gem')}"
      end
    end

    desc "Build and install all of the gems as local gems"
    task all: GEMS_AND_ROOT_DIRECTORIES.keys
  end

  namespace :release do
    GEMS_AND_ROOT_DIRECTORIES.each do |gem, directory|
      desc "Release #{gem} as a package"
      task gem => "package:#{gem}" do
        sh <<-SH
          gem install #{package(gem, '.gem')} --local &&
          gem push #{package(gem, '.gem')}
        SH
      end
    end

    desc "Prepares for the patch release"
    task :travis do
      load "ci/release.rb"
      sh <<-SH
        echo -e "---\n:rubygems_api_key: #{ENV['RUBYGEMS_API_KEY']}" > ~/.gem/credentials
        cat ~/.gem/credentials
        chmod 0600 ~/.gem/credentials
        sed -i "s/.*VERSION.*/  VERSION = '#{source_version}'/" lib/sandbox/version.rb
      SH
    end

    desc "Commits the version to github repository"
    task :commit_version do
      sh <<-SH
        sed -i "s/.*VERSION.*/  VERSION = '#{source_version}'/" lib/sandbox/version.rb
      SH

      sh <<-SH
        git commit --allow-empty -a -m '#{source_version} release'  &&
        git tag -#{ENV['TRAVIS'] ? ?a : ?s}a v#{source_version} -m '#{source_version} release'  &&
        git push && (git push origin || true) &&
        git push --tags && (git push origin --tags || true)
      SH
    end

    desc "Release all gems as packages"
    task all: [:test, :commit_version] + GEMS_AND_ROOT_DIRECTORIES.keys
  end
end
