---
layout: post
title: Reescribiendo la historia con Git of course
date:   2009-01-28 15:34:41
categories:
---

Siguiendo con mi estudio del libro Version Control Using Git de Pragmatic me encuentro con la posbilidad de reescribir la historia, suena raro.

Existen tres situaciones en las que puede ser útil reescribir la historia de nuestro desarrollo:

- Reordenar la historia, cambiando el orden de la secuencia de hechos (commits).
- Compactar los hechos de la historia, una secuencia de hechos puede ser compactada y agrupada en un único hecho (commit).
- Romper un hecho en varios, con el objetivo de detallar lo sucedido.

Y el comando de git que permite reescribir la historia es:

> git rebase

Ya solo queda encontrar las situaciones en las que puede ser útil reescribir la historia, aunque creo que no es algún que toque hacer todos los días durante el desarrollo.
