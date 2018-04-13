require "./core/helper/http"
require "json"

module TBotModule
  class Anilist
    def self.search(type, query)
      anilist = TBot::Helper::HTTP::post(
        'https://graphql.anilist.co/',
        'application/json',
        {
          "query" => "query ($q: String){ Page(page:1, perPage: 10){ media(search: $q, type: ANIME){ idMal title {romaji english native} type format status season episodes duration source studios{nodes{name}} genres averageScore description coverImage{large} } } }",
          "variables" => {"q" => query}
        }
      )

      if anilist == false
        return false
      end
      
      data = JSON::parse(anilist)["data"]["Page"]["media"]
      if data == nil || data.empty?
        return false
      end

      answers = []
      data.each do |res|
        answers << {
          "type" => "article",
          "id" => answers.count,
          "title" => res['title']['romaji'],
          "description" => "#{res['type'].capitalize} - #{res['status'] == 'RELEASING' ? "Currently Airing" :  res['status'].capitalize}",
          "thumb_url" => res['coverImage']['large'],
          "hide_url" => true,
          "input_message_content" => {
            "parse_mode" => "html",
            "message_text" =>
               "<b>#{res['title']['native']}</b>\n"\
               "#{"(#{res['title']['romaji']})\n" if res['title']['romaji'] != res['title']['native']}"\
               "<a href=\"#{res['coverImage']['large']}\">&#8205;</a>\n"\
               "<b>Type:</b> #{res['type'].capitalize}\n"\
               "<b>Episodes:</b> #{res['episode'] == nil ? "Unknown" : res['episodes'].to_s}\n"\
               "<b>Duration:</b> #{res['duration'] == nil ? "Unknown" : res['duration'].to_s} Minutes\n"\
               "<b>Status:</b> #{res['status'] == 'RELEASING' ? "Currently Airing" :  res['status'].capitalize}\n"\
               "#{"<b>Source:</b> #{res['source'].split('_').map(&:capitalize).join(' ')}\n" if res['source'] != nil}"\
               "<b>Genre:</b> #{res['genres'].join(', ')}\n"\
               "<b>Studio:</b> #{res['studios']['nodes'].map{|hash| hash['name']}.join(', ')}\n"\
               "<b>Metascore:</b> #{res['averageScore'] == nil ? "Not Yet Rated" : res['averageScore'].to_s}\n\n"\
               "#{"<b>Synopsis:</b> #{res['description'][0..200].gsub(/<("[^"]*"|'[^']*'|[^'">])*>/," ").gsub(/\s\w+$/,"...")}" if res['description'] != nil}"
           },
           "reply_markup" => {"inline_keyboard"=>[[{"text"=>"Check on MyAnimeList", "url"=>"https://myanimelist.net/#{res['type'].downcase}/#{res['idMal']}"}],[{"text"=>"Find Trailer On Youtube", "url"=>"https://www.youtube.com/results?search_query=#{URI.encode(res['title']['romaji']+" PV")}"}]]
          }
        }
      end
      return answers
    end
  end
end
