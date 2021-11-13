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
def parse_dns(dns_raw)
  # Filter Spaces and 1st line from the input zone file
  dns_raw=dns_raw[1..-1]
  dns_prun_data = dns_raw.map(&:strip).delete_if {|text_data| text_data.length == 0 }
  temp=Array.new(15){Array.new(3)}
  rows_content=[]
  for r in 0..4
    rows_content=dns_prun_data[r].strip.split(",")
    for c in 0..2
      temp[r][c]=rows_content[c].strip
    end
  end
  Hash[temp.map {|key,val3,val4| [val3,{:type=>key,:target=>val4}]}] # Creating content chain using source and Record; DESTN
end

def resolve(rec, chain, domain)
  record = rec[domain]
  if (!record)
    chain=["Error: Record not found for #{domain}"]
    return chain
  end
  if record[:type] == "A"
    chain.push(record[:target])
    return chain
  elsif record[:type] == "CNAME"
    chain.push(record[:target])
      resolve(rec,chain,record[:target])
  end
end

# ..
# ..
# To complete the assignment, implement `parse_dns` and `resolve`.
# Remember to implement them above this line since in Ruby
# you can invoke a function only after it is defined.
dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")
