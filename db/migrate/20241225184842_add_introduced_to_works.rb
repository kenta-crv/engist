class AddIntroducedToWorks < ActiveRecord::Migration[5.2]
  def change
    add_column :works, :introduced, :boolean
  end
end
