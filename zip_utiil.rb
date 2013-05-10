require 'zip/zip'

class ZipFileGenerator

  # Initialize with the directory to zip and the location of the output archive.
  def initialize(inputDir, outputFile)
    @inputDir = inputDir
    @outputFile = outputFile
  end

  # Zip the input directory.
  def write()
    entries = Dir.entries(@inputDir); entries.delete("."); entries.delete("..") 
    io = Zip::ZipFile.open(@outputFile, Zip::ZipFile::CREATE); 

    writeEntries(entries, "", io)
    io.close();
  end

  #unzip file
  def unzip_file (file, destination)
    Zip::ZipFile.open(file) { |zip_file|
      zip_file.each { |f|
        f_path=File.join(destination, f.name)
        FileUtils.mkdir_p(File.dirname(f_path))
       zip_file.extract(f, f_path) unless File.exist?(f_path)
      }
    }
  end
  

  # A helper method to make the recursion work.
  private
  def writeEntries(entries, path, io)
    
    entries.each { |e|
      zipFilePath = path == "" ? e : File.join(path, e)
      diskFilePath = File.join(@inputDir, zipFilePath)
      puts "Deflating " + diskFilePath
      if  File.directory?(diskFilePath)
        io.mkdir(zipFilePath)
        subdir =Dir.entries(diskFilePath); subdir.delete("."); subdir.delete("..") 
        writeEntries(subdir, zipFilePath, io)
      else
        io.get_output_stream(zipFilePath) { |f| f.puts(File.open(diskFilePath, "rb").read())}
      end
    }
  end

    
end

a = ZipFileGenerator.new('/home/ubuntu/workspace/Deploycode/test/demo','/home/ubuntu/workspace/Deploycode/test/demo.zip')
#a.write

a.unzip_file('/home/ubuntu/workspace/Deploycode/test/demo.zip','/home/ubuntu/workspace/Deploycode/test/demo')
