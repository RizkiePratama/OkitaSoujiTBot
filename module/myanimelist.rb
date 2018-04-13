require 'xmlsimple'
require 'uri'
require './core/helper/http'
require 'jikan.rb'

module TBotModule
  class MyAnimeList
    def self.search(type,keyword)
      xml = TBot::Helper::HTTP::get(
        "https://myanimelist.net/api/#{type}/search.xml?q=#{URI.encode(keyword)}",
        Config.module.myanimelist.auth_user,
        Config.module.myanimelist.auth_pass
      )

      if xml == false
        return false
      else
        parsed = XmlSimple.xml_in(xml)
        answers = []
        parsed['entry'].each do |entry|
          case type
          when'anime'
            jikan = Jikan::anime entry['id'][0]
          when'manga'
            jikan = Jikan::manga entry['id'][0]
          else
            jikan = false
          end

          if jikan == false then return false end

          studio_info = ""
          jikan.raw['studio'].each_with_index do |studio, i|
            studio_info = "<a href='#{studio['url']}'>#{studio['name']}</a>"
            if i < jikan.raw['studio'].count - 1
              studio_info << ", "
            end
          end

          answers << {
            "type" => "article",
            "id" => answers.count,
            "title" => entry['title'][0],
            "description" => "#{entry['type'][0]} - #{entry['status'][0]}",
            "thumb_url" => entry['image'][0],
            "hide_url" => true,
            "input_message_content" => {
              "parse_mode" => "html",
              "message_text" =>
                "<b>#{jikan.raw['title']}</b>#{if !jikan.raw['title_english'].nil? && jikan.raw['title_english'] != jikan.raw['title'] then "\n(#{jikan.raw['title_english']})" end }\n<a href=\"#{jikan.raw['image_url']}\">&#8205;</a>\n<b>Type:</b> #{entry['type'][0]}\n<b>Episodes:</b> #{entry['episodes'][0]}\n<b>Status:</b> #{jikan.raw['status']}\n<b>Source:</b> #{jikan.raw['source']}\n<b>Studio:</b> #{studio_info}\n<b>Rating:</b> #{jikan.raw['rating']}\n<b>Metascore:</b> #{entry['score'][0]}\n\n<b>Synopsis:</b> #{jikan.raw['synopsis'].to_s[0..200].gsub(/\s\w+$/,"...").gsub(/<("[^"]*"|'[^']*'|[^'">])*>/," ")}"
            },
            "reply_markup" => {"inline_keyboard"=>[[{"text"=>"Check on MyAnimeList", "url"=>"#{jikan.raw['link_canonical']}"}],[{"text"=>"Find Trailer On Youtube", "url"=>"https://www.youtube.com/results?search_query=#{URI.encode(jikan.raw['title']+" PV")}"}]]}
          }
        end
        return answers
      end
    end
  end
end
