require "spec_helper"

module Scenic
  describe Configuration do
    after { restore_default_config }

    it "defaults the database adapter to postgres" do
      expect(Scenic.configuration.database).to be_a Adapters::Postgres
      expect(Scenic.database).to be_a Adapters::Postgres
    end

    it "allows the database adapter to be set" do
      adapter = double("Scenic Adapter")

      Scenic.configure do |config|
        config.database = adapter
      end

      expect(Scenic.configuration.database).to eq adapter
      expect(Scenic.database).to eq adapter
    end
    
    describe 'adding a named database adapter' do
      let(:adapter) { double("Scenic Adapter") }
      let(:named_adapter) { double("Named Adapter") }
      
      before do
        Scenic.configure do |config|
          config.database = adapter
          config.add_database('test', named_adapter)
        end
      end
      
      it 'sets the named adapter' do
        expect(Scenic.configuration.database('test')).to eq named_adapter
        expect(Scenic.database('test')).to eq named_adapter
      end
      
      it 'still recognizes the default adapter' do
        expect(Scenic.configuration.database).to eq adapter
        expect(Scenic.database).to eq adapter
      end
    end
    
    it "defaults the migrations path to db/migrate" do
      expect(Scenic.configuration.migrations_path).to eq 'db/migrate'
    end

    it "allows the migration path to be set" do
      Scenic.configure do |config|
        config.migrations_path = 'some/migration/path'
      end

      expect(Scenic.configuration.migrations_path).to eq 'some/migration/path'
      expect(Scenic.migrations_path).to eq 'some/migration/path'
    end

    def restore_default_config
      Scenic.configuration = Configuration.new
    end
    
    
    describe 'adding a named migrations path' do
      let(:path) { 'default/path' }
      let(:named_path) { 'named/migrations/path' }
      
      before do
        Scenic.configure do |config|
          config.migrations_path = path
          config.add_migrations_path('test', named_path)
        end
      end
      
      it 'sets the named migrations path' do
        expect(Scenic.configuration.migrations_path('test')).to eq named_path
        expect(Scenic.migrations_path('test')).to eq named_path
      end
      
      it 'still recognizes the default path' do
        expect(Scenic.configuration.migrations_path).to eq path
        expect(Scenic.migrations_path).to eq path
      end
    end
  end
end
