require 'rake/clean'
verbose(1)

# allow override of perl from the cmdline
perl = ENV['perl'] || 'perl'

desc "syntax check p2r"
task :check do
  sh "#{perl} -c ./bin/p2r"
end


good_tests = FileList.new("test/working/*.pl")
CLEAN.add( good_tests.ext("rb") )

def run_rb_test rbfile, opts=""
  ruby("#{opts} #{rbfile} > /dev/null") do |ok, result|
    if ok
      puts "\033[32mPASSED\033[0m test #{rbfile}"
    else
      puts "\033[31mFAILED\033[0m test #{rbfile}"
    end
  end
end

desc "run p2r on testcases"
task :regression_test do
  good_tests.each do |pfile| 
    out_rb = pfile.ext("rb")
    sh "./bin/p2r #{pfile} > #{out_rb}"
    run_rb_test(out_rb)
  end
end

task :default => [:check, :regression_test]

desc "run p2r on testcases"
task :testc do
  good_tests.each do |pfile| 
    out_rb = pfile.ext("rb")
    sh "./bin/p2r #{pfile} > #{out_rb}"
    run_rb_test(out_rb, '-c')
  end
end

task :unit_test do
  sh "prove -I lib/perl"
end

desc "unit tests"
task :unit => :unit_test
