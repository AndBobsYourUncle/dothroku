def do_task(name)
  puts '#' * 80
  puts "## #{name}"
  puts '#' * 80
  Rake::Task[name].invoke
  puts
end

namespace :db do

  desc 'Remigrate (aka. `db:{drop,create,migrate}`)'
  task remigrate: [:environment] do
    do_task('db:drop')
    do_task('db:create')
    do_task('db:migrate')
  end

end
