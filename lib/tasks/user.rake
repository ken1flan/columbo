namespace :user do
  desc 'userの一覧を表示する'
  task :list => :environment do
    User.all.each do |user|
      puts "#{user.id},#{user.name},#{user.role},#{user.last_sign_in_at}"
    end
  end

  desc '管理者を設定する'
  task :set_admins => :environment do
    ENV["COLUMBO_ADMINS"].split(',').each do |user_id|
      user = User.find(user_id.to_i)
      user.update_attributes(role: 'admin')
      puts "#{user.id},#{user.name},#{user.role},#{user.last_sign_in_at}"
    end
  end

  desc '管理者を設定解除する'
  task :unset_admins => :environment do
    ENV["COLUMBO_ADMINS"].split(',').each do |user_id|
      user = User.find(user_id.to_i)
      user.update_attributes(role: 'member')
      puts "#{user.id},#{user.name},#{user.role},#{user.last_sign_in_at}"
    end
  end
end
