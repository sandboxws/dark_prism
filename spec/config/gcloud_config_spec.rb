require 'spec_helper'

RSpec.describe DarkPrism::Config::GcloudConfig do
  let(:instance) { DarkPrism::Config::GcloudConfig.instance }
  let(:credentials) {
    {
      'type'=>'service_account',
      'project_id'=>'foobar',
      'private_key_id'=>'some_private_key',
      'private_key'=>"-----BEGIN PRIVATE KEY-----\nfoobar\n-----END PRIVATE KEY-----\n",
      'client_email'=>'me@foobar.iam.gserviceaccount.com',
      'client_id'=>'my_client_id',
      'auth_uri'=>'https://accounts.google.com/o/oauth2/auth',
      'token_uri'=>'https://accounts.google.com/o/oauth2/token',
      'auth_provider_x509_cert_url'=>'https://www.googleapis.com/oauth2/v1/certs',
      'client_x509_cert_url'=>'https://www.googleapis.com/robot/v1/metadata/x509/foobar.iam.gserviceaccount.com'}
  }

  it 'should be a singleton' do
    expect(
      DarkPrism::Config::GcloudConfig.included_modules.include?(Singleton)
    ).to be true
  end

  describe 'attributes' do
    it { expect(instance).to have_attr_reader(:pubsub) }
    it { expect(instance).to have_attr_accessor(:project_id) }
    it { expect(instance).to have_attr_accessor(:credentials) }
  end

  describe '.configure' do
    it 'should throw a NoBlockGivenException when no block is given' do
      expect {
        DarkPrism::Config::GcloudConfig.configure
      }.to raise_exception(DarkPrism::NoBlockGivenException)
    end

    it 'should successfully initialize a config instance' do
      config = DarkPrism::Config::GcloudConfig.configure do |config|
        config.project_id = 'my_project_id'
        config.credentials = credentials
      end

      expect(config.project_id).to eq('my_project_id')
    end
  end

  describe '#initialize' do
    before do
      expect_any_instance_of(DarkPrism::Config::GcloudConfig).to receive(:prepare_pubsub).once
    end

    DarkPrism::Config::GcloudConfig.instance
  end

  describe '#prepare_pubsub' do
    it 'should return nil if the config is invalid' do
      instance.project_id = nil
      expect(instance.prepare_pubsub).to be_nil
    end

    it 'should return a google pubsub instance when config is valid' do
      instance.project_id = 'foobar'
      instance.credentials = credentials
      pubsub_double = double(Google::Cloud::Pubsub)
      allow(Google::Cloud::Pubsub).to receive(:new).and_return(pubsub_double)

      expect(instance.prepare_pubsub).to be_a pubsub_double.class
    end
  end

  describe '#valid?' do
    it 'should return false if project_id or credentials is missing' do
      instance.project_id = 'foobar'
      instance.credentials = nil
      expect(instance.valid?).to be false

      instance.project_id = nil
      instance.credentials = 'path/to/keyfile.json'
      expect(instance.valid?).to be false
    end

    it 'should return true if project_id and credentials are set' do
      instance.project_id = 'foobar'
      instance.credentials = 'path/to/keyfile.json'
      expect(instance.valid?).to be true
    end
  end
end
