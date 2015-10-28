
perl = ENV['perl'] || 'perl'


desc "syntax check p2r"
task :check do
  sh "#{perl} -c ./bin/p2r"
end

desc "run p2r on testcases"
task :test do
  good_tests = FileList.new("test/working/*.pl")
  
  good_tests.each do |pfile| 
    out = pfile.ext("rb").sub(
    sh "./bin/p2r #{pfile} > #{out}"
  end

end

task :default => [:check, :test]
