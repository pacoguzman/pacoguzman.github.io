---
layout: post
title: Citas páginas web en Bibtex y en castellano
date:   2008-09-12 15:34:41
categories:
---

Bueno llevo ya tiempo utilizando LaTeX para crear algunos de los documentos que nos iban pidiendo en la universidad y hasta el momento tenía todo lo necesario.

Sin embargo, a la hora de redactar el proyecto fin de carrera estoy encontrándome con algún que otro problema. El primero de ellos esta relacionado con las citas bibliográficas.

Al tratarse el proyecto del desarrollo de una aplicación con Ruby On Rails, es de suponer que muchas de las referencias serán páginas web: blogs, sus posts, documentos electrónicos, etcétera. Es decir, es necesario poder citar este tipo de información de forma correcta. La limitación principal es poder incluir en las referencias la url donde encontrar dicho documento y la última fecha de consulta.

Bueno este primer problema se resuelve utilizando el paquete urlbst, que como dice en su descripción añade soporte web para bibtex. Principalmente añade las siguientes entradas disponibles en bibtex con sus respectivos campos:

```latex
@Webpage{apastyle,
         url = {http://www.apastyle.org/elecref.html},
         author = {{American Psychological Association}},
         title = {Electronic References},
         year = 2001,
         lastchecked = {23 October 2002},
         note = {Excerpted from 5th edition of the APA Publication Manual}
}
@Book{schutz,
         author = {Bernard Schutz},
         title = {Gravity from the GroundUp},
         publisher = {Cambridge University Press},
         year = {2003},
         url = {http://www.gravityfromthegroundup.org/},
         lastchecked = {2008 June 16}
}
```

Fundamentalmente añade lo que queremos el campo lastchecked y el campo url. Este paquete incorpora un script Perl que permite modificar cualquier estilo de Bibtex para incorporar las anteriores entradas. Y también cuenta con el resultado de aplicar ese script a los estilo por defecto de Bibtex, por ejemplo en mi caso utilizo el estilo unsrt.bst, pudiendo pasar a utilizar unsrturl.bst.

Ahora el problema está en que en Bibtex domina el idioma inglés, y mi PFC se escribe en castellano. Aparecen dos problemas básicos:

- Al utilizar lastchecked nos aparece el texto: [cited $lastchecked
- Al utilizar url nos aparece el texto: Available from: $url

Para corregir este comportamiento he guardado una copia en local para modificar el fichero unsrturl.bst. Lo renombro por miunsrt.bst y modificó donde aparece "cited" por "última consulta". Y donde aparece "Available from" por "Disponible en". Mi fichero de estilo bibliográfico está disponible <a href="myfiles/pacoguzman/miunsrturl.bst" title="http://www.lacoctelera.com/myfiles/pacoguzman/miunsrturl.bst?Expires=1402351200&amp;Signature=LBZsdN4XOaVmQzSl0qjRkTFxoAC4MVe~79RRyvNoTWOrOGg0a2fX87bqxeD7LLoyPk51RpXsdv89haqr0s8TeBDxPjHzsYRfz~cH08gHVWFeviLbb7-vimiATI5hCvaOyn-lCENzrxzBAaQ8SPIUhhuy0qKJMbhyNX2VHFyqQsA_&amp;Key-Pair-Id=APKAJYN3LZI5CG46B7AA&amp;Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cDovL2QzZHM0b3k3ZzF3cnFxLmNsb3VkZnJvbnQubmV0L3BhY29ndXptYW4vbXlmaWxlcy9taXVuc3J0dXJsLmJzdCIsIkNvbmRpdGlvbiI6eyJEYXRlTGVzc1RoYW4iOnsiQVdTOkVwb2NoVGltZSI6MTQwMjM1MTIwMH19fV19" id="link_0">aqui.</a>

Espero que esto sirva de ayuda a alguien. Aún es necesario resolver algún que otro problema ya que hay ocasiones en las que aparecen términos en inglés como "and", "others" en la listas de autores.

UPDATE
Como decía simplemente es necesario buscar en nuestro fichero de estilo los términos "and" y "others" y sustituirlos por los términos en castellano. El fichero actualizado puede descargarse <a href="http://www.lacoctelera.com/myfiles/pacoguzman/miunsrturl-1.bst?Expires=1402351200&amp;Signature=C8SG87gjdDBZAc~YwcDasQBGAuJqudgUK6~Jgr33Gfy4bbkNSQru1ah01TYAIsMtuMs~UoV13Y9FdA6G0inHPg5AvbzzF7cFtE9~aFn0mKc0Z2eH32SMtelg1Tyn7qrMYrXA~f0vaX0cQ6pYEeSbkEEEuz7PZ3l7z1FxpT8wGAs_&amp;Key-Pair-Id=APKAJYN3LZI5CG46B7AA&amp;Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cDovL2QzZHM0b3k3ZzF3cnFxLmNsb3VkZnJvbnQubmV0L3BhY29ndXptYW4vbXlmaWxlcy9taXVuc3J0dXJsLTEuYnN0IiwiQ29uZGl0aW9uIjp7IkRhdGVMZXNzVGhhbiI6eyJBV1M6RXBvY2hUaW1lIjoxNDAyMzUxMjAwfX19XX0_" title="http://www.lacoctelera.com/myfiles/pacoguzman/miunsrturl-1.bst?Expires=1402351200&amp;Signature=C8SG87gjdDBZAc~YwcDasQBGAuJqudgUK6~Jgr33Gfy4bbkNSQru1ah01TYAIsMtuMs~UoV13Y9FdA6G0inHPg5AvbzzF7cFtE9~aFn0mKc0Z2eH32SMtelg1Tyn7qrMYrXA~f0vaX0cQ6pYEeSbkEEEuz7PZ3l7z1FxpT8wGAs_&amp;Key-Pair-Id=APKAJYN3LZI5CG46B7AA&amp;Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cDovL2QzZHM0b3k3ZzF3cnFxLmNsb3VkZnJvbnQubmV0L3BhY29ndXptYW4vbXlmaWxlcy9taXVuc3J0dXJsLTEuYnN0IiwiQ29uZGl0aW9uIjp7IkRhdGVMZXNzVGhhbiI6eyJBV1M6RXBvY2hUaW1lIjoxNDAyMzUxMjAwfX19XX0_" id="link_0">aquí</a>.
