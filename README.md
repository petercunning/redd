<div align="center">
  <a href="https://badge.fury.io/rb/redd">
    <img src="https://badge.fury.io/rb/redd.svg" alt="Gem Version" height="18">
  </a>
  <a href="https://travis-ci.org/avinashbot/redd">
    <img src="https://travis-ci.org/avinashbot/redd.svg?branch=master" alt="Build Status">
  </a>
  <a href="https://gemnasium.com/github.com/avinashbot/redd">
    <img src="https://gemnasium.com/badges/github.com/avinashbot/redd.svg" alt="Dependency Status">
  </a>
  <a href="https://coveralls.io/github/avinashbot/redd?branch=master"><img src="https://coveralls.io/repos/github/avinashbot/redd/badge.svg?branch=master" alt="Coverage Status"></a>
</div>

    include Redd.bot
    every_message do |message|
      puts 'Ding ding! New Message!', message
    end
