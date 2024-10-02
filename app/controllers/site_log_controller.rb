class SiteLogController < ApplicationController
    def index
      @date = params[:date] ? Date.parse(params[:date]) : Date.today
      @query = params[:query]
      @log_type = params[:log_type] || 'regular'
      @logs = fetch_logs(@date, @query, @log_type)
    end

    private

    def fetch_logs(date, query, log_type)
      log_file = Rails.root.join('log', log_filename(log_type))
      logs = File.readlines(log_file).slice_when { |before, after| after.start_with?("Started") }

      logs = logs.select do |log_group|
        log_group.any? { |line| line.include?(date.to_s) } &&
          (query.blank? || log_group.any? { |line| line.downcase.include?(query.downcase) })
      end

      logs.map { |log_group| log_group.join }
    end

    def log_filename(log_type)
      case log_type
      when 'error'
        "#{Rails.env}_error.log"
      else
        "#{Rails.env}.log"
      end
    end
  end