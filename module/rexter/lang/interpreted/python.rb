require_relative '../base'
require 'open3'

module RexterLang
  class Python < Interpreted
    def run
      stdout, stderr, status = Open3.capture3("python3.6 #{@source_file}")
      return status.success? ? [stdout, stderr] : false
    end
  end
end
