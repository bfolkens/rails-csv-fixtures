require 'csv'
require 'erb'

module RailsCsvFixtures
  module CsvFixtures
    extend ActiveSupport::Concern

    included do
      alias_method :read_fixture_files_without_csv_support, :read_fixture_files
      alias_method :read_fixture_files, :read_fixture_files_with_csv_support
    end

    def read_fixture_files_with_csv_support(*args)
      if ::File.file?(csv_file_path(*args))
        read_csv_fixture_files(*args)
      else
        read_fixture_files_without_csv_support(*args)
      end
    end

    def read_csv_fixture_files(*args)
      fixtures = fixtures() || {}
      reader = CSV.parse(erb_render(IO.read(csv_file_path(*args))))
      header = reader.shift
      i = 0
      reader.each do |row|
        data = {}
        row.each_with_index { |cell, j| data[header[j].to_s.strip] = cell.nil? ? nil : cell.to_s.strip }
        class_name = (args.second || model_class && model_class.name)
        fixtures["#{class_name.to_s.underscore}_#{i+=1}"] = ActiveRecord::Fixture.new(data, model_class)
      end
      fixtures
    end

    def csv_file_path(*args)
      (args.first || @path || @fixture_path) + '.csv'
    end

    def erb_render(fixture_content)
      ERB.new(fixture_content).result
    end
  end
end

require 'active_record/fixtures'
if ::ActiveRecord::VERSION::MAJOR < 4
  ::ActiveRecord::Fixtures.send :include, RailsCsvFixtures::CsvFixtures
else
  ::ActiveRecord::FixtureSet.send :include, RailsCsvFixtures::CsvFixtures
end
