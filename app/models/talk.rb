# require "espeak"

# def default_options
#   { lang: "en-us",
#     pitch: 120,
#     speed: 150,
#     capital: 1,
#     amplitude: 90,
#     quiet: true }
# end

# def speak(word, options)
#   # Speaks "YO!"
#   lang = options[:lang]
#   pitch = options[:pitch]
#   speed = options[:speed]
#   capital = options[:capital]
#   amplitude = options[:amplitude]
#   quiet = options[:quiet]
#   puts "capital: #{capital}"
#   puts "pitch: #{pitch}"
#   puts "speed: #{speed}"
#   # speech = ESpeak::Speech.new(name, voice: lang)
#   speech = ESpeak::Speech.new(word, voice: lang, pitch: pitch, speed: speed, capital: capital, amplitude: amplitude, quiet: quiet)
#   speech.speak # invokes espeak
# end

# MAX_LEVEL = 200
# words = %w(I want Juice juice)
# # words = [20, 50, 80, 100]
# level = 0
# loop do
#   level += 20
#   opts = default_options.merge(amplitude: level)
#   puts "** \nlevel: #{level}\nOptions: #{opts}\n\n"
#   #   speak(words[0], opts)
#   #   speak(words[1], opts)
#   #   speak(words[2], opts)
#   speak(words[3], opts)
#   sleep 1
#   break if level >= MAX_LEVEL
# end
