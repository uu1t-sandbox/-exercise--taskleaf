class ChangeTasksNameLimit30 < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up   { change_column :tasks, :name, :string, limit: 30 }
      dir.down { change_column :tasks, :name, :string }
    end
  end
end
