class AddEventNotes < ActiveRecord::Migration
  def self.up
    add_column :events, :notes, :string
    Event.all.each { |e|
      e.notes = e.evtstarttime.to_s
      e.save
    }
  end

  def self.down
    remove_column :events, :notes
  end
end
