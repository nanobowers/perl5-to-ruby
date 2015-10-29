require 'rake/clean'

# allow override of perl from the cmdline
perl = ENV['perl'] || 'perl'

desc "syntax check p2r"
task :check do
  sh "#{perl} -c ./bin/p2r"
end


good_tests = FileList.new("test/working/*.pl")
CLEAN.add( good_tests.ext("rb") )

desc "run p2r on testcases"
task :test do
  good_tests.each do |pfile| 
    out_rb = pfile.ext("rb")
    sh "./bin/p2r #{pfile} > #{out_rb}"
    ruby(out_rb) do |ok, result|
      if ok
        puts "PASSED test #{out_rb}"
      else
        puts "FAILED test #{out_rb}"
      end
    end
  end

end

task :default => [:check, :test]
