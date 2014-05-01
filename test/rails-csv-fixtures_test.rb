require 'test_helper'

class RailsCsvFixturesTest < ActiveSupport::TestCase
  test 'should read csv fixtures' do
    if ::ActiveRecord::VERSION::MAJOR < 4
      _fixtures = ActiveRecord::Fixtures.new(Account.connection, 'accounts', 'Account', File.join(fixture_path, 'accounts'))
    else
      _fixtures = ActiveRecord::FixtureSet.new(Account.connection, 'accounts', Account, File.join(fixture_path, 'accounts'))
    end

    assert_not_nil _fixtures
    assert _fixtures.fixtures.any?
  end

  test 'should load fixtures in test case' do
    assert_nothing_raised do
      ActiveSupport::TestCase.fixtures(:all)
      ActiveSupport::TestCase.fixtures(:accounts)
    end
  end
end
