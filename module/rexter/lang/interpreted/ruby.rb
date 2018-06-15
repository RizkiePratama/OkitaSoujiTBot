require_relative '../base'
require 'open3'

module RexterLang
  class Ruby < Interpreted
    def run
      stdout, stderr, status = Open3.capture3("ruby #{@source_file}")
      return status.success? ? [stdout, stderr] : false
    end
  end
end
