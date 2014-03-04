require 'csv'
require 'erb'

module RailsCsvFixtures
  module CsvFixtures
    extend ActiveSupport::Concern

    included do
      alias_method_chain :read_fixture_files, :csv_support
    end

    def read_fixture_files_with_csv_support
      if ::File.file?(csv_file_path)
        read_csv_fixture_files
      else
        read_fixture_files_without_csv_support
      end
    end

    def read_csv_fixture_files
      reader = CSV.parse(erb_render(IO.read(csv_file_path)))
      header = reader.shift
      i = 0
      reader.each do |row|
        data = {}
        row.each_with_index { |cell, j| data[header[j].to_s.strip] = cell.nil? ? nil : cell.to_s.strip }
        fixtures["#{@class_name.to_s.underscore}_#{i+=1}"] = ActiveRecord::Fixture.new(data, model_class)
      end
    end

    def csv_file_path
      @path + '.csv'
    end

    def erb_render(fixture_content)
      ERB.new(fixture_content).result
    end
  end
end

require 'active_record/fixtures'
::ActiveRecord::FixtureSet.send :include, RailsCsvFixtures::CsvFixtures
