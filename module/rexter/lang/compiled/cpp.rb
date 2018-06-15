require_relative '../base'
require 'open3'

module RexterLang
  class CPP < Compiled
    def compile
      stdout, stderr, status = Open3.capture3("g++ #{@source_file} -o #{@binary_file}")
      return status.success? ? true : [stdout, stderr]
    end

    def run
      stdout, stderr, status = Open3.capture3("#{@binary_file}")
      return status.success? ? [stdout, stderr] : false
    end
  end
end
