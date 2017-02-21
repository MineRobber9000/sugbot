require 'cinch'
load 'sug.rb'

$botname = 'HeWasIncredibot'
$server = 'irc.synIRC.net'
$channels = ['#sug']

bot = Cinch::Bot.new do
  configure do |c|
    c.server = $server
    c.channels = $channels
    c.port = if ($port) then $port else 6667
    c.nick = $botname
    c.user = $botname
    c.plugins.plugins = [Sug]
    c.plugins.prefix = /^&/
  end

end

bot.start
end
