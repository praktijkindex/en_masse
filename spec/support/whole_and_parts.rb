require "active_record"

class CreateWholesAndParts < ActiveRecord::Migration[4.2]
  def change
    create_table :wholes do |t|
      t.timestamps
    end

    create_table :parts do |t|
      t.timestamps
      t.belongs_to :whole
      t.integer :status
    end
  end
end

class Whole < ActiveRecord::Base
  has_many :parts
end

class Part < ActiveRecord::Base
  belongs_to :whole
  enum status: [:old, :new, :broken], _prefix: true
end

shared_context "whole and parts" do
  before :context do
    CreateWholesAndParts.migrate :up
    Whole.reset_column_information
    Part.reset_column_information
  end

  after :context do
    CreateWholesAndParts.migrate :down
  end
end
