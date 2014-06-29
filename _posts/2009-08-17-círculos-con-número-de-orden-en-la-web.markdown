---
layout: post
title: Círculos con número de orden en la web
date:   2009-08-17 15:34:41
categories: jekyll update
---

Bueno me ha tocado crear unos bullets circulares con número de orden para incrustar en una página web y he comprado lo realmente sencillo que es llevarlo acabo con css3 a través del siguiente artículo [How to Make Circles in CSS](http://blog.ardes.com/2009/3/4/css-circles).

Mi impletación final fue con el siguiente código css:

```css
 div.search-circle {
   float:left;
   height: 2em;
   width: 2em;
   -webkit-border-radius: 1em;
   -moz-border-radius: 1em;
   background-color: #FF7900; margin: auto;
   margin-right:1em;
 }
 div.search-circle p{
   color:#FFF;
   text-align: center;
   margin-bottom: .1em;
   font-weight:bold;
   font-size:1.5em;
 }
```

Y el siguiente fragmento de HTML:

```html
 <div class="search-circle"><p>1</p></div>
```

Moraleja al querer contentar a los usuarios de IE nos toca crear una imagen con GIMP (por ejemplo) del tamaño y color que necesitemos y utilizar el siguiente código css:

```css
 div.search-ballon {
   float:left;
   background:url(/images/layout/ballon.gif) no-repeat;
   width:26px;
   height:26px;
   margin-right:1em;
 }
 div.search-ballon p{
   color:#FFF;
   text-align: center;
   margin-bottom: .1em;
   font-weight:bold;
   font-size:1.5em;
 }
```

Y el código html en este caso sería el siguiente:

Al final nos vemos obligados a aprender a utilizar un editor de imágenes, que seguro que mal no nos viene.


