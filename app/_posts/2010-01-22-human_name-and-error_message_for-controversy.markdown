---
layout: post
title: human_name and error_message_for controversy
date:   2010-01-22 15:55:33
description: ''
tags: ['ruby', 'rails']
---

Parace que nuestros amigos _ActiveRecord::Base.human_name_ y _ActionView::Base::Helpers.error_messages_for_ parece que no están en la misma onda o ola o como queráis. El método human_name intenta proporcionar un nombre más "humano" a nuestros modelos de active record y _error_messages_for_ intenta proporcionarnos unos bonitos mensajes de error al intentar crear/editar nuestro modelo de active record.

Además _error_messages_for_ tiene multitud de opciones que nos permiten definir enteramente el contenido de los mensajes, su estructura html y otras cosillas. Pero el problema viene cuando tratamos con los valores por defecto. Este método captura la variable de instancia a partir de su primer parámetro y debe obtener la variable _options[object_name]_ de dicha variable si la opción _object_name_ no es pasada como parámetro. Y aquí llegamos a la controversia, ¿Que clave de nuestros locale recuperamos para generar el _object_name_ en caso de que no lo proporcione el programador?

Pues como suponéis _error_messages_for_ no recupera la misma clave que _human_name_ con lo que nos surge un problema.

{% highlight ruby %}
 def error_messages_for(*params)
   options[:object_name] ||= params.first
   ...
     I18n.with_options :locale => options[:locale], :scope => [:activerecord, :errors, :template] do |locale|
       ...
       object_name = options[:object_name].to_s.gsub('_', ' ')
       object_name = I18n.t(object_name, :default => object_name, :scope => [:activerecord, :models], :count => 1)
       ...
     end
   ...
 end


 def human_name(options = {})
   defaults = self_and_descendants_from_active_record.map do |klass|
     :"#{klass.name.underscore}"
   end
   defaults << self.name.humanize
   I18n.translate(defaults.shift, {:scope => [:activerecord, :models], :count => 1, :default => defaults}.merge(options))
 end
{% endhighlight %}

Pero ante la llegada inminente de Rails 3 o eso nos comentaba Yehuda en el grupo del core team se han puesto de acuerdo estos muchachos con la ayuda de ActiveModel y tenemos esto.

{% highlight ruby %}
 module ActiveModel::Naming
   # Transform the model name into a more humane format, using I18n. By default,
   # it will underscore then humanize the class name (BlogPost.model_name.human #=> "Blog post").
   # Specify +options+ with additional translating options.
   def human(options={})
     # No nos interesa que clave recupera pero vemos que será la misma
     ...
   end
 end

 module ActionView
   module Helpers
     module ActiveModel

       def error_messages_for(*params)
         ...
         if object.class.respond_to?(:model_name)
           options[:object_name] ||= object.class.model_name.human.downcase
         end
         ...
       end
     end
   end
 end
{% endhighlight %}

Así por ahora solo nos queda esperar o pasarle a error_messages_for el parámetro object_name con le valor que necesitemos.

Ciau
