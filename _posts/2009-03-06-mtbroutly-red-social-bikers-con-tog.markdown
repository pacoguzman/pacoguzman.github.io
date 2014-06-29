---
layout: post
title: MTBROUTly - Red Social de Bikers con Tog
date:   2009-03-06 15:34:41
categories:
---

Durante los últimos meses he estado desarrollando lo que pretende ser una red social para bikers, muy al estilo de la web moterus.

Esta red social la estoy desarrollando con Rails, valiendome de Tog. Tog es una plataforma open source que permite añadir características de las redes sociales mediante diferentes módulos (plugins) a una aplicación Rails.

Sin embargo, dado el gran interés que ha surgido en mi interior hacia una metodología BDD, he decido empezar de cero el desarrollo. Mi interes comercial es prácticamente nulo, más sabiendo el poco tiempo que puedo dedicar al desarrollo orientandome hacia un interés puramente didáctico y disfrutar durante el mismo.

Para resumir, los conocimientos que pretendo adquirir con este desarrollo son:

- Metodología BDD. Fundamentada en la utilización de Rspec con un mixin de Shoulda (framework que venía utilizando ligeramente) para los test de modelos y de controladores. Y por otro lado la utilización de Cucumber+Webrat+(Selenium)? para los tests de aceptación que pretendo que guien el desarrollo. En lo que se describe como un Outside-In y con Red-Green-Refactor iterativo. Utilización de mocks y stubs (rspec) y Factory_girl como sustitución de las fixtures.
- Utilización de jQuery o Prototype. La integración con GoogleMaps que tenía desarrollada se fundamentaba en Prototype, daré una oportunidad a la convivencia de ambos frameworks para orientarme espero que con fortuna a jQuery.

El comenzar el desarrollo de nuevo me sirve sobre todo para definir unos requisitos de aceptación (stories, features) que he descubierto con el anterior desarrollo y que me permitan la creación de una aplicación orientada solo y exclusivamente a lo que quiero de ella, orientando todos mis esfuerzos a causas bien definidas y que me ahorren quebraderos de cabeza.
