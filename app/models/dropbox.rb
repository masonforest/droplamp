class Dropbox
  def upload_dir(directory,path)
    Dir.foreach(directory) do |file|
      next if item == '.' or item == '..'
        puts file
    end
  end
end
