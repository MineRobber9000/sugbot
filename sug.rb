# Plugin for interacting with the sug.rocks API to get the latest OP from a board
require "json"
require "restclient"

class Sug
	include Cinch::Plugin
	match /latestop (\S*)/
	
	def getLatestOP(board)
		debug "Getting /sug/ OP from board #{board}"
		opraw = RestClient.get "http://api.sug.rocks/threads.json"
		unless opraw.code == 200
			return "Error getting OPs from sug.rocks API"
		end
		ops = JSON.parse(opraw)
		ops.each do |op|
			debug "Trying OP on board #{op['board']}"
			if op["board"] == board then
				response = "Latest OP is \"#{op['edition']}\" "
				if op["status"]["archived"] then
					response = response + "[ARCHIVED] "
				end
				if op["status"]["bump_limit"] then
					response = response + "[BUMP LIMIT] "
				end
				if op["status"]["image_limit"] then
					response = response + "[IMAGE LIMIT] "
				end
				unless board == "sugen"
					response = response + "[PAGE #{op['page']}] "
				end
				response = response + "(#{op['url']})"
				return response
			end
		end
		return "No OP for that board"
	end

	def execute(m,board)
		m.reply(getLatestOP(board))
	end
end
