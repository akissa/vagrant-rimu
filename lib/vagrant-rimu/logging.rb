module VagrantPlugins
  module Rimu
    module Logging
      def self.init
        level = nil
        begin
          level = Log4r.const_get(ENV['VAGRANT_LOG'].upcase)
        rescue NameError
          begin
            level = Log4r.const_get(ENV['VAGRANT_RIMU_LOG'].upcase)
          rescue NameError
            level = nil
          end
        end

        level = nil unless level.is_a?(Integer)

        if level
          logger = Log4r::Logger.new('vagrant_rimu')
          out = Log4r::Outputter.stdout
          out.formatter = Log4r::PatternFormatter.new(pattern: '%d | %5l | %m', date_pattern: '%Y-%m-%d %H:%M')
          logger.outputters = out
          logger.level = level
        end
      end
    end
  end
end
