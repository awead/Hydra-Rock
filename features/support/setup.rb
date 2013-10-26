# Various setup actions taken befor and after our cucumber tests

Before do
  ActiveRecord::FixtureSet.reset_cache
  ActiveRecord::FixtureSet.create_fixtures(File.join(Rails.root, 'spec', 'fixtures', 'ar'), [:activities, :users])
end

# Creates a sample video with an attached tape, and digital file
Before '@sample' do

  # ArchivalVideo
  av = ArchivalVideo.new(:pid => "cucumber:1")  
  av.title = "Cucumber Sample 1"
  av.reviewer = "reviewer1@example.com"
  av.abstract = "We don't have permission to show this to the public"
  av.save

  # Tape
  tape = ExternalVideo.new(:pid => "cucumber:2")
  tape.define_physical_instantiation
  tape.save

  # File
  file = ExternalVideo.new(:pid => "cucumber:3")
  file.define_digital_instantiation
  file.save
  
  av.external_videos << tape
  av.external_videos << file
  av.save
  tape.save
  file.save
end

After '@sample' do
  av = ArchivalVideo.find("cucumber:1")
  av.delete

  tape = ExternalVideo.find("cucumber:2")
  tape.delete
end

# Creates a two sample videos with an attached tape, and digital file
# to test importing features.
Before '@import' do
  # ArchivalVideo
  av1 = ArchivalVideo.new(:pid => "cucumber:1")  
  av2 = ArchivalVideo.new(:pid => "cucumber:2")
  av1.title = "Cucumber Sample 1"
  av2.title = "Cucumber Sample 2"
  av1.save
  av2.save

  # Tape
  tape1 = ExternalVideo.new(:pid => "cucumber:3")
  tape1.define_physical_instantiation
  tape1.barcode = "1"
  tape1.save
  tape2 = ExternalVideo.new(:pid => "cucumber:4")
  tape2.barcode = "2"
  tape2.define_physical_instantiation
  tape2.save

  # File
  file1 = ExternalVideo.new(:pid => "cucumber:5")
  file1.define_digital_instantiation
  file1.save
  file2 = ExternalVideo.new(:pid => "cucumber:6")
  file2.define_digital_instantiation
  file2.save
  
  av1.external_videos = [tape1, file1]
  av2.external_videos = [tape2, file2]
  av1.save
  av2.save
  tape1.save
  file1.save
  tape2.save
  file2.save
end

After '@import' do
  (1..6).each do |n|
    av = ActiveFedora::Base.find("cucumber:"+n.to_s)
    av.delete
  end
end

Before '@javascript' do
  Capybara.current_session.driver.browser.manage.window.resize_to(1280, 1024)
end

After '@javascript' do
  page.execute_script "window.close();"
end

Before '@multiple-persons' do
  av = ArchivalVideo.find("cucumber:1")
  av.new_contributor({:name => "John"})
  av.new_contributor({:name => "Paul"})
  av.new_contributor({:name => "George"})
  av.new_contributor({:name => "Ringo"})
  av.new_publisher({:name => "Apple"})
  av.new_publisher({:name => "Bannana"})
  av.new_publisher({:name => "Tomato"})
  av.save
end
