i = File.open(ARGV[0], 'r')
o = File.new("out/#{ARGV[0]}", 'w')

data = i.readlines.map(&:chomp).map { |l| l.split('') }
data.transpose.each { |l| o.write(l.join('') + "\n") }

i.close
o.close