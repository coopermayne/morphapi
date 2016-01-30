CarrierWave.configure do |config|

  config.fog_credentials = {
    :provider                   =>"AWS" ,
    :aws_access_key_id          =>"AKIAIAAKWBBSS2G3XS6A",
    :aws_secret_access_key      =>"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",
    :region                     =>"us-west-2"
  }
  config.fog_directory = "morphmorph"

end
