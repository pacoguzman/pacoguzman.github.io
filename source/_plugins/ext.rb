require "jekyll-assets"
require "jekyll-assets/bourbon"
require "jekyll-assets/neat"

neat_root = Gem::Specification.find_by_name("refills").gem_dir
Sprockets.append_path File.join(neat_root, "source", "stylesheets")
