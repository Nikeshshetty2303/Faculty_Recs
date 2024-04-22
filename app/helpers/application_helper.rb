module ApplicationHelper
    def display_content(content)
      if content.is_a?(Array)
        content.map { |c| c.gsub(/[\[\]\"]/,"") }.join(', ')
      else
        content.gsub(/[\[\]\"]/,"")
      end
    end
  end
  