require 'spec_helper'

describe "Peptide_DB" do 
	before do 
		tfasta = TESTFILE + 'test.fasta'
		@digest = PepDigest.new(tfasta)
		@digest.digest
	end
	it "Parses Uniprot FASTA correctly (ID)" do 
		@digest.proteins.first.id.should.equal "P31946"
	end
=begin
	it "Parses Uniprot FASTA correctly (EntryName)" do
		@digest.proteins.first.tmp  
	end
	it "Parses Uniprot FASTA correctly (ProteinName)" do
		@digest.proteins.first.tmp
	end
	it "Parses Uniprot FASTA correctly (OrganismName)" do 
		@digest.proteins.first.tmp
	end
	it "Parses Uniprot FASTA correctly (GeneName)" do 
		@digest.proteins.first.tmp
	end
	it "Parses Uniprot FASTA correctly (ProteinExistence)" do 
		@digest.proteins.first.tmp
	end
	it "Parses Uniprot FASTA correctly (SequenceVersion)" do 
		@digest.proteins.first.tmp
	end
	it "Parses Uniprot FASTA correctly (Sequence)" do 
		@digest.proteins.first.tmp
	end
	it "Digests all proteinss into their peptide fragments" do 
		@digest.proteins.first.peptides.should.be Array
	end
	it "Lists all peptides with the proteins from which it could id" do 
		@digest.proteins.first.pep_db.should.be Hash
	end
=end
end
