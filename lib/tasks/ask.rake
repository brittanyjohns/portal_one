desc "Say hello!"
task ask: [:environment] do
  prompt = "the name 'Brittany' spelled out in sunflowers on green grass"
  post = Post.create_image(prompt)
  puts "@post : #{post.inspect}"

  puts "Hello"
end
