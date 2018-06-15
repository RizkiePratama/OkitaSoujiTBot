require_relative '../base'
require 'open3'

module RexterLang
  class Javascript < Interpreted
    def run
      stdout, stderr, status = Open3.capture3("node #{@source_file}")
      return status.success? ? [stdout, stderr] : false
    end
  end
end
