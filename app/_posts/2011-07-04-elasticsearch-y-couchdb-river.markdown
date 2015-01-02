---
layout: post
title: ElasticSearch y Couchdb river
date:   2011-07-04 10:20:24
description: ''
tags: ['elasticsearch', 'couchdb', 'ruby']
---

En este post vamos a ver como incorporar un motor de búsqueda en una aplicación (Rails) para indexar documentos almacenados en Couchdb.

[ElasticSearch](http://www.elasticsearch.org/) es un motor de búsqueda construido sobre [Lucene](http://lucene.apache.org/), es Open Source (Apache 2), es distruido y presenta un interfaz Restful. ElasticSearch cuenta con una funcionalidad denominada [River](http://www.elasticsearch.org/guide/reference/river/). River es un sistema de plugins que una vez instalado en ElasticSearch permite extraer datos (o enviarle datos) que será indexados e incoporados al cluster de ElasticSearch, para su posterior consulta. ElasticSearch cuenta con 4 diferentes rivers listos para ser instalados: [Couchdb](http://www.elasticsearch.org/guide/reference/river/couchdb.html), [RabbitMQ](http://www.elasticsearch.org/guide/reference/river/rabbitmq.html), [Twitter](http://www.elasticsearch.org/guide/reference/river/twitter.html) y [Wikipedia](http://www.elasticsearch.org/guide/reference/river/wikipedia.html). Aquí nos centraremos en el uso del river para Couchdb.

El river para Couchdb se basa en una funcionalidad de Couchdb denominada [Continuous Changes API](http://guide.couchdb.org/draft/notifications.html#continuous). Una vez te conectas a este API y manteniendo la conexión abierta Couchdb te enviará las modificaciones y seguirá manteniendo la conexión abierta para enviarte las siguientes modificaciones hasta que decidas cerrar la conexión. Siempre tendremos una conexión abierta (por river definido) pero Couchdb es capaz de manejar un gran número de conexiones sin problemas.

Como instalamos ElasticSearch y el river de Couchdb:

{% gist pacoguzman/1062993 INSTALL_AND_SETUP %}

El propio river de Couchdb con la configuración que le hemos dado se enganchará a la siguiente url, para ir recibiendo las modificaciones que hagamos en la base de datos de couchdb e ir indexando documentos.

> http://localhost:5984/couchdb_myapp_development/_changes?feed=continuous&amp;include_docs=true&amp;heartbeat=10000

Sin embargo con esta configuración incluimos en el mismo índice todos los documentos de Couchdb, si queremos establecer un indice para dos tipos de documentos como por ejemplo Product y Person, debemos establecer un filtro a la hora de crear el river. Este filtro debe hacer referencia al nombre de un filtro especificado a la hora de definir un [design document](http://guide.couchdb.org/draft/notifications.html#filters).

{% gist pacoguzman/1062993 DESIGN_DOCS %}

{% gist pacoguzman/1062993 FILTERING %}

Debemos tener en cuenta que nuestros documentos de couchdb tienen especificado un atributo 'type' que permite realizar el filtrado.

Por último crearemos un documento de tipo 'Product' y realizaremos una búsqueda

{% gist pacoguzman/1062993 EXAMPLE %}
