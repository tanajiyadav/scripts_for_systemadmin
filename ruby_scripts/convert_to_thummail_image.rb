require 'RMagick'
include Magick
Dir['*.[Jj][Pp]*[Gg]'].each do | pic |
    image = Image.read(pic)[0]
    next if pic =~ /^th_/
    puts "Scaling down by 10% --- #{pic}"

    thumbnail = image.scale(0.10)

    if File.exists?("th_#{pic}")
        puts "Could not write file, thumbnail already exists."
        next
    end
        thumbnail.write "th_#{pic}"
end        


