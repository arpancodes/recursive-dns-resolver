def get_command_line_argument
  # ARGV is an array that Ruby defines for us,
  # which contains all the arguments we passed to it
  # when invoking the script from the command line.
  # https://docs.ruby-lang.org/en/2.4.0/ARGF.html
  if ARGV.empty?
    puts "Usage: ruby lookup.rb <domain>"
    exit
  end
  ARGV.first
end

# `domain` contains the domain name we have to look up.
domain = get_command_line_argument

# File.readlines reads a file and returns an
# array of string, where each element is a line
# https://www.rubydoc.info/stdlib/core/IO:readlines
dns_raw = File.readlines("zone")

# ..
# ..
# FILL YOUR CODE HERE
# ..
# ..

def parse_dns(dns_raw)
  dns_raw.map { |line|
    source_destination = line.chomp().split(", ")
    [source_destination[1], source_destination[2]]
  }.to_h
end

def resolve(dns_records, lookup_chain, domain)
  block = /\d{,2}|1\d{2}|2[0-4]\d|25[0-5]/
  re = /\A#{block}\.#{block}\.#{block}\.#{block}\z/
  if dns_records[domain] == nil
    print "Error: record not found for "
  elsif (re =~ dns_records[domain])
    lookup_chain.push(dns_records[domain])
  else
    lookup_chain.push(dns_records[domain])
    resolve(dns_records, lookup_chain, dns_records[domain])
  end
  lookup_chain
end

# To complete the assignment, implement `parse_dns` and `resolve`.
# Remember to implement them above this line since in Ruby
# you can invoke a function only after it is defined.
dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")
