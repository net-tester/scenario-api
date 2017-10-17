# -*- encoding: utf-8 -*-

require 'json'

class CucumberProcess
  @@create_mutex = Mutex.new
  @@execute_mutex = Mutex.new
  @@process_id_counter = 0
  @@processes = {}

  def self.all
    @@processes
  end

  def self.find(id)
    @@processes[id]
  end

  def self.destroy_all
    @@mutex.synchronize do
      @@processes.clear
    end
  end

  def initialize(initial_wait: 1, process_wait: 1)
    @@create_mutex.synchronize do
      @id = @@process_id_counter = @@process_id_counter + 1
      @log_dir = File.join('./log', 'processes', @id.to_s)
      FileUtils.mkdir_p(@log_dir) unless File.exist?(@log_dir)
      @stdout_file = File.join(@log_dir, 'stdout.log')
      @stderr_file = File.join(@log_dir, 'stderr.log')
      @initial_wait = initial_wait
      @process_wait = process_wait
      @stdout = ''
      @stderr = ''
      @status = 'created'
      @@processes[@id] = self
    end
  end

  def id
    @id
  end

  def stdout
    @stdout
  end

  def stderr
    @stderr
  end

  def status
    @status
  end

  def exec(command)
    thread = Thread.start do
      begin
        @status = 'waiting initial wait'
        sleep @initial_wait
        @status = 'waiting mutex'
        @@execute_mutex.synchronize do
          @status = 'running'
          system "bash -c 'env -u BUNDLER_ORIG_PATH -u BUNDLE_BIN_PATH -u BUNDLE_GEMFILE -u BUNDLER_VERSION CUCUMBER_FORMAT=json #{command} 1> #{@stdout_file} 2> #{@stderr_file}'"
        end
        @status = 'waiting process wait'
        sleep @process_wait
        @stdout = File.read(@stdout_file)
        @stderr = File.read(@stderr_file)
      rescue => e
        @stderr = e
      end
      @status = 'finished'
    end
  end

  def to_json
    res = {"id": @id,
           "status": @status,
           "stdout": @stdout,
           "stderr": @stderr
          }
    begin
      if @stdout != ""
        res["result"] = JSON.parse(@stdout)
      end
    rescue => e
      res["result_error"] = e
    end
    res.to_json
  end
end
