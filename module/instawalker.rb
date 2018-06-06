require "./core/helper/http"
require "json"

module TBotModule
  class InstaWalker
    def self.getFeed(uname)
      if uname.nil? || uname.empty?
        return nil
      end

      feed = TBot::Helper::HTTP::get(
        'https://api.rizkiepratama.net/instawalker/V1.0?user_name=' + uname  +'&post_count=15',
      )
      
      data = JSON::parse(feed)
      if data == nil || data.empty?
        return nil
      end

      answers = []
      data.each do |res|
        answers << {
          "type" => "photo",
          "id" => answers.count,
          "photo_url" => res['display_url'],
          "thumb_url" => res['thumbnail_src'],
          "caption" => res['caption'].nil? || res['caption']['text'].nil? ? "" : res['caption']['text'][0..180].gsub(/<("[^"]*"|'[^']*'|[^'">])*>/," ").gsub(/\s\w+$/,"..."),
          "reply_markup" => {
            "inline_keyboard"=>[[{"text"=>"Check on Instagram", "url"=>res['link']}]]
          }
        }
      end
      return answers
    end
  end
end
