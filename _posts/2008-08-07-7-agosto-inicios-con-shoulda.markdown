---
layout: post
title: 7 de Agosto inicios con should
date:   2008-08-07 15:34:41
categories:
---

Bueno ante la necesidad de incluir un apartado sobre pruebas (testing) y validación para mi proyecto fin de carrera he comenzado a utilizar Shoulda para probar mi aplicación.

Según se puede ver en una presentación de <a href="www.lacoctelera.com/porras" title="www.lacoctelera.com/porras" id="link_5">Sergio Gil</a>, su título "Más allá del testing", la única solución para probar mi aplicación después de su implementación es el DDT "Development Driven Testing" que siempre será mejor que no testear.

Al final me decante por utilizar Shoulda también después de leer la presentación "BDD with Should" de la gente que ha desarrollado este framework de testing. Principalmente porque se pueden enlazar contextos (cierto parecido a rspec), los nombres de los tests están bien, compatible con Test::Unit, están cubiertos la mayoría de los macros de ActiveRecord y de ActionController y también tiene cierta magia con los diseños REST.

Por otro lado, no he dejado de utilizar las fixtures, que son odiadas por gran parte de la comunidad porque de momento me sobra con aprender Shoulda. Para evitar el uso de las fixtures me ha parecido interesante el uso de factorias. La gente de <a href="http://www.thoughtbot.com" title="http://www.thoughtbot.com" id="link_4">thoughtbot</a> utilizan <a href="http://www.thoughtbot.com/projects/factory_girl" title="http://www.thoughtbot.com/projects/factory_girl" id="link_3">FactoryGirl</a>.

A continuación algunos ejemplos de el uso que le he dado a shoulda para probar modelos y controladores.

Testeando modelo Artist

```ruby
should_require_attributes :name
should_belong_to :catalog
should_have_many :albums
should_have_many :tracks
should_have_named_scope :recent, :include => :catalog, :order => 'artists.created_at desc',
  :limit => 9, :group => 'catalog_id'
should_have_named_scope 'most_played(10)', :joins => "INNER JOIN tracks on tracks.artist_id = artists.id",
    :select => "SUM(play_count) as sum_play_count, artists.*",
    :group => "tracks.artist_id", :order => "sum_play_count DESC", :limit => 10
```

Testeando controller Artist

```ruby
class ArtistsControllerTest < Test::Unit::TestCase
  fixtures :users, :catalogs, :artists, :albums, :tracks, :playlists
  def setup
    @controller = ArtistsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  logged_in_as(:admin) do
    context "on GET to :index" do
      setup do
        get :index, :catalog_id => catalogs(:catalog_itunes_pacoguzman).id
      end
      should_assign_to :catalog
      should_assign_to :artists
      #FIXME También se asigna @recommended
      should_assign_to :recommended
      should_respond_with :success
      should_not_set_the_flash
      should_render_a_form # search form
      should "has one link to new artist page" do
        assert_select "a[href=?]", new_catalog_artist_path(catalogs(:catalog_itunes_pacoguzman)),
          :count => 1, :text => "New artist"
      end
      should "has one link to back catalog page" do
        assert_select "a[href=?]", catalog_path(catalogs(:catalog_itunes_pacoguzman).id),
          :count => 1, :text => catalogs(:catalog_itunes_pacoguzman).type_catalog
      end
    end
  end
end
```

Para definir el contexto anterior he utilizado el macro logged_in_as del siguiente modo (test_helper.rb)

```ruby
def self.logged_in_as(user = :admin)
  context "When logged in as #{user}" do
    setup { @logged_in_user = login_as user }
    yield
  end
end
```

Hasta aquí he resumido el uso que he dado a shoulda en mi aplicación, y para enlazar aquí dejo unos cuantos links:

- [Shoulda Project](http://www.thoughtbot.com/projects/shoulda)
- [RDoc Should](http://dev.thoughtbot.com/shoulda/)
- [GitHub Shoulda](https://github.com/thoughtbot/shoulda)
