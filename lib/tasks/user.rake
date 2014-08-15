namespace :user do
  desc "userの一覧を表示する"
  task :list => :environment do
    User.all.each do |user|
      puts "#{user.id},#{user.name}"
    end
  end
end
