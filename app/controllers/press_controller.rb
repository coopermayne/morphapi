class PressController < ApplicationController
  def create

    input = params['email']
    unless input =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
      render json: {error: 'bad email'}
      return
    end

    email = Journalist.find_by_email(input)

    unless email
      res = Journalist.create(email: input)
      render json: {success: 'true'}
    else
      render json: {success: 'true'}
    end

  end
end
