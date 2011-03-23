#!/usr/bin/env ruby

MaxMissedCleavages = 3

Protein = Struct.new(:peptides, :id, :entry_name, :protein_name, :organism_name, :gene_name, :sequence)
Peptide = Struct.new(:sequence, :protein_ids)

def digester(string, missed_cleavages) # Returns an array of chomped sequences
	arr = (0..(string.upcase.length-1)).map {|i| string[i]}
	last, curr, next_item = nil, nil, nil
	misses = 0
	splits = []
	keeper = ""
	arr.each_index do |i|
		last = arr[i-1]; curr = arr[i]; next_item = arr[i+1]
#		puts "last, curr, next: #{last}, #{curr}, #{next_item}"
		keeper << curr if curr
#		puts "keeper: #{keeper}"
		if curr == 'R' or curr == 'K'
			break if next_item == "P"
			#puts "misses:missed cleavages			#{misses}:#{missed_cleavages}"
			if misses < missed_cleavages
				misses += 1
			else
#				puts 'cutting'
				splits << keeper
				keeper = ""
				misses = 0
			end
		end
		splits << keeper if next_item == nil
	end			
	splits
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
				id, entry_name, protein_name, organism_name, gene_name = /^>sp\|(\w*-?\w*)\|(\w*)\s(.*)\sOS=(.*)\sGN=(\w+).*/.match(line).captures
				@proteins << Protein.new(nil, id, entry_name, protein_name, organism_name, gene_name, nil)
			end
		end
	end
	def digest
		@peptides = []
		tmp_peps = []
		@proteins.each do |prot|
			seq = prot.sequence
			(0..MaxMissedCleavages).each do |missed_cleav|
				digester(seq, missed_cleav).each do |pept|
					tmp_peps << Peptide.new(pept, [prot.id])
#			 ###		Peptide = Struct.new(:sequence, :protein_ids)
				end
			end
 		end
		tmp_peps = tmp_peps.sort_by{|a| [a.sequence]}
		prev_p = nil
		tmp_peps.each_index do |i|
			prev_p = tmp_peps[i-1]
			p = tmp_peps[i]
			if prev_p.sequence == p.sequence
				p.protein_ids << prev_p.protein_ids
				tmp_peps[i-1] = nil
				p.protein_ids.flatten!.sort!.uniq!
				p p.protein_ids
			end
		end
		
			

#		HOW Do I combine the duplicates by appending the protein tag to the list of peptides?  
			## Do I need to keep track of the missed cleavages?  Can't I just calculate that later, if I ever want it, with less overhead and faster than moving them around the entire time?  TRYING IT@!
	end
end

