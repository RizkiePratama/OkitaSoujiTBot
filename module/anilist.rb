require "./core/helper/http"
require "json"

module TBotModule
  class Anilist
    def self.search_media(type, query, needs)
      anilist = TBot::Helper::HTTP::post(
        'https://graphql.anilist.co/',
        'application/json',
        {
          "query" => "query ($q: String){ Page(page:1, perPage: 10){ media(search: $q, type: #{type.upcase}){ #{needs} } } }",
          "variables" => {"q" => query.downcase}
        }
      )

      if anilist == false
        return false
      end
      
      data = JSON::parse(anilist)["data"]["Page"]["media"]
      if data.nil? || data.empty?
        return false
      end

      return data
    end

    def self.do_anime(query)
      needs = [
        "idMal",
        "title{romaji english native}",
        "type",
        "format",
        "status",
        "season",
        "episodes",
        "duration",
        "volumes",
        "chapters",
        "source",
        "studios{nodes{name}}",
        "genres",
        "averageScore",
        "description",
        "coverImage{large}",
        "bannerImage",
      ]

      data = search_media "anime", query, needs.join(" ")
      if data == false
        return false
      end

      answers = []
      data.each do |res|
        answers << {
          "type" => "article",
          "id" => answers.count,
          "title" => res['title']['romaji'],
          "description" => "#{res['format'] + " " + res['type'].capitalize} - #{res['status'] == 'RELEASING' ? "Currently Airing" :  res['status'].capitalize}",
          "thumb_url" => res['coverImage']['large'],
          "hide_url" => true,
          "input_message_content" => {
            "parse_mode" => "html",
            "message_text" =>
               "<b>#{res['title']['native']}</b>\n"\
               "#{"(#{res['title']['romaji']})\n" if res['title']['romaji'] != res['title']['native']}"\
               "<a href=\"#{!res['bannerImage'].nil? ? res['bannerImage'] : res['coverImage']['large']}\">&#8205;</a>\n"\
               "<b>Type:</b> #{res['type'].capitalize}\n"\
               "<b>Format:</b> #{res['format'].downcase == 'tv' ? 'TV' : res['format'].capitalize}\n"\
               "<b>Episodes:</b> #{res['episodes'].nil? ? "Unknown" : res['episodes'].to_s}\n"\
               "<b>Duration:</b> #{res['duration'].nil? ? "Unknown" : res['duration'].to_s} Minutes\n"\
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

    def self.do_manga(query)
      needs = [
        "idMal",
        "title{romaji english native}",
        "type",
        "format",
        "status",
        "volumes",
        "chapters",
        "source",
        "genres",
        "averageScore",
        "description",
        "coverImage{large}",
        "bannerImage",
      ]

      data = search_media "manga", query, needs.join(" ")
      if data == false
        return false
      end

      answers = []
      p data
      data.each do |res|
        answers << {
          "type" => "article",
          "id" => answers.count,
          "title" => res['title']['romaji'],
          "description" => "#{res['format'].capitalize} - #{res['status'] == 'RELEASING' ? "Publishing" :  res['status'].capitalize}",
          "thumb_url" => res['coverImage']['large'],
          "hide_url" => true,
          "input_message_content" => {
            "parse_mode" => "html",
            "message_text" =>
               "<b>#{res['title']['native']}</b>\n"\
               "#{"(#{res['title']['romaji']})\n" if res['title']['romaji'] != res['title']['native']}"\
               "<a href=\"#{!res['bannerImage'].nil? ? res['bannerImage'] : res['coverImage']['large']}\">&#8205;</a>\n"\
               "<b>Type:</b> #{res['format'].capitalize}\n"\
               "<b>Volumes:</b> #{res['volumes'].nil? ? "Unknown" : res['volumes'].to_s}\n"\
               "<b>Chapters:</b> #{res['chapters'].nil? ? "Unknown" : res['chapters'].to_s}\n"\
               "<b>Status:</b> #{res['status'] == 'RELEASING' ? "Publishing" :  res['status'].capitalize}\n"\
               "#{"<b>Source:</b> #{res['source'].split('_').map(&:capitalize).join(' ')}\n" if res['source'] != nil}"\
               "<b>Genre:</b> #{res['genres'].join(', ')}\n"\
               "<b>Metascore:</b> #{res['averageScore'] == nil ? "Not Yet Rated" : res['averageScore'].to_s}\n\n"\
               "#{"<b>Synopsis:</b> #{res['description'][0..200].gsub(/<("[^"]*"|'[^']*'|[^'">])*>/," ").gsub(/\s\w+$/,"...")}" if res['description'] != nil}"
           },
           "reply_markup" => {"inline_keyboard"=>[[{"text"=>"Check on MyAnimeList", "url"=>"https://myanimelist.net/#{res['type'].downcase}/#{res['idMal']}"}]]}
        }
      end
      return answers
    end

    def self.do_character(query)
      anilist = TBot::Helper::HTTP::post(
        'https://graphql.anilist.co/',
        'application/json',
        {
          "query" => "query ($q: String){ Page(page:1, perPage: 10){ characters(search: $q){ name{first,last,native} image{large} description } } }",
          "variables" => {"q" => query.downcase}
        }
      )

      if anilist == false
        return false
      end
      data = JSON::parse(anilist)["data"]["Page"]["characters"]
      if data.nil? || data.empty?
        return false
      end

      answers = []
      data.each do |res|
        answers << {
          "type" => "article",
          "id" => answers.count,
          "title" => "#{res['name']['last']} #{res['name']['first']}",
          "thumb_url" => res['image']['large'],
          "hide_url" => true,
          "input_message_content" => {
            "parse_mode" => "html",
            "message_text" =>
               "<a href=\"#{res['image']['large']}\">&#8205;</a>"\
               "<b>#{res['name']['native']}</b>\n"\
               "#{res['name']['last']} #{res['name']['first']}\n\n"\
               "#{"#{res['description'][0..200].gsub(/<("[^"]*"|'[^']*'|[^'">])*>/," ").gsub(/\s\w+$/,"...")}" if res['description'] != nil}"
           },
        }
      end
      return answers
    end
  end
end
