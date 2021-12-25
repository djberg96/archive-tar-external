# frozen_string_literal: true

###############################################################################
# archive_tar_external_spec.rb
#
# Tests for the archive-tar-external library. This test case should be
# run via the 'rake spec' Rake task.
###############################################################################
require 'archive/tar/external'
require 'spec_helper'

RSpec.describe Archive::Tar::External do
  let(:tmp_file1) { 'temp1.txt' }
  let(:tmp_file2) { 'temp2.txt' }
  let(:tmp_file3) { 'temp3.txt' }

  let(:tar_name) { 'test.tar' }
  let(:tar_obj)  { described_class.new(tar_name) }
  let(:pattern)  { '*.txt' }

  let(:archive_name) { 'test.tar.gz' }
  let(:tar_program)  { 'tar' }

  before do
    File.open(tmp_file1, 'w'){ |f| f.puts 'This is a temporary text file' }
    File.open(tmp_file2, 'w'){ |f| f.puts 'This is a temporary text file' }
    File.open(tmp_file3, 'w'){ |f| f.puts 'This is a temporary text file' }
  end

  example 'version' do
    expect(Archive::Tar::External::VERSION).to eq('1.5.0')
    expect(Archive::Tar::External::VERSION).to be_frozen
  end

  context 'constructor' do
    example 'with name' do
      expect{ described_class.new(tar_name) }.not_to raise_error
    end

    example 'with name and extension' do
      expect{ described_class.new(tar_name, pattern) }.not_to raise_error
    end

    example 'with compression program', :gzip => true do
      expect{ described_class.new(tar_name, pattern, 'gzip') }.not_to raise_error
    end

    example 'raises an error if name is not provided' do
      expect{ described_class.new }.to raise_error(ArgumentError)
    end
  end

  context 'instance methods' do
    example 'tar_program getter' do
      expect(tar_obj).to respond_to(:tar_program)
      expect(tar_obj.tar_program).to eq(tar_program)
    end

    example 'archive_name getter' do
      expect(tar_obj).to respond_to(:archive_name)
      expect(tar_obj.archive_name).to eq(tar_name)
    end

    example 'archive_name setter' do
      expect(tar_obj).to respond_to(:archive_name=)
      expect{ tar_obj.archive_name = 'foo' }.not_to raise_error
      expect(tar_obj.archive_name).to eq('foo')
    end

    example 'compressed_archive_name getter' do
      expect(tar_obj).to respond_to(:compressed_archive_name)
      expect(tar_obj.compressed_archive_name).to be_nil
    end

    example 'compressed_archive_name setter basic functionality' do
      expect(tar_obj).to respond_to(:compressed_archive_name=)
      expect{ tar_obj.compressed_archive_name = archive_name }.not_to raise_error
    end

    example 'setting the compressed_archive_name also sets the archive name to the expected value' do
      tar_obj.compressed_archive_name = archive_name
      expect(tar_obj.compressed_archive_name).to eq(archive_name)
      expect(tar_obj.archive_name).to eq(tar_name)

      tar_obj.compressed_archive_name = 'test.tgz'
      expect(tar_obj.compressed_archive_name).to eq('test.tgz')
      expect(tar_obj.archive_name).to eq(tar_name)
    end

    example 'create_archive basic functionality' do
      expect(tar_obj).to respond_to(:create_archive)
      expect{ tar_obj.create_archive(pattern) }.not_to raise_error
      expect(File.exist?(tar_name)).to be true
    end

    example 'create_archive requires at least on argument' do
      expect{ tar_obj.create_archive }.to raise_error(ArgumentError)
    end

    example 'create_archive raises an error if no files match the pattern' do
      expect{ tar_obj.create_archive('*.blah') }.to raise_error(Archive::Tar::Error)
    end

    example 'create_archive accepts optional parameters' do
      expect{ tar_obj.create_archive(pattern, 'jcf') }.not_to raise_error
    end

    example 'create is an alias for create_archive' do
      expect(tar_obj).to respond_to(:create)
      expect(tar_obj.method(:create)).to eq(tar_obj.method(:create_archive))
    end

    example 'format getter' do
      expect(tar_obj).to respond_to(:format)
      expect(tar_obj.format).to eq('pax')
    end
  end

  context 'compression' do
    example 'compress_archive basic functionality' do
      expect(tar_obj).to respond_to(:compress_archive)
    end

    example 'compress is an alias for compress_archive' do
      expect(tar_obj).to respond_to(:compress)
      expect(tar_obj.method(:compress)).to eq(tar_obj.method(:compress_archive))
    end

    example 'compress_archive defaults to gzip', :gzip => true do
      tar_obj.create_archive(pattern)
      tar_obj.compress_archive

      expect(tar_obj.compressed_archive_name).to eq(archive_name)
      expect(File.exist?(archive_name)).to be true
    end

    example 'compress_archive works with bzip2', :bzip2 => true do
      expect{ tar_obj.create_archive(pattern) }.not_to raise_error
      expect{ tar_obj.compress_archive('bzip2') }.not_to raise_error
      expect(File.exist?('test.tar.bz2')).to be true
    end
  end

  context 'uncompression' do
    before do
      tar_obj.create_archive(pattern).compress_archive
    end

    example 'uncompress_archive basic functionality' do
      expect(tar_obj).to respond_to(:uncompress_archive)
    end

    example 'uncompress_archive behaves as expected' do
      expect{ tar_obj.uncompress_archive }.not_to raise_error
      expect(File.exist?(archive_name)).to be false
    end

    example 'uncompress is an alias for uncompress_archive' do
      expect(tar_obj).to respond_to(:uncompress)
      expect(tar_obj.method(:uncompress)).to eq(tar_obj.method(:uncompress_archive))
    end

    example 'uncompress_archive singleton method' do
      expect(described_class).to respond_to(:uncompress_archive)
    end
  end

  context 'archive' do
    example 'archive_info basic functionality' do
      expect(tar_obj).to respond_to(:archive_info)
    end

    example 'archive_info returns the expected value' do
      tar_obj.create_archive(pattern)
      expect(tar_obj.archive_info).to eq([tmp_file1, tmp_file2, tmp_file3])
    end

    example 'add_to_archive basic functionality' do
      expect(tar_obj).to respond_to(:add_to_archive)
    end

    example 'add_to_archive works as expected' do
      tar_obj = described_class.new(tar_name)
      expect{ tar_obj.add_to_archive(tmp_file2) }.not_to raise_error
      expect{ tar_obj.add_to_archive(tmp_file2, tmp_file3) }.not_to raise_error
      expect(tar_obj.archive_info).to eq([tmp_file2, tmp_file2, tmp_file3])
    end

    example 'update_archive basic functionality' do
      expect(tar_obj).to respond_to(:update_archive)
    end

    example 'update_archive behaves as expected' do
      tar_obj.create_archive(pattern)
      expect(tar_obj.archive_info).to eq([tmp_file1, tmp_file2, tmp_file3])
      tar_obj.update_archive(tmp_file2)
      expect(tar_obj.archive_info).to eq([tmp_file1, tmp_file2, tmp_file3])
    end

    example 'extract_archive_basic' do
      expect(tar_obj).to respond_to(:extract_archive)
    end

    example "extract_archive raises an error if the file isn't in the archive" do
      tar_obj.create(pattern)
      expect{ tar_obj.expand('blah.txt') }.to raise_error(Archive::Tar::Error)
    end

    example 'extract_archive with no arguments extracts all files' do
      tar_obj.create(pattern)
      expect{ tar_obj.extract_archive }.not_to raise_error
    end

    example 'extract_archive with a valid file argument behaves as expected' do
      tar_obj.create(pattern)
      expect{ tar_obj.extract_archive(tmp_file2) }.not_to raise_error
    end

    example 'expand_archive, expand and extract are aliases for extract_archive' do
      expect(tar_obj.method(:expand_archive)).to eq(tar_obj.method(:extract_archive))
      expect(tar_obj.method(:expand)).to eq(tar_obj.method(:extract_archive))
      expect(tar_obj.method(:extract)).to eq(tar_obj.method(:extract_archive))
    end
  end

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
