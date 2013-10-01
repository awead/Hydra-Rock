require 'spec_helper'

describe BatchUpdateJob do

  describe "with one file" do

    before do
      @user = FactoryGirl.find_or_create(:user)
      @batch = Batch.new
      @batch.save
      @file = GenericFile.new(:batch=>@batch)
      @file.apply_depositor_metadata(@user)
      @file.save
    end
    after do
      @batch.delete
      @file.delete
    end

    it "should process successfully" do
      s1 = double('one')
      ContentUpdateEventJob.should_receive(:new).with(@file.pid, @user.user_key).and_return(s1)
      Sufia.queue.should_receive(:push).with(s1).once
      params = {'generic_file' => {'read_groups_string' => '', 'read_users_string' => 'archivist1, archivist2' }, 'id' => @batch.pid, 'controller' => 'batch', 'action' => 'update'}.with_indifferent_access
      BatchUpdateJob.new(@user.user_key, params).run
      @user.mailbox.inbox[0].messages[0].subject.should == "Batch upload complete"
      @user.mailbox.inbox[0].messages[0].move_to_trash @user
    end

  end

  describe "with multiple files" do

    before do
      @user = FactoryGirl.find_or_create(:user)
      @batch = Batch.new
      @batch.save
      @file = GenericFile.new(:batch=>@batch)
      @file.apply_depositor_metadata(@user)
      @file.save
      @file2 = GenericFile.new(:batch=>@batch)
      @file2.apply_depositor_metadata(@user)
      @file2.save
    end
    after do
      @batch.delete
      @file.delete
      @file2.delete
    end

    it "should process successfully" do
      s1 = double('one')
      ContentUpdateEventJob.should_receive(:new).with(@file.pid, @user.user_key).and_return(s1)
      Sufia.queue.should_receive(:push).with(s1).once
      s2 = double('two')
      ContentUpdateEventJob.should_receive(:new).with(@file2.pid, @user.user_key).and_return(s2)
      Sufia.queue.should_receive(:push).with(s2).once
      params = {'generic_file' => {'read_groups_string' => '', 'read_users_string' => 'archivist1, archivist2' }, 'id' => @batch.pid, 'controller' => 'batch', 'action' => 'update'}.with_indifferent_access
      BatchUpdateJob.new(@user.user_key, params).run
      @user.mailbox.inbox[0].messages[0].subject.should == "Batch upload complete"
      @user.mailbox.inbox[0].messages[0].move_to_trash @user
    end

  end

end