class SiteLogController < ApplicationController
    def index
      @date = params[:date] ? Date.parse(params[:date]) : Date.today
      @query = params[:query]
      @log_type = params[:log_type] || 'regular'
      @time_filter = params[:time_filter] || '1_hour'
      @length_filter = params[:length_filter] || '50'
      @logs = fetch_logs(@date, @query, @log_type, @time_filter, @length_filter.to_i)
    end

    private

    def fetch_logs(date, query, log_type, time_filter, length_filter)
      log_file = Rails.root.join('log', log_filename(log_type))
      logs = File.readlines(log_file).slice_when { |before, after| after.start_with?("Started") }

      start_time = calculate_start_time(date, time_filter)

      logs = logs.select do |log_group|
        log_time = extract_time(log_group.first)
        log_time && log_time >= start_time &&
          log_group.any? { |line| line.include?(date.to_s) } &&
          (query.blank? || log_group.any? { |line| line.downcase.include?(query.downcase) })
      end

      logs.last(length_filter).map { |log_group| log_group.join }
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