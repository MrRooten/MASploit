require 'utils/colors'
class Logger
    attr_accessor :log_level
    LOG_DEBUG = 0
    LOG_INFO  = 1
    LOG_WARNING = 2
    LOG_ERROR = 3
    @@logger = nil
    def initialize
        @log_level = 3
    end

    def _info_init
        @_who_call = caller[1]
        @_who_call.sub! 'in `','$'
        @_who_call.sub! '\'',''

        @_time = Time.new
    end
    def info(str)
        self._info_init
        print(blue("[INF]#{@_time.strftime('%H:%M:%S')} "),grey(@_who_call),":","\n  ####{str}","\n")
    end

    def warning(str)
        self._info_init
        print(purple("[WAR]#{@_time.strftime('%H:%M:%S')} "),grey(@_who_call),":","\n  ####{str}","\n")
    end

    def error(str)
        self._info_init
        print(red("[ERR]#{@_time.strftime('%H:%M:%S')} "),grey(@_who_call),":","\n  ####{str}","\n")
    end

    def debug(str)
        self._info_init
        print(yellow("[DEB]#{@_time.strftime('%H:%M:%S')} "),grey(@_who_call),":","\n  ####{str}","\n")
    end

    def self.get_logger
        if @@logger == nil
            @@logger = Logger.new
        end
        @@logger
    end
end

logger = Logger.new
