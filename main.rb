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

def puts(s=nil)
	$stdout << (s ? "#{Time.now} :: #{s}" : "") << "\n"
end

def htmlspecialchars(s)
	for i in (0..255).to_a
		s.gsub!("&##{i};",i.chr)
	end
	return s
end

def linebreak(s)
	return [s,""] if s.length<=20
	s = s.split
	sr = []
	while sr.join(" ").length<=20
		sr << s.shift
	end
	s.unshift(sr.pop)
	return [sr.join(" "),s.join(" ")]
end

ARGV2.include?("--once")&&$once=true

loop do 
	$once||(until Time.now.to_s.split[1].split(":")[1].to_i%5==3;end)
	$once&&puts("POSTING NOW ONLY ONCE")
	puts "Choosing words"
	$WORDS = nil
	until $WORDS
		load 'random_words.rb'
	end
	puts "=> Resulting string: #{$WORDS.inspect}"
	$once||(until Time.now.to_s.split[1].split(":")[1].to_i%5==0;end)
	puts "Posting"
	c.update(htmlspecialchars(
		$template
		.gsub("$1",linebreak($WORDS)[0])
		.gsub("$2",linebreak($WORDS)[1])
	))
	#puts linebreak($WORDS).inspect
	puts "Finished"
	$once&&break
end