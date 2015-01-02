---
layout: post
title: Una de asociaciones has_many :through en ultrasphinx
date:   2009-11-02 13:30:50
description: ''
tags: ['ruby', 'rails', 'ultrasphinx']
---

Durante las últimas semanas o mejor dicho, el último par de meses he estado trabajando con proyectos que presentan funcionalidades de búsqueda de texto en aplicaciones Rails, utilizando el plugin [ultrasphinx](http://github.com/fauna/ultrasphinx/).

En esta entrada no voy a contar que es ultrasphinx ni como utilizarlo en detalle, pero si intentaré explicar como solucione un problema que tuve al introducir una nueva asociación sobre la que la aplicación debía realizar búsquedas.

Un punto que conviene no olvidar cuando se utiliza la instrucción:

{% highlight ruby %}
 class model < ActiveRecord::Base
   is_indexed
 end
{% endhighlight %}

Es que con esta instrucción y tras ejecutar las tareas que incorpora el plugin de ultrasphinx se generan los índices sobre los que se realizarán las consultas. Estos índices quedan definidos por una o varias queries que podemos consultar en los ficheros *.conf y que también generan las tareas de ultrasphinx. Llevarnos estas queries a nuestro query browser favorito y jugar con ellas nos permite comprobar porque los resultados que devuelve nuestra aplicación no son los que esperábamos, al menos en cierta medida.

Y ya vamos con el problema que me encontre. El problema radica en como generar el índice que permite realizar búsquedas a través de asociaciones has_many. Teniendo los siguientes modelos:

{% highlight ruby %}
 class User < ActiveRecord::Base
   has_many :recipes
   has_many :ingredients, :through => :recipes
 end
 class Recipe < ActiveRecord::Base
   has_many :ingredients
 end
{% endhighlight %}

La búsqueda a implementar son búsquedas de usuarios por ingredientes, vale pues a configurar el índice con un poco de DSL:<

{% highlight ruby %}
 class User < ActiveRecord::Base
   ...
   is_indexed :fields => [{:field => 'email', :as => 'user_email'}],
              :include => [{
                 :association_name => "ingredient",
                 :field => 'name',
                 :association_sql => "LEFT OUTER JOIN recipies on recipes.user_id = users.id LEFT OUTER JOIN ingredients on ingredients.recipe_id = recipes.id"}]
   ...
 end
{% endhighlight %}

Pero esto no funciona, ya que el índice solo lo forman el primer ingrediente de cada receta. Hecho que puede llevar perfectamente a que la jodas. La pista me la dio la query que se genera en los ficheros .conf. Cogí esa query la coloque en el query browser y solo aparecieron los nombres de los primeros ingredientes, el resto de ingredientes no existían.

En la query se realiza una agrupación por users.id lo que lleva a que se pierdan el resto de ingredientes. La solución era sencilla crear un nuevo campo en la query en la que se guardarán en forma de lista los ingredientes asociados. ¿Pero eso como lo llevamos al DSL de ultrasphinx?

La solución la encontré en este hilo ["How to set up a has_many :through association with Ultrasphinx"](http://www.ruby-forum.com/topic/179278)

Tenemos que indicarle a ultrasphinx que queremos concatenar los ingredientes, para que aparezcan todos y cada uno de los ingredientes asociados a la receta. Así que nos quedamos con esto:

{% highlight ruby %}
 class User < ActiveRecord::Base
   ...
   is_indexed :fields => [{:field => 'email', :as => 'user_email'}],
              :concatenate => [{
                   :class_name => 'Ingredient',
                   :field => 'name',
                   :association_sql => "LEFT OUTER JOIN recipies on recipes.user_id = users.id LEFT OUTER JOIN ingredients on ingredients.recipe_id = recipes.id",
                   :as => "ingredient_list"
               }]
   ...
 end
{% endhighlight %}

Respondiendo al autor del hilo, gracias! me ha ahorrado bastante tiempo.
