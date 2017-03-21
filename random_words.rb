#!/usr/bin/ruby

require 'net/http'

begin
	words = []
	num_words = [1,2].sample
	
	while words.length < num_words
		redirect_raw = Net::HTTP.get(URI "http://www.urbandictionary.com/random.php")
		redirect = redirect_raw.match(/<a href="(?<href>[^"]+)"/)["href"]
		resp = Net::HTTP.get(URI redirect)
		word_raw = resp.match(/<a class=\"word\"[^>]+>(?<word>[^<]+)<\/a>/)
		word = word_raw["word"] rescue "NO"
		word[0]==word[0].downcase && words.push(word)
		words.join(" ").length>34 && words.clear
	end

rescue; $WORDS = false
else; $WORDS = words.join(" ")
end