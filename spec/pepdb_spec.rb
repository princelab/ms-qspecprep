require 'spec_helper'

describe "Peptide_DB" do 
	before do 
		tfasta = TESTFILE + 'test.fasta'
		@digest = PepDigest.new(tfasta)
		@digest.digest
	end
	it 'Times required for sets of test files...' do 
		tfasta = TESTFILE + 'test.fasta'
		tfasta1 = TESTFILE + 'test1.fasta'
		tfasta2 = TESTFILE + 'test2.fasta'
		tfasta3 = TESTFILE + 'test3.fasta'
		t = Time.now
		@digest = PepDigest.new(tfasta)
		@digest.digest
		puts "-------------------\nThe smallest file took #{Time.now-t}\n--------------------"		
		t = Time.now
		@digest = PepDigest.new(tfasta1)
		@digest.digest
		puts "-------------------\nThe small test file took #{Time.now-t}\n--------------------"
		t = Time.now
		@digest = PepDigest.new(tfasta2)
		@digest.digest
		puts "-------------------\nThe medium test file took #{Time.now-t}\n--------------------"
#		t = Time.now
#		@digest = PepDigest.new(tfasta3)
#		@digest.digest
#		puts "-------------------\nThe largest test file took #{Time.now-t}\n--------------------"
	end
	it "Parses Uniprot FASTA correctly (ID)" do 
		@digest.proteins.first.id.should.equal "P31946"
	end
	it 'Digester fxn checks out as accurate' do 
		digester('RARPRANDKLAM', 0).class.should.equal Array.new.class
		digester('RARPRANDKLAM', 0).should.equal ["R", "ARPR", "ANDK", "LAM"]
		digester('RARPRANDKLAM', 1).should.equal ["R", "ARPR", "ANDK", "LAM", "RARPR", "ANDKLAM", "ARPRANDK"]
	end
#	it 'works on a large fasta' do 
#		t = Time.now
#		@fullfile = PepDigest.new('/home/ryanmt/lab/DB/uni_human_var_100517_fwd.fasta')
#		@fullfile.digest
#		puts "-------------------\nTime required was #{Time.now-t}\n--------------------"
#	end
	it "Parses Uniprot FASTA correctly (EntryName)" do
		@digest.proteins.first.entry_name.should.equal '1433B_HUMAN'
	end
	it "Parses Uniprot FASTA correctly (ProteinName)" do
		@digest.proteins.first.protein_name.should.equal "14-3-3 protein beta/alpha"
	end
	it "Parses Uniprot FASTA correctly (OrganismName)" do 
		@digest.proteins.first.organism_name.should.equal "Homo sapiens"
	end
	it "Parses Uniprot FASTA correctly (Sequence)" do 
		@digest.proteins.first.sequence.should.equal "MTMDKSELVQKAKLAEQAERYDDMAAAMKAVTEQGHELSNEERNLLSVAYKNVVGARRSSWRVISSIEQKTERNEKKQQMGKEYREKIEAELQDICNDVLELLDKYLIPNATQPESKVFYLKMKGDYFRYLSEVASGDNKQTTVSNSQQAYQEAFEISKKEMQPTHPIRLGLALNFSVFYYEILNSPEKACSLAKTAFDEAIAELDTLNEESYKDSTLIMQLLRDNLTLWTSENQGDEGDAGEGEN"
	end
	it "Digests all proteins into their peptide fragments" do 
		@digest.proteins.first.peptides.class.should.equal Array.new.class
	end
	it "Lists all peptides with the proteins from which it could id" do 
		@digest.peptides.first.should.equal ["MTMDK".to_sym, ["P31946"]]
	end
end
