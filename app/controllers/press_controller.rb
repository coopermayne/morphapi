class PressController < ApplicationController
  def create

    email_input = params['email']

    first_name_input = params['first']
    last_name_input = params['last']
    affiliation_input = params['affiliation']

    #return with error if email is bad
    unless email_input =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
      render json: {error: 'bad email'}
      return
    end

    def scan_input(input)
      input =~ /[^a-zA-Z\s\d\-]/
    end

    first_name = scan_input(first_name_input) ? "" : first_name_input
    last_name = scan_input(last_name_input) ? "" : last_name_input
    affiliation = scan_input(affiliation_input) ? "" : affiliation_input

    journalist = Journalist.find_by_email(email_input)

    unless journalist
      res = Journalist.create(email: email_input, first_name: first_name, last_name: last_name, affiliation: affiliation)
      render json: {success: 'true'}
		else
			render json: {error: 'user is already in list'}
    end

  end
end
