---
layout: post
title: Precarga de Asociaciones - Usandolo a mi antojo
date:   2009-12-12 19:45:16
description: ''
tags: ['ruby', 'rails']
---

Si nos vamos a echar un ojo al código fuente de Rails que se encarga de la precarga de asociaciones [preload_associations](http://github.com/rails/rails/blob/v2.3.5/activerecord/lib/active_record/association_preload.rb), el código que se ejecuta al utilizar un :include =&gt; :patatas nos encontramos con lo siguiente:


> Application developers should not use this module directly.

Pero yo no estoy totalmente de acuerdo con esto y suelo utilizar la funcionalidad que ofrece este módulo a mi antojo. Por un lado no me gusta meter includes al definir las asociaciones en los modelos, sino hacerlo al recuperar los registros en los controladores y añadir los includes que necesite para las vistas que vaya a mostrar.

También suele ocurrir que el número de includes a utilizar es grande por lo que una vez recuperados los registros en el controlador (paginados o no) realizo la carga de las asociaciones a posteriori. (¿Por qué haberlo hecho en el modelo?)

Vale hasta aquí tal vez no haya sido nada convincente y seguro que mis razones sean puramente estéticas sin entrar en detalles de rendimiento. Aún así me he encontrado con un caso, tal vez un "patrón", en el que la precarga de asociaciones puede reducir el número de query's a realizar en la base de datos. Siempre hablando del eager loading que realiza Rails desde la versión 2.1 y cuando no se introducen condiciones en los registros asociados.

El caso consta de los modelos comment, user y profile descritos [aquí](http://gist.github.com/254989)

{% gist pacoguzman/254989 %}

Básicamente un perfil de usuario puede ser comentado a través de un comentario root "root_graffity". Este comentario root puede recibir comentarios "sons" y cada uno de esos comentarios acepta respuestas "replys". En el caso de querer recuperar lo que he denominado "graffities" junto con todos sus datos debería hacer lo que muestro [aquí](http://gist.github.com/254993)

{% gist pacoguzman/254993 %}

Como vemos se realizan 7 consultas  a la base de datos, y el detalle está en que a la tabla de users y profiles se accede en dos ocasiones. Esto último lo podemos evitar si realizar un precarga de asociaciones tal y como muestro [aquí](http://gist.github.com/255002)

{% gist pacoguzman/255002 %}

Si estamos cargando asociaciones auto-referenciadas (o algo así), es decir, aquellas que cargan modelos de la misma clase, si esta clase necesita asociaciones de otras clases. Veo que puede ser de utilidad agrupar los modelos de la primera clase y para ese conjunto cargar sus asociaciones. Ya que lo que hace Rails en el módulo en cuestión es recuperar los registros asociados a partir de las claves que contiene la colección de registros cuyas asociaciones se quieren precargar.

Alé que es sábado y habrá que beberse unas cervezas! A vuestra salud!
