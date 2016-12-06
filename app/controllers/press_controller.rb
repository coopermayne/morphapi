class PressController < ApplicationController
  def create

    emailInput = params['email']

    firstNameInput = params['first']
    lastNameInput = params['last']
    affiliationInput = params['affilliation']

    #return with error if email is bad
    unless emailInput =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
      render json: {error: 'bad email'}
      return
    end

    def scanInput(input)
      input =~ /[^a-zA-Z\s]/
    end

    firstName = scanInput(firstNameInput) ? "" : firstNameInput
    lastName = scanInput(lastNameInput) ? "" : lastNameInput
    affiliationInput = scanInput(affiliationInput) ? "" : affiliationInput

    journalist = Journalist.find_by_email(emailInput)

    unless email
      res = Journalist.create(email: emailInput, first_name: firstName, last_name: lastName, affilliation: affilliation)
      render json: {success: 'true'}
    else
      render json: {success: 'true'}
    end

  end
end
