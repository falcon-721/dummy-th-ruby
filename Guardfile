scope groups: ['specs']

group 'specs' do
  guard :rspec, cmd: "bundle exec spring rspec" do
    require "guard/rspec/dsl"
    dsl = Guard::RSpec::Dsl.new(self)

    # Feel free to open issues for suggestions and improvements

    # RSpec files
    rspec = dsl.rspec
    watch(rspec.spec_helper) { rspec.spec_dir }
    watch(rspec.spec_support) { rspec.spec_dir }
    watch(rspec.spec_files)

    # Ruby files
    ruby = dsl.ruby
    dsl.watch_spec_files_for(ruby.lib_files)

    # Rails files
    rails = dsl.rails(view_extensions: %w(erb slim))
    dsl.watch_spec_files_for(rails.app_files)
    dsl.watch_spec_files_for(rails.views)

    watch(rails.controllers) { |m| rspec.spec.("controllers/#{m[1]}_controller") }

    # Rails config changes
    watch(rails.spec_helper)     { rspec.spec_dir }
    watch(rails.routes)          { "#{rspec.spec_dir}/controllers" }
    watch(rails.app_controller)  { "#{rspec.spec_dir}/controllers" }
  end

  guard :bundler do
    require 'guard/bundler'
    require 'guard/bundler/verify'
    helper = Guard::Bundler::Verify.new

    files = ['Gemfile']
    files += Dir['*.gemspec'] if files.any? { |f| helper.uses_gemspec?(f) }

    # Assume files are symlinked from somewhere
    files.each { |file| watch(helper.real_path(file)) }
  end

  guard 'spring', bundler: true do
    watch('Gemfile.lock')
    watch(%r{^config/})
    watch(%r{^spec/(support|factories)/})
  end
end

group 'server' do
  guard 'rails' do
    watch('Gemfile.lock')
    watch(%r{^(config|lib)/.*})
  end
end

guard :shell do
  watch(%r{(tmp\/capybara_output/.*\.png$)}) { |m| `subl #{m[1]}` }
end
