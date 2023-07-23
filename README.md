# README

## Consideraciones

El escenario presentado, se asume que el proyecto, reciba datos existentes, de la venta de una disquera.
Para esto se asume o se inicializa, con las siguientes consideraciones:

1. Los artistas y usuarios son creados primeramente, asumiendo que sus datos son correctos.
1. A raiz de estos, se crea los albums, con la fecha establecida, y luego se incluye uno por uno, cada canción al que le pertenezca. (Se asume que la entrada se uniforme, ya que al finalizar, se añada la tabla de duración de dicho album # Se realiza de la siguiente forma para no recurrir al callback).
1. El registro de la compra u orden, para ello se crea el objeto, y luego se empieza a cargar datos de cada item de la orden
1. Finalmente se carga los datos del usuario y fecha donde se realiza la compra. (Se debe verificar que esta fecha se mayor igual que la fecha de nacionamiento de artistas, fecha de creación de albums, y para asegurarnos que no sea del futuro, debera tomar menor a igual que la fecha de hoy).

Para mayor entendimiento se plantea la siguiente logica:

```
create artist
create user
create album
  duration=0 # album duration
  while value=true
    create song, album_id
    duration+=song.duration
    value = false if end
  add duration
create order
  total=0
  while value_1=true
    create order_item, album_id
      sub_total=0
      while value_2=true
        add album.id
        add album.price as price
        add quantity
        sub_total+=price*quantity
        value_2 = false if end
      add sub_total
    value_1 = false if end
  add total
  add user
  add dates
```

## Creación de Modelos

1. ERD (Diagrama de relación de entidades).

   | Model       | Relation   | Model       |
   | :---------- | :--------- | :---------- |
   | artists     | has_many   | albums      |
   | albums      | belongs_to | artists     |
   | albums      | has_many   | songs       |
   | songs       | belongs_to | albums      |
   | albums      | has_many   | order_items |
   | order_items | belongs_to | albums      |
   | orders      | has_many   | order_items |
   | order_items | belongs_to | orders      |
   | users       | has_many   | orders      |
   | orders      | belongs_to | users       |

   |    Model    |   belong_to    |      has_many      |
   | :---------: | :------------: | :----------------: |
   |   albums    |    artists     | songs, order_items |
   |   artist    |       -        |       albums       |
   |    songs    |     albums     |         -          |
   | order_items | albums, orders |         -          |
   |   orders    |     users      |    order_items     |
   |    users    |       -        |       orders       |

1. Creando el modelo Artist

   ```
   rails generate model Artist name nationality birth_date:date death_date:date
   ```

   Adicionalmente se configura el archivo de migración, donde se encuentra la creación de la tabla, para asegurarnos que la base de datos no reciba un valor nulo para el atributo name, según lo requerido.

   ```
    class CreateArtists < ActiveRecord::Migration[7.0]
      def change
        create_table :artists do |t|
          t.string :name, null: false
          t.string :nationality
          t.date :birth_date
          t.date :death_date
          t.timestamps
        end
      end
    end
   ```

1. Creando el modelo
