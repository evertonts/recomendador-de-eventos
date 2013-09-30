class CreateEventos < ActiveRecord::Migration
  def change
    create_table :eventos do |t|
      t.string :titulo
      t.string :localizacao
      t.string :data
      t.text :descricao

      t.timestamps
    end
  end
end
