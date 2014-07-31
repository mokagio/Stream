desc "Runs the unit tests for the project"
task :test do
  system "xcodebuild \
    -workspace Stream.xcworkspace \
    -scheme Stream \
    -sdk iphonesimulator \
    -destination 'name=iPhone Retina (4-inch)' \
    test | xcpretty -t --color"
end

desc "Builds a distributable version of the app"
task :build do
  puts "Pretending to be building"
end
