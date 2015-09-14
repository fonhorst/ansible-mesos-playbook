nds = File.open("hosts","r") do |hosts|
	nodes = {}
	while(line = hosts.gets) do
		if line.start_with?("###")
			break		
		end
		strs = line.strip().split(" ") 
		params = {}		
		for s in strs[1..-1] do
			pair = s.split("=")
			params[pair[0]]=pair[1]	
		end
		nodes[strs[0]] = params
	end
	nodes
end

ips = nds.keys.sort.each.map do |key|
	ip = nds[key]["ansible_ssh_host"]
	ip
end

puts ips
