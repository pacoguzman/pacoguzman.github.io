---
layout: post
title: Simplificacion Vistas Rails 2.0
date:   2008-07-09 15:34:41
categories:
---

Hoy me voy a dedicar a simplificar un poco mi aplicación Rails que estoy desarrollando para mi proyecto fin de carrera en la <a href="http://www.uc3m.es" title="http://www.uc3m.es" id="link_0">Universidad Carlos III de Madrid</a>.

De momento esta en fase pre-alfa se podría decir, pero pronto estará accesible a todos para que al menos la podáis echar un vistazo.

Para la simplificación de vistas me he basado en un capítulo de la web railscasts el episodio denominado <a href="http://media.railscasts.com/videos/080_simplify_views_with_rails_2.mov" title="http://media.railscasts.com/videos/080_simplify_views_with_rails_2.mov" id="link_1">simplify views with rails 2</a>.

Partiendo de catalogs/show.html.erb

```html
<h1>Catalog <%=h @catalog.id %></h1>
<div class="details">
  <p>
    <b>Type </b>
    <%=h @catalog.type_catalog %>
  </p>
  <p>
    <b>User:</b>
    <%=h @catalog.user.login %>
  </p>
  <p>
    <b>Created at:</b>
    <%=h @catalog.created_at %>
  </p>
  <p>
    <b>Updated at:</b>
    <%=h @catalog.updated_at %>
  </p>
</div>
```

Podemos sustituirlo por el código del partial catalogs/_catalog.html.erb<

```html
<%= render :partial => 'catalog', :object => @catalog %>
```

Pero lo que podemos hacer para reducir aún más el código es pasar directamente el objeto al partial, rails se encarga de ver que clase de objeto y buscar el partial asociado.

```html
<%= render :partial =><del> </del>@catalog %>
```

Finalmente modificamos el partial ligeramente:


```html
<% div_for catalog do %>
<h1>Catalog <%=h catalog.id %></h1>
<div class="details">
  <p>
    <b>Type </b>
    <%=h catalog.type_catalog %>
  </p>
  <p>
    <b>User:</b>
    <%=h catalog.user.login %>
  </p>
  <p>
    <b>Created at:</b>
    <%=h catalog.created_at %>
  </p>
  <p>
    <b>Updated at:</b>
    <%=h catalog.updated_at %>
  </p>
</div>
<% end %>
``

La etiqueta div_for incluye una etiqueta div con class="catalog" e id="catalog_#{catalog.id}"

Un saludo
