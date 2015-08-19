class AddBrowserColumnToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :browser, :string, null: false
  end
end
