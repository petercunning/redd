    include Redd.bot
    every_message do |message|
      puts 'Ding ding! New Message!', message
    end
