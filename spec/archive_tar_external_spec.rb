###############################################################################
# archive_tar_external_spec.rb
#
# Tests for the archive-tar-external library. This test case should be
# run via the 'rake spec' Rake task.
###############################################################################
require 'archive/tar/external'
require 'rspec'
require 'ptools'

RSpec.describe Archive::Tar::External do
  let(:tmp_file1) { 'temp1.txt' }
  let(:tmp_file2) { 'temp2.txt' }
  let(:tmp_file3) { 'temp3.txt' }

  let(:tar_name) { 'test.tar' }
  let(:tar_obj)  { Archive::Tar::External.new(tar_name) }
  let(:pattern)  { '*.txt' }

  let(:archive_name) { 'test.tar.gz' }

  before do
    File.open(tmp_file1, 'w'){ |f| f.puts 'This is a temporary text file' }
    File.open(tmp_file2, 'w'){ |f| f.puts 'This is a temporary text file' }
    File.open(tmp_file3, 'w'){ |f| f.puts 'This is a temporary text file' }
  end

  example "version" do
    expect(Archive::Tar::External::VERSION).to eq('1.4.2')
    expect(Archive::Tar::External::VERSION).to be_frozen
  end

  context "constructor" do
    example "with name" do
      expect{ Archive::Tar::External.new(tar_name) }.not_to raise_error
    end

    example "with name and extension" do
      expect{ Archive::Tar::External.new(tar_name, '*.txt') }.not_to raise_error
    end

    example "with compression program", :gzip => true do
      expect{ Archive::Tar::External.new(tar_name, '*.txt', 'gzip') }.not_to raise_error
    end

    example "raises an error if name is not provided" do
      expect{ Archive::Tar::External.new }.to raise_error(ArgumentError)
    end
  end

  context "instance methods" do
    example "tar_program getter" do
      expect(tar_obj).to respond_to(:tar_program)
      expect(tar_obj.tar_program).to eq('tar')
    end

    example "archive_name getter" do
      expect(tar_obj).to respond_to(:archive_name)
      expect(tar_obj.archive_name).to eq(tar_name)
    end

    example "archive_name setter" do
      expect(tar_obj).to respond_to(:archive_name=)
      expect{ tar_obj.archive_name = 'foo' }.not_to raise_error
      expect(tar_obj.archive_name).to eq('foo')
    end

    example "compressed_archive_name getter" do
      expect(tar_obj).to respond_to(:compressed_archive_name)
      expect(tar_obj.compressed_archive_name).to be_nil
    end

    example "compressed_archive_name setter basic functionality" do
      expect(tar_obj).to respond_to(:compressed_archive_name=)
      expect{ tar_obj.compressed_archive_name = archive_name }.not_to raise_error
    end

    example "setting the compressed_archive_name also sets the archive name to the expected value" do
      tar_obj.compressed_archive_name = archive_name
      expect(tar_obj.compressed_archive_name).to eq(archive_name)
      expect(tar_obj.archive_name).to eq(tar_name)

      tar_obj.compressed_archive_name = 'test.tgz'
      expect(tar_obj.compressed_archive_name).to eq('test.tgz')
      expect(tar_obj.archive_name).to eq(tar_name)
    end

    example "create_archive basic functionality" do
      expect(tar_obj).to respond_to(:create_archive)
      expect{ tar_obj.create_archive(pattern) }.not_to raise_error
      expect(File.exist?(tar_name)).to be true
    end

    example "create_archive requires at least on argument" do
      expect{ tar_obj.create_archive }.to raise_error(ArgumentError)
    end

    example "create_archive raises an error if no files match the pattern" do
      expect{ tar_obj.create_archive('*.blah') }.to raise_error(Archive::Tar::Error)
    end

    example "create_archive accepts optional parameters" do
      expect{ tar_obj.create_archive(pattern, 'cfj') }.not_to raise_error
    end

    example "create is an alias for create_archive" do
      expect(tar_obj).to respond_to(:create)
      expect(tar_obj.method(:create)).to eq(tar_obj.method(:create_archive))
    end
  end

  context "compression" do
    example "compress_archive basic functionality" do
      expect(tar_obj).to respond_to(:compress_archive)
    end

    example "compress is an alias for compress_archive" do
      expect(tar_obj).to respond_to(:compress)
      expect(tar_obj.method(:compress)).to eq(tar_obj.method(:compress_archive))
    end

    example "compress_archive defaults to gzip", :gzip => true do
      tar_obj.create_archive('*.txt')
      tar_obj.compress_archive

      expect(tar_obj.compressed_archive_name).to eq(archive_name)
      expect(File.exist?(archive_name)).to be true
    end

    example "compress_archive works with bzip2", :bzip2 => true do
      expect{ tar_obj.create_archive('*.txt') }.not_to raise_error
      expect{ tar_obj.compress_archive('bzip2') }.not_to raise_error
      expect(File.exist?('test.tar.bz2')).to be true
    end
  end

  context "uncompression" do
    before do
      tar_obj.create_archive('*.txt').compress_archive
    end

    example "uncompress_archive basic functionality" do
      expect(tar_obj).to respond_to(:uncompress_archive)
    end

    example "uncompress_archive behaves as expected" do
      expect{ tar_obj.uncompress_archive }.not_to raise_error
      expect(File.exist?(archive_name)).to be false
    end

    example "uncompress is an alias for uncompress_archive" do
      expect(tar_obj).to respond_to(:uncompress)
      expect(tar_obj.method(:uncompress)).to eq (tar_obj.method(:uncompress_archive))
    end

    example "uncompress_archive singleton method" do
      expect(Archive::Tar::External).to respond_to(:uncompress_archive)
    end
  end

