require "colorize"
require "logger"

module Gnosis
  extend self

  #de TODO: Allow defaults to be changed by ENV or other means.
  @@log_name = "Gnosis"
  @@humanized = true
  @@use_marks = false
  @@use_filesystem = true

  def log_name=(value)              @@log_name = value          end
  def humanized=(value)             @@humanized = value         end
  def use_marks=(value)             @@use_marks = value         end
  def use_filesystem=(value)        @@use_filesystem = value    end

  TIMESTAMP = "%Y-%m-%d %H:%M:%S.%6N"

  @@file = uninitialized File
  @@writer = uninitialized IO::MultiWriter
  @@logger = uninitialized ::Logger

  @@logger = unless @@use_filesystem
    ::Logger.new(STDOUT)
  else
    Dir.mkdir("logs/") unless Dir.exists?("logs/")
    @@file = File.new("logs/console.log", "a")
    @@writer = IO::MultiWriter.new(@@file, STDOUT)
    ::Logger.new(@@writer)
  end

  @@logger.level = ::Logger::DEBUG
  @@logger.progname = @@log_name

  delegate debug, warn, info, error, to: @@logger

  @@logger.formatter = ::Logger::Formatter.new do |severity, datetime, progname, message, io|
    label = severity.unknown? ? "ANY" : severity.to_s
    arrow = @@humanized ? ">".colorize(:dark_gray).mode(:bold).to_s : ">"
    timestamp = @@humanized ? datetime.to_s(TIMESTAMP).colorize(:dark_gray).to_s : datetime.to_s(TIMESTAMP)
    io << label[0] << ", [" << timestamp  << " #" << Process.pid << "] #{arrow}"
    io << label.rjust(6) << " #{arrow} "
    if progname
      tag = @@humanized ? progname.colorize(:light_yellow).to_s : progname
      io << tag << " #{arrow} "
    end
    io << message
  end

  def mark(*symbols)
    if @@use_marks
      printf("#{symbols.join}")
    end
    nil
  end

  def log(message, tag=nil)
    @@logger.info(message, tag)
    nil
  end

  def fatal(message, tag=nil, kill=true)
    @@logger.fatal(@@humanized ? message.colorize(:red).mode(:bold).to_s : message, tag)
    if kill
      abort
    end
    nil
  end

  {% for color in %w{ red green cyan magenta blue yellow } %}
    def light_{{color.id}}(message)
      (@@humanized) ? message.colorize(:light_{{color.id}}).to_s : message
    end
    def {{color.id}}(message)
      (@@humanized) ? message.colorize(:{{color.id}}).to_s : message
    end
  {% end %}

  def exception(ex, tag=nil)
    #de log "#{ex.class.name.colorize(:red).mode(:bold).to_s}: #{ex.message.colorize(:white).to_s}\n#{ex.backtrace.join('\n')}"
    fatal(ex, tag, false)
    nil
  end

end
