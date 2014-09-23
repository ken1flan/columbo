namespace :statistics do
  desc "キーワード別ピックアップツイート数を合計する"
  task :pickup_tweets_per_day => :environment do
    PickupKeyword.all.each do |pickup_keyword|
      PickupTweetsPerDay.take_statistics(pickup_keyword)
    end
  end
end
