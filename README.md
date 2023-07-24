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
    create order_item, album_id, user_id
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

   ![ERD](ERD.jpg)

   A continuación se muestran las relaciones correspondientes entre los modelos:

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

   Se resumen para cada modelo en:
   | Model | belong_to | has_many |
   | :---------: | :------------: | :----------------: |
   | albums | artists | songs, order_items |
   | artist | - | albums |
   | songs | albums | - |
   | order_items | albums, orders | - |
   | orders | users | order_items |
   | users | - | orders |

1. Creación de modeles desde la entrada de la terminal:

   ```
   rails generate model Artist name nationality birth_date:date death_date:date
   rails generate model User username email password first_name last_name flag:boolean
   rails generate model Album name price:integer artist:references
   rails generate model Song name duration:integer album:references
   rails generate model Order total:integer order_date:date user:references
   rails generate model OrderItem quantity:integer sub_total:integer album:references order:references
   ```

1. Creación de las migraciones solicitadas:

   ```
    rails generate migration AddBiographyToArtists
    rails generate migration AddDurationToAlbums
    rails generate migration AddIndexToUsers
    rails generate migration ChangeDataTypeForBiographyInArtists
   ```

   Se debe incluir el siguiente codigo,, para las migraciones correspondientes

   ```
     def change
      add_colunm :artists, :biography, :string
     end
     def change
      add_column  :albums, :duration, :integer
     end
     def change
      add_index :users, :username
      add_index :users, :email
     end
     def up
      change_column :artists, :biography, :text
     end
     def down
      change_column :artists, :biography, :string
     end
   ```

1. Edición de la validación para la base de datos.
   A raiz de estas, se realiza la validación para el modelo.

   | Model     | Null False          |
   | --------- | ------------------- |
   | Album     | name, price         |
   | Song      | name, duration      |
   | Artist    | name                |
   | User      | name, email         |
   | OrderItem | sub_total, quantity |
   | Orders    | total, date         |

## Validaciones en los Modelos.
