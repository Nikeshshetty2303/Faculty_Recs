class RefereeMailer < ApplicationMailer
  def referee
    @user = User.find(params[:user_id])
    @can_name = Answer.find(params[:can_name_id])
    @name = Answer.find(params[:ref_name_id])
    @email = Answer.find(params[:ref_email_id])
    @ph_no = Answer.find(params[:ref_ph_no_id])
    @aff = Answer.find(params[:ref_aff_id])
    if params[:correct_email].present?
      formatted_email = format_email(params[:correct_email])
    else
      formatted_email = format_email(@email.content)
    end
    mail(
      from: "facrecruit@nitk.edu.in",
      to: formatted_email,
      subject: "Letter of Reference"
    )
  end

  def format_email(email)
    # Split the email string by comma, semicolon, or forward slash to handle multiple email addresses
    email_addresses = email.split(/[,;\/]/)

    # Process each email address
    formatted_emails = email_addresses.map do |single_email|
      # Remove leading/trailing whitespace
      cleaned_email = single_email.strip

      # Remove any extra spaces within the email
      cleaned_email = cleaned_email.gsub(/\s+/, '')

      # Ensure there's only one @ symbol
      cleaned_email = cleaned_email.gsub(/@+/, '@')

      # Remove any characters that aren't typically allowed in email addresses
      cleaned_email = cleaned_email.gsub(/[^a-zA-Z0-9.@_+-]/, '')

      cleaned_email
    end

    # Filter out any empty strings and select the first valid email address
    first_valid_email = formatted_emails.reject(&:empty?).second

    # Return the first valid email address or an empty string if none are valid
    first_valid_email || ''
  end
end