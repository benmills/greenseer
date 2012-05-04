def rebar(args, skip_deps=true)
  args = args.to_s + " skip_deps=true" if skip_deps
  sh "./rebar #{args}"
end

desc "Compile the project"
task :compile do
  rebar :compile
end

desc "Run development console"
task :console do
  sh "erl -pa ebin deps/*/ebin -s greenseer_app"
end
