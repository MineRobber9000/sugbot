# Plugin for interacting with the sug.rocks API to get the latest OP from a board
require "json"

class Sug
	include Cinch::Plugin
	match /latestop (\S*)/

	def start() end
	
	def getLatestOP(board)
		begin
			op_stream = open("https://api.sug.rocks/threads.json")
			ops = JSON.parse(op_stream.read)
			ops.each do op
				if op["board"] == board then
					response = "Latest OP is \"#{edition}\" "
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
				return "No OP for that board"
			end
		rescue OpenURI::HTTPError => ex
			return "Error getting response from sug.rocks API"
		end
	end

	def execute(m,board)
		m.reply(getLatestOP(board))
	end
end
