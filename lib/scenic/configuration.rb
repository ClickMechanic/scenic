module Scenic
  class Configuration
    # The Scenic database adapter instance to use when executing SQL.
    #
    # Defualts to an instance of {Adapters::Postgres}
    # @return Scenic adapter
    attr_writer :database
    attr_writer :migrations_path

    def initialize
      @database = Scenic::Adapters::Postgres.new
      @migrations_path = 'db/migrate'
    end
    
    def database(name = nil)
      name ? named_databases[name] : @database
    end
    
    def add_database(name, database)
      named_databases[name] = database
    end
    
    def migrations_path(name = nil)
      name ? named_migrations_paths[name] : @migrations_path
    end
    
    def add_migrations_path(name, path)
      named_migrations_paths[name] = path
    end
    
    private
    
    def named_databases
      @named_databases ||= {}
    end
    
    def named_migrations_paths
      @named_migrations_paths ||= {}
    end
  end

  # @return [Scenic::Configuration] Scenic's current configuration
  def self.configuration
    @configuration ||= Configuration.new
  end

  # Set Scenic's configuration
  #
  # @param config [Scenic::Configuration]
  def self.configuration=(config)
    @configuration = config
  end

  # Modify Scenic's current configuration
  #
  # @yieldparam [Scenic::Configuration] config current Scenic config
  # ```
  # Scenic.configure do |config|
  #   config.database = Scenic::Adapters::Postgres.new
  # end
  # ```
  def self.configure
    yield configuration
  end
end
