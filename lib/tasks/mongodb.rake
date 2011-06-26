namespace :db do
  namespace :mongo do
    desc 'Starts MongoDB server'
    task :start do
      exec 'mongod --dbpath db'
    end
  end
end
