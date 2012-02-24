module RailsCsvFixtures
  module TestFixturesPatch
    extend ActiveSupport::Concern
    
    included do
      class << self
        alias_method_chain :fixtures, :csv_support
      end
    end
    
    module ClassMethods
      # TODO: Figure out a better way to do this and still keep forward compatability instead of intercepting :all
      def fixtures_with_csv_support(*fixture_names)
        # When using :all, intercept so we can list both the csv and yml files
        if fixture_names.first == :all
          fixture_names = Dir["#{fixture_path}/**/*.{csv,yml}"]
          fixture_names.map! { |f| f[(fixture_path.size + 1)..-5] }
        end

        # Continue on with all the names instead of :all
        fixtures_without_csv_support(*fixture_names)
      end
    end    
  end
end


# TODO: How do we accomplish the following load order without forcing it below?
# this is done in rails/help - how can we hook to do our include after?
class ActiveSupport::TestCase
  include ActiveRecord::TestFixtures
end
::ActiveSupport::TestCase.send :include, RailsCsvFixtures::TestFixturesPatch
