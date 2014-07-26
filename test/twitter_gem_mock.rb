module Twitter
  module REST
    class Client
      alias :search_org :search

      def self.set_return_tweets(tweets)
        @@return_tweets = tweets
      end

      def search(arg)
        @@return_tweets
      end
    end
  end
end
