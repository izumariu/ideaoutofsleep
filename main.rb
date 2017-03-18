#!/usr/bin/ruby

Dir.chdir(File.dirname __FILE__)

require 'twitter'
load '../private/auth.rb'

$template = File.read("template.txt")

c = Twitter::REST::Client.new do |config|
	config.consumer_key        = $consumer.key
	config.consumer_secret     = $consumer.secret
	config.access_token        = $token.token
	config.access_token_secret = $token.secret
end

ARGV2 = ARGV.pop(ARGV.length)
ARGV.clear

if ARGV2.include?("--first-start")
	print "Do you really wish to re-setup your account? [y/N]"
	choice = gets.chomp
	if choice=="y"||choice=="Y"
		puts "SETTING UP"
		puts "UPDATING PROFILE IMAGE"
		c.update_profile_image(File.new "profile.png")
		puts "UPDATING PROFILE INFO"
		c.update_profile(
			name: "IdeaOutOfSleep", 
			description: "no bio wow | made by @fluffysesshoOwO", 
			url: "https://github.com/sesshomariu/ideaoutofsleep"
		)
	end
end

if ARGV2.include?("--once")
	puts "POSTING NOW ONLY ONCE"
	$WORDS = nil
	until $WORDS
		load 'random_words.rb'
	end
	c.update($template.gsub("$WORD",$WORDS))
	exit
end

loop do 
	until Time.now.to_s.split[1].split(":")[1].to_i%15==10;end
	$WORDS = nil
	until $WORDS
		load 'random_words.rb'
	end
	until Time.now.to_s.split[1].split(":")[1].to_i%15==0;end
	c.update($template.gsub("$WORD",$WORDS))
end