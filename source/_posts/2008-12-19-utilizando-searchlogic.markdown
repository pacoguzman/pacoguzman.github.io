---
layout: post
title: Utilizando Searchlogic
date:   2008-12-19 15:34:41
categories:
---

De entre los repositorios de GitHub que sigo se encuentra SearchLogic. Una gema que facilita la búsqueda, paginación, y ordenación and more! en objetos ActiveRecord.

En una aplicación que estoy trabajando me ha surgido la necesidad de crear un buscador (formulario) en el que se pueden incluir ciertos criterio de búsqueda, la lista de los mismos esta por ampliar.

Dentro de los criterios actuales se encuentra la posiblidad de introducir keywords y dentro de un select determinar un rango numérico de distancia a utilizar en la búsqueda.

Como este formulario crecerá con el tiempo he querido buscar una solución que me permite introducir nuevos criterios de forma poco invasiva y sin reinventar la rueda.

Entremos en detalle:

Con SearchLogic es posible establecer condiciones de búsqueda de keywords del siguiente modo:

>  :keywords                     :kwords, :kw                        Splits into each word and omits meaningless words, a true keyword search

```ruby
search.conditions( :keywords => params[:search][:keywords])
```

Sin embargo en mi caso quiero buscar keywords en dos campos por lo que tengo que crear un grupo con condicion OR ya que no es necesario que el keyword este presente en ambos campos. Hago lo siguiente<

```ruby
search.conditions.group do |group|
 group.nombre_kw = params[:search][:keyword]
 group.or_descripcion_kw = params[:search][:keyword]
end
# SELECT rutas.* FROM rutas WHERE ( rutas.nombre LIKE "%keyword1%" OR rutas.descripcion LIKE "%keyword1%" AND rutas.nombre LIKE "%keywordi%" OR rutas.descripcion LIKE "%keywordi%")
```

o bien

```ruby
search(:conditions => {:group => {:name_kw => keyword, :or_descripcion_kw => keyword }} )
```

Por lo tanto me creo el siguiente método

```ruby
def condicion_distancia(code)
  code ||= "0"
  case code
    when "0"; {}
    when "1"; {:distancia_lt => 10}
    when "2"; {:distancia_gte => 10, :distancia lt => 25}
    when "3"; {:distancia_gte => 25, :distancia lt => 50}
    when "4"; {:distancia_gte => 50}
  end
end
```

Para los rangos numéricos de distancia los establezco por correspondencia con un código del siguiente modo:

```ruby
def condicion_distancia(code)
  code ||= "0"
  case code
    when "0"; {}
    when "1"; {:distancia_lt => 10}
    when "2"; {:distancia_gte => 10, :distancia lt => 25}
    when "3"; {:distancia_gte => 25, :distancia lt => 50}
    when "4"; {:distancia_gte => 50}
  end
end
```

```ruby
search(:conditions => condificion_distancia(params[:search][:distance]))
``

Para agrupar todas las condiciones de cada uno de los criterios de búsqueda que vaya a establecer me he creado el siguiente método

```ruby
def compute_searchlogic_conditions(search)
  conditions = {}
  conditions.merge!(condicion_distancia(search[:distancia])) unless search[:distancia].blank?
  conditions.merge!(condicion_keywords(search[:keywords])) unless search[:keywords].blank?
  # Sucesivas condiciones
end
```

Ahora solo queda utilizarlo en el controlador

```ruby
def index
  search = Ruta.new_search(:conditions => compute_searchlogic_conditions(params[:search]))
  rutas = search.all.paginate(:page => @page, :per_page => 10, :order => @order)
end
```

Con SearchLogic es posible incluir la paginación y la ordenación a la hora crear el objeto search pero incluye su propio sistema de paginación y no es compatible directamente con mislav-will_paginate. Si se quiere usar la paginación de SearchLogic lo hariamos de la siguiente forma:
