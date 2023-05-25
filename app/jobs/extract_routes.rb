def get_full_path(resource, verb)
  case verb
  when "GET"
    "#{resource}_path"
  when "PUT"
    "#{resource.chomp("s")}_path"
  else
    "#{resource}_path"
  end
end

# Save this script as "extract_routes.rb"

# Specify the filename of the input file
filename = "routes_output.txt"

# Read the contents of the input file
contents = File.read(filename)

# Extract the routes using a regular expression
routes = contents.scan(/(\w+)\s+(\w+)\s+(\S+)\s+(.+#\w+)/)

# Display the extracted routes
more_info = {}
search_array = []

VERBS = %w(GET PATCH PUT POST DELETE)
# Open the file for reading
File.open(filename, "r") do |file|
  # Read the file line by line
  file.each_line do |line|
    prefix, verb, pattern, controller_action = line.split(" ")
    # puts "Verb: #{verb}\nprefix: #{prefix}\nController#Action:\n\n"
    route_info = more_info[prefix] || {}
    # more_info[key] = route_info

    # prefix, verb, pattern, controller_action = line.split(" ")
    if controller_action
      resource = controller_action.split("#")[0]
      action = controller_action.split("#")[1]
    else
      resource = pattern.split("#")[0]
      action = pattern.split("#")[1]
    end
    if !VERBS.include?(verb)
      verb = prefix
      prefix = resource
    end

    key = "#{prefix}_#{verb}"
    path = get_full_path(resource, verb)
    puts "verb: #{verb}| Prefix: #{prefix} | resource: #{resource}| controller_action: #{controller_action}"

    route_info["resource"] = resource
    route_info["prefix"] = prefix
    route_info["path"] = path
    route_info["verb"] = verb
    route_info["action"] = action
    more_info[prefix] = more_info[prefix] || {}
    more_info[prefix][verb] = more_info[prefix][verb] || {}
    more_info[prefix][verb]["action"] = action
    more_info[prefix][verb]["resource"] = resource
    more_info[prefix][verb]["prefix"] = prefix
    more_info[prefix][verb]["path"] = path
    more_info[prefix][verb]["verb"] = verb
    # more_info[prefix] = route_info
    # search_array << more_info
  end
end
require "json"

puts "search_array: #{search_array.count}"
# search_array.each do |route|
#   puts "\n\n\n\n\n**********************\n\n\n"

#   test_str = JSON.pretty_generate(route)
#   puts "\n\n #{test_str}\n\n"
# end
test_str = JSON.pretty_generate(more_info)
puts "\n\n #{test_str}\n\n"
