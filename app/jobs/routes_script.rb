# Save this script as "routes_script.rb"

# Define the command to execute
command = "rails routes"

# Execute the command and capture the output
output = `#{command}`

# Specify the filename for the output file
filename = "routes_output.txt"

# Open the file in write mode (overwrites existing content or creates a new file)
File.open(filename, "w") do |file|
  file.write(output)
end

puts "Output saved to #{filename}"
