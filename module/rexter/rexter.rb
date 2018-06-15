require "./core/helper/http"
require "json"

require_relative 'lang/compiled/cpp'

require_relative 'lang/interpreted/ruby'
require_relative 'lang/interpreted/python'
require_relative 'lang/interpreted/javascript'

module TBotModule
  class Rexter
    def self.build_and_run(lang, source)
      if lang == 'cpp'
        lang = "c++"
        prog = RexterLang::CPP.new(source, "cpp")
        compile = prog.compile
        compile == true ? output = prog.run[0] : output = compile[1]
      elsif lang == "ruby"
        prog = RexterLang::Ruby.new(source, "rb")
        output = prog.run[0]
      elsif lang == "python"
        prog = RexterLang::Python.new(source, "py")
        output = prog.run[0]
      elsif lang == "js"
        lang = "javascript"
        prog = RexterLang::Javascript.new(source, "js")
        output = prog.run[0]
      else
        return false
      end 

      answer = {
        "type" => "article",
        "id" => 0,
        "title" => "Rexter #{lang.capitalize}",
        "description" => "Click To See Compilation Result...",
        "input_message_content" => { "message_text" => "*Language:*\n#{lang.capitalize}\n\n*Source:*```#{lang} #{source}```\n\n*Result Is:*```output #{output}```", "parse_mode" => "markdown"},
      }
      return [answer]
    end
  end
end
