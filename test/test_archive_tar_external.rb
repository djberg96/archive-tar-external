###############################################################################
# test_archive_tar_external.rb
#
# Test suite for the archive-tar-external library. This test case should be
# run via the 'rake test' Rake task.
###############################################################################
require 'archive/tar/external'
require 'test-unit'
require 'ptools'
include Archive

class TC_ArchiveTarExternal < Test::Unit::TestCase
  def self.startup
    Dir.chdir(File.dirname(File.expand_path(__FILE__)))

    @@tmp_file1 = 'temp1.txt'
    @@tmp_file2 = 'temp2.txt'
    @@tmp_file3 = 'temp3.txt'

    @@gtar_found  = File.which('gtar')
    @@tar_found   = File.which('tar')
    @@gzip_found  = File.which('gzip')
    @@bzip2_found = File.which('bzip2')

    File.open(@@tmp_file1, 'w'){ |f| f.puts 'This is a temporary text file' }
    File.open(@@tmp_file2, 'w'){ |f| f.puts 'This is a temporary text file' }
    File.open(@@tmp_file3, 'w'){ |f| f.puts 'This is a temporary text file' }
  end

  def setup
    @tar      = Tar::External.new('test.tar')
    @tar_name = 'test.tar'
    @pattern  = '*.txt'
    @archive  = 'temp.tar.gz'
  end

  def test_version
    assert_equal('1.3.2', Tar::External::VERSION)
  end

  def test_constructor
    assert_nothing_raised{ Tar::External.new(@tar_name) }
  end

  def test_constructor_with_extension
    assert_nothing_raised{ Tar::External.new(@tar_name, '*.txt') }
  end

  def test_constructor_with_program
    omit_unless(@@gzip_found){ 'gzip program not found - skipping' }
    assert_nothing_raised{ Tar::External.new(@tar_name, '*.txt', 'gzip') }
  end

  def test_constructor_expected_errors
    assert_raise(ArgumentError){ Tar::External.new }
  end

  def test_tar_program
    assert_respond_to(@tar, :tar_program)
    assert_equal('tar', @tar.tar_program)
  end

  def test_archive_name
    assert_respond_to(@tar, :archive_name)
    assert_respond_to(@tar, :archive_name=)

    assert_equal('test.tar', @tar.archive_name)
    assert_nothing_raised{ @tar.archive_name }
    assert_nothing_raised{ @tar.archive_name = 'foo' }
  end

  def test_compressed_archive_name_get
    assert_respond_to(@tar, :compressed_archive_name)
    assert_nil(@tar.compressed_archive_name)
  end

  def test_compressed_archive_name_set
    assert_respond_to(@tar, :compressed_archive_name=)
    assert_nothing_raised{ @tar.compressed_archive_name = 'test.tar.gz' }
    assert_equal('test.tar.gz', @tar.compressed_archive_name)
    assert_equal('test.tar', @tar.archive_name)

    assert_nothing_raised{ @tar.compressed_archive_name = 'test.tgz' }
    assert_equal('test.tgz', @tar.compressed_archive_name)
    assert_equal('test.tar', @tar.archive_name)
  end

  test "create_archive basic functionality" do
    assert_respond_to(@tar, :create_archive)
    assert_nothing_raised{ @tar.create_archive(@pattern) }
    assert_true(File.exist?(@tar_name))
  end

  test "create_archive requires at least on argument" do
    assert_raises(ArgumentError){ @tar.create_archive }
  end

  test "create_archive raises an error if no files match the pattern" do
    assert_raises(Tar::Error){ @tar.create_archive('*.blah') }
  end

  test "create_archive accepts optional parameters" do
    assert_nothing_raised{ @tar.create_archive(@pattern, 'cfj') }
  end

  def test_create_alias
    assert_respond_to(@tar, :create)
    assert_true(Tar::External.instance_method(:create) == Tar::External.instance_method(:create_archive))
  end

  def test_compress_archive_basic
    assert_respond_to(@tar, :compress_archive)
  end

  def test_compress_alias
    assert_respond_to(@tar, :compress)
    assert_true(Tar::External.instance_method(:compress) == Tar::External.instance_method(:compress_archive))
  end

  def test_compress_archive_gzip
    assert_nothing_raised{ @tar.create_archive('*.txt') }
    assert_nothing_raised{ @tar.compress_archive }

    assert_equal('test.tar.gz', @tar.compressed_archive_name)
    assert_true(File.exist?('test.tar.gz'))
  end

  def test_compress_archive_bzip2
    assert_nothing_raised{ @tar.create_archive('*.txt') }
    assert_nothing_raised{ @tar.compress_archive('bzip2') }
    assert_true(File.exist?('test.tar.bz2'))
  end

  def test_uncompress_archive
    assert_respond_to(@tar, :uncompress_archive)
    assert_nothing_raised{ @tar.create_archive('*.txt') }
    assert_nothing_raised{ @tar.compress_archive }
    assert_nothing_raised{ @tar.uncompress_archive }
    assert_false(File.exist?('test.tar.gz'))
  end

  def test_uncompress_archive_class_method
    assert_respond_to(Tar::External, :uncompress_archive)
  end

  def test_uncompress_alias
    assert_respond_to(Tar::External, :uncompress)
    assert_true(Tar::External.method(:uncompress) == Tar::External.method(:uncompress_archive))
  end

  def test_archive_info
    assert_respond_to(@tar, :archive_info)
    assert_nothing_raised{ @tar.create_archive('*.txt') }
    assert_equal(['temp1.txt','temp2.txt','temp3.txt'], @tar.archive_info)
  end

  def test_add_to_archive
    assert_respond_to(@tar,:add_to_archive)
    assert_nothing_raised{ @tar.create_archive('temp1.txt') }
    assert_nothing_raised{ @tar.add_to_archive('temp2.txt') }
    assert_nothing_raised{ @tar.add_to_archive('temp2.txt','temp3.txt') }
  end

  def test_update_archive
    assert_respond_to(@tar, :update_archive)
    assert_nothing_raised{ @tar.create_archive('*.txt') }
    assert_nothing_raised{ @tar.update_archive('temp2.txt') }
  end

  def test_extract_archive_basic
    assert_respond_to(@tar, :extract_archive)
  end

  def test_extract_archive_aliases
    assert_true(Tar::External.instance_method(:extract_archive) == Tar::External.instance_method(:expand_archive))
    assert_true(Tar::External.instance_method(:extract) == Tar::External.instance_method(:expand_archive))
    assert_true(Tar::External.instance_method(:expand) == Tar::External.instance_method(:expand_archive))
  end

  def test_extract_archive_advanced
    omit_unless(RbConfig::CONFIG['host_os'] =~ /sunos|solaris/){
      assert_nothing_raised{ @tar.tar_program = @@gtar }
    }
    assert_nothing_raised{ @tar.create('*.txt') }
    assert_raises(Tar::Error){ @tar.expand('blah.txt') }

    assert_nothing_raised{ @tar.extract_archive }
    assert_nothing_raised{ @tar.extract_archive('temp2.txt') }
  end

  def teardown
    @tar = nil
    File.delete('test.tar') if File.exist?('test.tar')
    File.delete('test.tar.gz') if File.exist?('test.tar.gz')
    File.delete('test.tar.bz2') if File.exist?('test.tar.bz2')
    File.delete('test.tar.zip') if File.exist?('test.tar.zip')
  end

  def self.shutdown
    @@tar_foudn   = nil
    @@gzip_found  = nil
    @@bzip2_found = nil

    File.delete(@@tmp_file1) if File.exist?(@@tmp_file1)
    File.delete(@@tmp_file2) if File.exist?(@@tmp_file2)
    File.delete(@@tmp_file3) if File.exist?(@@tmp_file3)
  end
end
