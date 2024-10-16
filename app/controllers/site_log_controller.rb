class SiteLogController < ApplicationController
    def index
      @date = params[:date] ? Date.parse(params[:date]) : Date.today
      @query = params[:query]
      @log_type = params[:log_type] || 'regular'
      @time_filter = params[:time_filter] || '1_hour'
      @length_filter = params[:length_filter] || '5'
      @logs = fetch_logs(@date, @query, @log_type, @time_filter, @length_filter.to_i)
    end

    private

    def fetch_logs(date, query, log_type, time_filter, length_filter)
      log_file = Rails.root.join('log', log_filename(log_type))
      start_time = calculate_start_time(date, time_filter)

      logs = []
      File.open(log_file, 'r') do |file|
        file.extend(Enumerable)
        file.reverse_each do |line|
          break if logs.size >= length_filter
          next unless line.start_with?("Started")

          log_time = extract_time(line)
          next unless log_time && log_time >= start_time && line.include?(date.to_s)

          log_group = [line] + read_log_group(file)
          logs.unshift(log_group.join) if log_group_matches?(log_group, query)
        end
      end

      logs
    end

    def read_log_group(file)
      group = []
      until file.eof? || (line = file.readline).start_with?("Started")
        group << line
      end
      file.pos -= line.length if line&.start_with?("Started")
      group
    end

    def log_group_matches?(log_group, query)
      query.blank? || log_group.any? { |line| line.downcase.include?(query.downcase) }
    end

    def log_filename(log_type)
      case log_type
      when 'error'
        "#{Rails.env}_error.log"
      else
        "#{Rails.env}.log"
      end
    end

    def calculate_start_time(date, time_filter)
      case time_filter
      when '1_hour'
        1.hour.ago
      when '6_hours'
        6.hours.ago
      when '12_hours'
        12.hours.ago
      when '24_hours'
        24.hours.ago
      else
        date.beginning_of_day
      end
    end

    def extract_time(log_line)
      timestamp = log_line.match(/(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})/)
      Time.parse(timestamp[1]) if timestamp
    rescue ArgumentError
      nil
    end
  end