=begin

  example "archive_info" do
    expect(@tar).to respond_to(:archive_info)
    expect{ @tar.create_archive('*.txt') }.not_to raise_error
    expect( @tar.archive_info).to eq(['temp1.txt','temp2.txt','temp3.txt'])
  end

  example "add_to_archive" do
    assert_respond_to(@tar,:add_to_archive)
    expect{ @tar.create_archive('temp1.txt') }.not_to raise_error
    expect{ @tar.add_to_archive('temp2.txt') }.not_to raise_error
    expect{ @tar.add_to_archive('temp2.txt','temp3.txt') }.not_to raise_error
  end

  example "update_archive" do
    expect(@tar).to respond_to(:update_archive)
    expect{ @tar.create_archive('*.txt') }.not_to raise_error
    expect{ @tar.update_archive('temp2.txt') }.not_to raise_error
  end

  example "extract_archive_basic" do
    expect(@tar).to respond_to(:extract_archive)
  end

  example "extract_archive_aliases" do
    expect(Tar::External.instance_method(:extract_archive) == Tar::External.instance_method(:expand_archive)).to be true
    expect(Tar::External.instance_method(:extract) == Tar::External.instance_method(:expand_archive)).to be true
    expect(Tar::External.instance_method(:expand) == Tar::External.instance_method(:expand_archive)).to be true
  end

  example "extract_archive_advanced" do
    skip unless RbConfig::CONFIG['host_os'] =~ /sunos|solaris/{
      expect{ @tar.tar_program = @@gtar }.not_to raise_error
    }
    expect{ @tar.create('*.txt') }.not_to raise_error
    expect{ @tar.expand('blah.txt') }.to raise_error(Tar::Error)

    expect{ @tar.extract_archive }.not_to raise_error
    expect{ @tar.extract_archive('temp2.txt') }.not_to raise_error
  end
=end

  after do
    File.delete(tmp_file1) if File.exist?(tmp_file1)
    File.delete(tmp_file2) if File.exist?(tmp_file2)
    File.delete(tmp_file3) if File.exist?(tmp_file3)

    File.delete(tar_name) if File.exist?(tar_name)
    File.delete("#{tar_name}.gz") if File.exist?("#{tar_name}.gz")
    File.delete("#{tar_name}.bz2") if File.exist?("#{tar_name}.bz2")
    File.delete("#{tar_name}.zip") if File.exist?("#{tar_name}.zip")
  end
end
