#!/usr/bin/env ruby

MaxMissedCleavages = 3

Protein = Struct.new(:peptides, :id, :entry_name, :protein_name, :organism_name, :sequence)
#		Peptide = Struct.new(:sequence, :protein_ids)  ### Replaced by a hash

def digester(string, missed_cleavages) # Returns an array of chomped sequences
	string.upcase!
	arr = (0..(string.upcase.length-1)).map {|i| string[i]}
	misses = 0; splits = []
	(0..missed_cleavages).each do |miss_cleav|
		(0..missed_cleavages).each do |init_num|
			last, curr, next_item = nil, nil, nil; keeper = ""
			misses =  init_num
			arr.each_index do |i|
				last = arr[i-1]; curr = arr[i]; next_item = arr[i+1]
		#	puts "last, curr, next: #{last}, #{curr}, #{next_item}"
				keeper << curr if curr
		#	puts "keeper: #{keeper}"
				if curr == 'R' or curr == 'K'
					unless next_item == "P"
		#				puts "misses:missed cleavages			#{misses}:#{miss_cleav}"
						if misses < miss_cleav
							misses += 1
						else
							splits << keeper
							keeper = "";	misses = 0
						end
					end
				end
				splits << keeper if next_item == nil
		#		puts "Splits looks like: #{splits}"
			end
		end			
	end
	splits.uniq
end


class PepDigest
	attr_accessor :peptides, :proteins

	def initialize(filename)
		raise 'Wrong file type' if File.extname(filename).downcase != '.fasta'
		parse(filename)
	end
	def parse(filename)
		read = false
		@proteins = []
		IO.readlines(filename).each do |line|
			start = true if read.false?
			read = true; read = false if line[/^>/]
			if read
				if start
					@proteins.last.sequence = line.chomp
					next
				end
				@proteins.last.sequence = @proteins.last.sequence + line.chomp
			else
			begin
				id, entry_name, protein_name, organism_name = /^>[a-z]{2}\|(\w*-?\w*)\|(\w*)\s(.*)\sOS=(\w+\s?\w+).*/.match(line).captures
			rescue NoMethodError , TypeError=> e
				print "\nError reading line: \n #{line} \n Error message: #{e}"
				print "Matches looks like: " + /^>[a-z]{2}\|(\w*-?\w*)\|(\w*)\s(.*)\sOS=(\w+\s?\w+).*/.match(line)
			end
				@proteins << Protein.new([], id, entry_name, protein_name, organism_name, nil)
			end
		end
	end
	def digest
		@peptides = {}
		@proteins.each do |prot|
			seq = prot.sequence
			digester(seq, MaxMissedCleavages).each do |pept|
				if @peptides[pept.to_sym].nil?
					@peptides[pept.to_sym] = [prot.id]
				else
					@peptides[pept.to_sym] = @peptides[pept.to_sym] << prot.id
					@peptides[pept.to_sym].uniq!
				end
				prot.peptides << pept
#			 ###		Peptide = Struct.new(:sequence, :protein_ids)
			end
 		end
#		p @peptides
	end
		
			

#		HOW Do I combine the duplicates by appending the protein tag to the list of peptides?  
			## Do I need to keep track of the missed cleavages?  Can't I just calculate that later, if I ever want it, with less overhead and faster than moving them around the entire time?  TRYING IT@!
end

