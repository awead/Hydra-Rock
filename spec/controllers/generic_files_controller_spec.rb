require 'spec_helper'

describe GenericFilesController do

  include Devise::TestHelpers

  describe "our index route" do
    it "should redirect to the sign in page" do
      get :index
      assert_redirected_to new_user_session_path
    end
  end

  describe "when the user is not signed in" do
    before :each do
      @routes = Sufia::Engine.routes
    end

    describe "#show" do
      it "should redirect to the catalog controller" do
        pending "Need a generic file fixture"
        get :show, :id => "changeme:12345"
        assert_redirected_to catalog_path "changeme:12345"
      end
    end
  end

  describe "when the user is signed in" do
    
    before :each do
      @user = FactoryGirl.create(:user)
      sign_in @user
      @routes = Sufia::Engine.routes
      @file = GenericFile.new.tap do |f|
        f.apply_depositor_metadata(@user.user_key)
        f.save!
      end
    end

    describe "#edit" do
      it "should be successful" do
        get :edit, id: @file
        response.should be_successful
      end
    end

    describe "#update" do
      it "should update all fields using a parameters hash" do
        post :update, id: @file, generic_file: {
          :title             => "New Title",
          :alternative_title => ["Alt title", "Another alt title"],
          :chapter           => ["chapter 1", "chapter 2"],
          :episode           => ["foo_episode", "bar_episode"],
          :segment           => ["foo_segment", "bar_segment"],
          :subtitle          => ["foo_subtitle", "bar_subtitle"],
          :track             => ["foo_track", "bar_track"],
          :translation       => ["foo_translation", "bar_translation"],
          :lc_subject        => ["foo_subject", "bar_subject"],
          :summary           => ["foo_summary", "bar_summary"],
          :contents          => ["foo_contents", "bar_contents"],
          :lc_genre          => ["foo_genre", "bar_genre"],
          :note              => ["foo_note", "bar_note"],
          :accession_number  => ["foo_accession_number", "bar_accession_number"]
        }
        @file.reload
        @file.title.should == "New Title"
        @file.alternative_title[0].should == "Alt title"
        @file.chapter[0].should == "chapter 1"
        @file.episode[0].should == "foo_episode"
        @file.segment[0].should == "foo_segment"
        @file.subtitle[0].should == "foo_subtitle"
        @file.track[0].should == "foo_track"
        @file.translation[0].should == "foo_translation"
        @file.subject[0].should == "foo_subject"
        @file.summary[0].should == "foo_summary"
        @file.contents[0].should == "foo_contents"
        @file.genre[0].should == "foo_genre"
        @file.note[0].should == "foo_note"
        @file.accession_number[0].should == "foo_accession_number"
        @file.alternative_title[1].should == "Another alt title"
        @file.chapter[1].should == "chapter 2"
        @file.episode[1].should == "bar_episode"
        @file.segment[1].should == "bar_segment"
        @file.subtitle[1].should == "bar_subtitle"
        @file.track[1].should == "bar_track"
        @file.translation[1].should == "bar_translation"
        @file.subject[1].should == "bar_subject"
        @file.summary[1].should == "bar_summary"
        @file.contents[1].should == "bar_contents"
        @file.genre[1].should == "bar_genre"
        @file.note[1].should == "bar_note"
        @file.accession_number[1].should == "bar_accession_number"
      end

    end


    describe "#create" do

      before do
        GenericFile.delete_all
        #@mock_upload_directory = "tmp/mock_upload_directory"
        #Dir.mkdir @mock_upload_directory unless File.exists? @mock_upload_directory
        #FileUtils.copy("spec/fixtures/images/rrhof.tif", @mock_upload_directory)
        #FileUtils.copy("spec/fixtures/images/test_image.tif", @mock_upload_directory)
        #FileUtils.cp_r('spec/fixtures/import', @mock_upload_directory)
        #@user.update_attribute(:directory, @mock_upload_directory)
      end

      after do
        #FileContentDatastream.any_instance.stub(:live?).and_return(true)
        GenericFile.destroy_all
      end

      it "should create and save a file asset from the given params" do
        date_today = Date.today
        Date.stub(:today).and_return(date_today)
        file = fixture_file_upload("spec/fixtures/images/rrhof.tif","spec/fixtures/images/test_image.tif")
        xhr :post, :create, :files=>[file], :Filename=>"The world", :batch_id => "sample:batch_id", :permission=>{"group"=>{"public"=>"read"} }, :terms_of_service => "1"
        response.should be_success
        #gf = GenericFile.all.first
        #puts gf.label
        #puts gf.checksum
        #GenericFile.count.should == @file_count + 1
        #saved_file = GenericFile.find("test:123")
        ## This is confirming that the correct file was attached
        #saved_file.label.should == "world.png"
        #saved_file.content.checksum.should == "f794b23c0c6fe1083d0ca8b58261a078cd968967"
        #saved_file.content.dsChecksumValid.should be_true
        ## Confirming that date_uploaded and date_modified were set
        #saved_file.date_uploaded.should == date_today
        #saved_file.date_modified.should == date_today
      end

      xit "should ingest files from the filesystem" do
        post :create, local_file: ["rrhof.tif", "test_image.tif"], batch_id: "xw42n7934"
        #lambda { post :create, local_file: ["rrhof.tif", "test_image.tif"], batch_id: "xw42n7934"}.should change(GenericFile, :count).by(2)
        #response.should redirect_to Sufia::Engine.routes.url_helpers.batch_edit_path("xw42n7934")
        # These files should have been moved out of the upload directory
        #File.exist?("#{@mock_upload_directory}/test_image.tif").should be_false
        #File.exist?("#{@mock_upload_directory}/rrhof.tof").should be_false
        # And into the storage directory
        files = GenericFile.find(Solrizer.solr_name("is_part_of",:symbol) => "info:fedora/sufia:xw42n7934")
        #debugger
        files.each do |gf|
          File.exist?(gf.content.filename).should be_true
          gf.thumbnail.mimeType.should == "image/tif"
        end
        files.first.title.should == "rrhof.tif"
        files.first.unarranged.should == false
        files.last.title.should == "test_image.tif"
      end

      xit "should ingest directories from the filesystem" do
        #TODO this test is very slow because it kicks off CharacterizeJob.
        lambda { post :create, local_file: ["world.png", "import"], batch_id: "xw42n7934"}.should change(GenericFile, :count).by(4)
        response.should redirect_to Sufia::Engine.routes.url_helpers.batch_edit_path('xw42n7934')
        # These files should have been moved out of the upload directory
        File.exist?("#{@mock_upload_directory}/import/manifests/manifest-broadway-or-bust.txt").should be_false
        File.exist?("#{@mock_upload_directory}/import/manifests/manifest-nova-smartest-machine-1.txt").should be_false
        File.exist?("#{@mock_upload_directory}/import/metadata/broadway_or_bust.pbcore.xml").should be_false
        File.exist?("#{@mock_upload_directory}/world.png").should be_false
        # And into the storage directory
        files = GenericFile.find(Solrizer.solr_name("is_part_of",:symbol) => 'info:fedora/sufia:xw42n7934')
        files.each do |gf|
          File.exist?(gf.content.filename).should be_true
        end
        files.first.label.should == 'world.png'
        files.first.unarranged.should be_true
        files.first.thumbnail.mimeType.should == 'image/png'
        files.last.relative_path.should == 'import/metadata/broadway_or_bust.pbcore.xml'
        files.last.unarranged.should be_true
        files.last.label.should == 'broadway_or_bust.pbcore.xml'
      end
    end


  end

end