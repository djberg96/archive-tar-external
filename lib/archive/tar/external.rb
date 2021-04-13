require 'open3'

# The Archive module serves as a namespace only.
module Archive

  # The Tar class serves as a toplevel class namespace only.
  class Tar

    # Raised if something goes wrong during the execution of any methods
    # which use the tar command internally.
    class Error < StandardError; end

    # Raised if something goes wrong during the Tar#compress_archive or
    # Tar#uncompress_archive methods.
    class CompressError < StandardError; end

    # This class encapsulates tar & zip operations.
    class Tar::External
      # The version of the archive-tar-external library.
      VERSION = '1.4.1'.freeze

      # The name of the archive file to be used, e.g. "test.tar"
      attr_accessor :archive_name

      # The name of the tar program you wish to use.  The default is "tar".
      attr_accessor :tar_program

      # The name of the archive file after compression, e.g. "test.tar.gz"
      attr_reader :compressed_archive_name

      # Returns an Archive::Tar::External object.  The +archive_name+ is the
      # name of the tarball.  While a .tar extension is recommended based on
      # years of convention, it is not enforced.
      #
      # Note that this does not actually create the archive unless you
      # pass a value to +file_pattern+.  This then becomes a shortcut for
      # Archive::Tar::External.new + Archive::Tar::External#create_archive.
      #
      # If +program+ is provided, then it compresses the archive as well by
      # calling Archive::Tar::External#compress_archive internally.
      #
      def initialize(archive_name, file_pattern=nil, program=nil)
        @archive_name            = archive_name.to_s
        @compressed_archive_name = nil
        @tar_program             = 'tar'

        if file_pattern
          create_archive(file_pattern)
        end

        if program
          compress_archive(program)
        end
      end

      # Assign a compressed archive name.  This autogenerates the archive_name
      # based on the extension of the name provided, unless you provide the
      # extension yourself.  If the extension is '.tgz', then the base of the
      # name + '.tar' will be the new archive name.
      #
      # This should only be used if you have a pre-existing, compressed archive
      # that you want to uncompress, and want to have a Tar::External object
      # around.  Otherwise, use the class method Tar::External.uncompress.
      #
      def compressed_archive_name=(name, ext=File.extname(name))
        if ext.downcase == '.tgz'
          @archive_name = File.basename(name, ext.downcase) + '.tar'
        else
          @archive_name = File.basename(name, ext)
        end
        @compressed_archive_name = name
      end

      # Creates the archive using +file_pattern+ using +options+ or 'cf'
      # (create file) by default.
      #
      # Raises an Archive::Tar::Error if a failure occurs.
      #
      def create_archive(file_pattern, options = 'cf')
        cmd = "#{@tar_program} #{options} #{@archive_name} #{file_pattern}"

        Open3.popen3(cmd){ |_tar_in, _tar_out, tar_err|
          err = tar_err.gets
          raise Error, err.chomp if err
        }

        self
      end

      alias create create_archive

      # Compresses the archive with +program+, or gzip if no program is
      # provided.  If you want to pass arguments to +program+, merely include
      # them as part of the program name, e.g. "gzip -f".
      #
      # Any errors that occur here will raise a Tar::CompressError.
      #
      def compress_archive(program='gzip')
        cmd = "#{program} #{@archive_name}"

        Open3.popen3(cmd){ |_prog_in, _prog_out, prog_err|
          err = prog_err.gets
          raise CompressError, err.chomp if err

          # Find the new file name with the extension.  There's probably a more
          # reliable way to do this, but this should work 99% of the time.
          name = Dir["#{@archive_name}.{gz,bz2,cpio,zip}"].first
          @compressed_archive_name = name
        }

        self
      end

      alias compress compress_archive

      # Uncompresses the tarball using the program you pass to this method.  The
      # default is "gunzip".  Just as for +compress_archive+, you can pass
      # arguments along as part of the argument.
      #
      # Note that this is only for use with archives that have been zipped up
      # with gunzip, or whatever.  If you want to *extract* the files from the
      # tarball, use Tar::External#extract instead.
      #
      # Any errors that occur here will raise a Tar::CompressError.
      #
      def uncompress_archive(program="gunzip")
        unless @compressed_archive_name
          raise CompressError, "no compressed file found"
        end

        cmd = "#{program} #{@compressed_archive_name}"

        Open3.popen3(cmd){ |_prog_in, _prog_out, prog_err|
          err = prog_err.gets
          raise CompressError, err.chomp if err
          @compressed_archive_name = nil
        }
        self
      end

      alias uncompress uncompress_archive

      # Uncompress an existing archive, using +program+ to uncompress it.
      # The default decompression program is gunzip.
      #
      def self.uncompress_archive(archive, program='gunzip')
        cmd = "#{program} #{archive}"

        Open3.popen3(cmd){ |_prog_in, _prog_out, prog_err|
          err = prog_err.gets
          raise CompressError, err.chomp if err
        }
      end

      class << self
        alias uncompress uncompress_archive
      end

      # Returns an array of file names that are included within the tarball.
      # This method does not extract the archive.
      #
      def archive_info
        result = []
        cmd = "#{@tar_program} tf #{@archive_name}"
        Open3.popen3(cmd){ |_ain, aout, aerr|
          err = aerr.gets
          raise Error, err.chomp if err

          while output = aout.gets
            result << output.chomp
          end
        }
        result
      end

      alias info archive_info

      # Adds +files+ to an already existing archive.
      #
      def add_to_archive(*files)
        if files.empty?
          raise Error, "there must be at least one file specified"
        end

        cmd = "#{@tar_program} rf #{@archive_name} #{files.join(" ")}"

        Open3.popen3(cmd){ |_ain, _aout, aerr|
          err = aerr.gets
          raise Error, err.chomp if err
        }
        self
      end

      alias add add_to_archive

      # Updates the given +files+ in the archive, i.e. they are added if they
      # are not already in the archive or have been modified.
      #
      def update_archive(*files)
        if files.empty?
          raise Error, "there must be at least one file specified"
        end

        cmd = "#{@tar_program} uf #{@archive_name} #{files.join(" ")}"

        Open3.popen3(cmd){ |_ain, _aout, aerr|
          err = aerr.gets
          raise Error, err.chomp if err
        }

        self
      end

      alias update update_archive

      # Expands the contents of the tarball.  It does NOT delete the tarball.
      # If +files+ are provided, then only those files are extracted.
      # Otherwise, all files are extracted.
      #
      # Note that some tar programs, notably the tar program shipped by Sun,
      # does not issue any sort of warning or error if you try to extract a
      # file that does not exist in the archive.
      #
      def extract_archive(*files)
        cmd = "#{@tar_program} xf #{@archive_name}"

        unless files.empty?
          cmd << " " << files.join(" ")
        end

        Open3.popen3(cmd){ |_ain, _aout, aerr|
          err = aerr.gets
          raise Error, err.chomp if err
        }

        self
      end

      alias expand_archive extract_archive
      alias extract extract_archive
      alias expand extract_archive

      # A class method that behaves identically to the equivalent instance
      # method, except that you must specifiy that tarball as the first
      # argument. Also, the tar program is hard coded to 'tar xf'.
      #
      def self.extract_archive(archive, *files)
        cmd = "tar xf #{archive}"

        unless files.empty?
          cmd << " " << files.join(" ")
        end

        Open3.popen3(cmd){ |_ain, _aout, aerr|
          err = aerr.gets
          raise Error, err.chomp if err
        }

        self
      end

      class << self
        alias expand_archive extract_archive
        alias extract extract_archive
        alias expand extract_archive
      end
    end
  end
end
