# require "espeak-ruby"
require "espeak"

# # Speaks
# "YO!"
# speech = ESpeak::Speech.new("YO!")
# speech.speak # invokes espeak

# # Creates hello-de.mp3 file
# speech = ESpeak::Speech.new("Hallo Welt", voice: "de")
# speech.save("hello-de.mp3") # invokes espeak + lame

# # Lists voices
# ESpeak::Voice.all.map { |v| v.language } # ["af", "bs", "ca", "cs", "cy", "da", "de", "el", "en", "en-sc", "en-uk", "en-uk-north", "en-uk-rp", "en-uk-wmids", "en-us", "en-wi", "eo", "es", "es-la", "fi", "fr", "fr-be", "grc", "hi", "hr", "hu", "hy", "hy", "id", "is", "it", "jbo", "ka", "kn", "ku", "la", "lv", "mk", "ml", "nci", "nl", "no", "pap", "pl", "pt", "pt-pt", "ro", "ru", "sk", "sq", "sr", "sv", "sw", "ta", "tr", "vi", "zh", "zh-yue"]

# # Find particular voice
# ESpeak::Voice.find_by_language("en") #<ESpeak::Voice:0x007fe1d3806be8 @language="en", @name="default", @gender="M", @file="default">
def say(text, options)
  # Speaks "YO!"
  lang = options[:lang]
  pitch = options[:pitch]
  speed = options[:speed]
  capital = options[:capital]
  speech = ESpeak::Speech.new(text, voice: lang, pitch: pitch, speed: speed, capital: capital)
  speech.speak # invokes espeak
end

def run_tts_test
  # Speaks "YO!"
  speech = ESpeak::Speech.new("Hello Austin!")
  speech.speak # invokes espeak

  # Creates hello-de.mp3 file
  speech = ESpeak::Speech.new("Hallo Welt", voice: "de")
  speech.save("hello-de.mp3") # invokes espeak + lame

  # Lists voices
  ESpeak::Voice.all.map { |v| v.language } # ["af", "bs", "ca", "cs", "cy", "da", "de", "el", "en", "en-sc", "en-uk", "en-uk-north", "en-uk-rp", "en-uk-wmids", "en-us", "en-wi", "eo", "es", "es-la", "fi", "fr", "fr-be", "grc", "hi", "hr", "hu", "hy", "hy", "id", "is", "it", "jbo", "ka", "kn", "ku", "la", "lv", "mk", "ml", "nci", "nl", "no", "pap", "pl", "pt", "pt-pt", "ro", "ru", "sk", "sq", "sr", "sv", "sw", "ta", "tr", "vi", "zh", "zh-yue"]

  # Find particular voice
  ESpeak::Voice.find_by_language("en") #<ESpeak::Voice:0x007fe1d3806be8 @language="en", @name="default", @gender="M", @file="default">
end

opts = { lang: "en-us", pitch: 50, speed: 180, capital: 170 }
sayings = ["I", "want", "Yes", "More", "more", "out", "in", "GO", "NO", "STOP"]
sayings.each do |word|
  say(word, opts)
end
