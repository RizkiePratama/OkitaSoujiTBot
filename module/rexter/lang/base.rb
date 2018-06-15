require 'fileutils'

module RexterLang
  class LangBase
    attr_accessor :source_file
    def initialize(source,extension)
      @file_name = "#{(0...50).map { ('a'..'z').to_a[rand(26)] }.join}.#{extension}"
      @source_file = ".storage/" + @file_name
      @binary_file = ".storage/bin/" + @file_name

      dirname = File.dirname(@source_file)
      unless File.directory?(dirname)
        FileUtils.mkdir_p(dirname)
      end

      dirname = File.dirname(@binary_file)
      unless File.directory?(dirname)
        FileUtils.mkdir_p(dirname)
      end

      file = open(@source_file,'w')
      file.write(source)
      file.close
    end
  end

  class Compiled < LangBase
  end

  class Interpreted < LangBase
  end
end
