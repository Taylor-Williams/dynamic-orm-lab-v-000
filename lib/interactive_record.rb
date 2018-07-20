require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord

  def self.table_name
    self.to_s.downcase.pluralize
  end

  def self.column_names
    DB[:conn].results_as_hash = true

    sql = "PRAGMA table_info('#{table_name}')"

    table_info = DB[:conn].execute(sql)
    column_names = []

    table_info.each do |column|
      column_names << column["name"]
    end

    column_names.compact
  end

  def initialize(attributes = {})
    attributes.each{ |a, v| self.send("#{a}=", v)}
  end

  def table_name_for_insert
    self.class.table_name
  end

  def col_names_for_insert
    self.class.column_names.reject!{|name| name == "id"}.join(", ")
  end

  def values_for_insert
    self.class.column_names.reject!{|name| name == "id"}.map{|a| "#{self.send(a)}"}.join(", ")
  end

end
