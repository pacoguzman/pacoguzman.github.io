---
layout: post
title: jQuery in Action terminado, ¿Ahora qué?
date: 2009-10-02 18:13:31
description: ''
tags: ['javascript', 'jquery', 'js']
---

Durante las últimas tres semanas estuve leyendo el libro [jQuery In Action](http://www.manning.com/bibeault/) de la editorial Manning durante esos maravillosos remansos de paz que son los trenes de cercanias. Aunque este libro esta basado en la versión 1.2 y actualmente jQuery se encuentra en su version [1.3.2](http://jquery.com) considero que es un muy buen punto de partida para empezar a trabajar con jQuery, ya que durante el libro se exponen multitud de ejemplos e incluso una introducción a JavaScript que también me ha enseñado multitud de cosas.

¿Por qué jQuery? Vale no es que yo tenga una gran experiencia con otros frameworks como pudiera ser Prototype, ni tampoco con el mismo lenguaje JavaScript; así esta atracción por jQuery se resume por lo que vi en los screencasts sobre paginación de [Ryan Bates](http://railscasts.com/tags/11) y también por el hecho de que un tal [Yehuda Katz](http://yehudakatz.com/) halla escrito este libro.

A partir de ahora siempre que me sea posible utilizare jQuery en las aplicaciones Rails que desarrolle, y sino pues a tirar de la siguiente estructura que evita que jQuery entre en conflicto con otras librerias que estemos usando:

{% highlight javascript %}
  (function($){
     cualquier cotenido javascript cuyo scope queremos protejer
  })(jQuery);
{% endhighlight %}

La ventaja de lo anterior es que dentro de dicha declaración podemos seguir utilizando el caracter $, caracter que identifica al framework jQuery en este caso. Y ahora un primer ejemplito que nos sirve para hacer submit por ajax de los campos del formulario que no esten en blanco:

{% highlight javascript %}
  (function($){
    $("form").submit(function(event){
      var FormValues = {};
      $("form input[value]").each(function(){
           FormValues[$(this).attr("name")] = $(this).val();
      });
      $.post($("form").attr("action"), FormValues);
    });
  })(jQuery);
{% endhighlight %}

Y con esto hasta mañana a las ocho
