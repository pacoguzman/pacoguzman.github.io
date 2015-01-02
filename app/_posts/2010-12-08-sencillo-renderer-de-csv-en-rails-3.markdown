---
layout: post
title: Sencillo renderer de CSV en Rails 3
date:   2010-12-08 22:24:07
description: ''
tags: ['ruby', 'rails']
---

En el artículo [anterior](http://pacoguzman.lacoctelera.net/post/2010/12/04/csv-y-ruby-1-9-y-encoding-yo-escribo-enconding) vimos como generar texto en formato CSV en ruby 1.9.2 y como utilizar una sencilla clase dentro de una aplicación rails 3 que generaba texto en dicho formato. En este artículo vamos a ver como incorporar lo aprendido para que nuestra aplicación responda a peticiones de formato CSV de una manera muy sencilla.

Partimos del siguiente controlador que simplemente crea un objecto ActiveRecord::Relation (nuestra aplicación no tiene muchos usuarios no nos preocupamos por recuperar todos los registros)

{% highlight ruby %}
 class Admin::UsersController < Admin::AdminController

   def index
     @users = User.scoped
   end
 end
{% endhighlight %}

Ahora simplemente debemos declarar que nuestro controlador y/o acción responde a peticiones csv

{% highlight ruby %}
 class Admin::UsersController < Admin:AdminController
   respond_to :html, :csv

   def index
     @users = User.scoped
     respond_with(@users)
   end
 end
{% endhighlight %}

Sin embago si abrimos nuestro navegador y vamos a "/admin/users.csv" nos encontramos con:

> Template is missing
> Missing template admin/users/index with {:handlers=&gt;[:erb, :rjs, :builder, :rhtml, :rxml], :formats=&gt;[:csv], :locale=&gt;[:es, :es]}

Al utilizar el respond_with y gracias al respond_to :csv hemos indicado a la aplicación que responde a peticiones de formato :csv, pero rails primero comprobará si hemos añadido un bloque para dicho formato o si tenemos una plantilla para hacer el render (index.csv.erb), sino ejecutará un <a href="https://github.com/rails/rails/blob/master/actionpack/lib/action_controller/metal/responder.rb">responder por defecto</a>. Y este responder por defecto producirá el error mostrado anteriormente ya que intenta ejecutar igualmente render(:csv =&gt; @users) pero no tenemos ninguna plantilla definida.

Pero en rails 3 podemos definir que nuestra aplicación responda a xml y json y funcionariá sin definir ninguna plantilla. Y esto es porque rails 3 define "renderers" tanto para xml y json

{% highlight ruby %}
 class Admin::UsersController < Admin:AdminController
   respond_to :html, :csv, :json, :xml

   def index
     @users = User.scoped
     respond_with(@users)
   end
 end

 module ActionController
   module Renderers
     ...

     add :json do |json, options|
       json = json.to_json(options) unless json.respond_to?(:to_str)
       json = "#{options[:callback]}(#{json})" unless options[:callback].blank?
       self.content_type ||= Mime::JSON
       self.response_body  = json
     end

     add :xml do |xml, options|
       self.content_type ||= Mime::XML
       self.response_body  = xml.respond_to?(:to_xml) ? xml.to_xml(options) : xml
     end

     ...
   end
 end
{% endhighlight %}

Entonces simplemente lo que necesitamos es añadir un nuevo "renderer" para el formato csv. Nos creamos el initializer csv_renderer.rb

{% highlight ruby %}
 ActiveSupport.on_load :action_controller do
   ActionController.add_renderer :csv do |relation, options|
     csv_instance = CsvDelegator.new(relation)

     options = {:type => "text/csv; charset=utf8", :filename => csv_instance.filename}.merge(options)
     send_data csv_instance.to_csv, options.slice(:type, :filename)
   end
 end
{% endhighlight %}

Y no necesitamos añadir nada más, bueno si definir nuestra clase CsvDelegator, pero eso no tiene mucha historia y os lo dejo a vosotros

Y bueno unos links que pueden resultar de interes:
  - [Rails 3 upgrade](http://bigbangtechnology.com/post/rails3_upgrade)
  - [Render Options in Rails 3](http://www.engineyard.com/blog/2010/render-options-in-rails-3/)
  - [Creating your own renderer](http://media.pragprog.com/titles/jvrails/create.pdf)
  - [Three reasons love responder](http://weblog.rubyonrails.org/2009/8/31/three-reasons-love-responder)

NOTA: ¿Por qué en los diferentes ejemplos utilizan ActionController::Renderers.add en lugar de ActionController.add_renderer? ¡Qué alguien me cuente!
