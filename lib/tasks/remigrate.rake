desc "Drop, create, then migrate the dev db"
task :remigrate do
  system "mysql -u root  -D mysql -e 'drop database if exists mockr_development'"
  system "mysql -u root -D mysql -e 'create database mockr_development'"
  Rake::Task['db:migrate'].invoke
end
