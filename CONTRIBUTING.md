# ¡Gracias!

RailsBridge no sería lo que es sin tu ayuda.¡Gracias por contribuir!

Te pedimos que las contribuciones sean hechas como un Pull Request via
GitHub. Si estas palabras son totalmente desconocidas para ti,
[mira esto](#its-my-first-time-on-github-ever-what-do-i-do).

# Cuando envíes un Pull Request

*Aquí hay un par de trucos para engrasar los motores y hacer más fácil que los encargados del repo te
amen :heart:*

## ¡Antes de comenzar!

- Si ya cuentas con un fork existente, por favor asegúrate de que está actualizado.
  ¡Esto hace tu vida más fácil!. Si no, asegúrate de que creas tu fork *antes* de clonarlo,
  de lo contrario necesitarás pasar algo de tiempo manipulando repositorios remotos.
  Mira la sección "Pull in upstream changes" en el artículo sobre 
  [Fork A Repo](https://help.github.com/articles/fork-a-repo).


- Crea una rama local antes de comenzar a trabajar. Esta rama se llamará de acuerdo
  a lo que planeas cambiar. `corregir-typo-en-diapositivas`, `mover-recursos`,
  y `agregar-soporte-para-mountain-lion` son buenos nombres para tus ramas. Si nunca antes
  has creado una rama local, puedes usar el comando `git checkout -b  nnombre-de-tu-rama`.


## Antes de enviar

- Por favor, por favor, por favor corre `rake` en tu terminal antes de tu envío. No únicamente
  corren nuestro conjunto de pruebas sino que también revisa errores de sintáxis en los documentos.

- Empuja tu rama a GitHub. Así como desarrollaste en una rama local, deberías empujar esa rama a
  tu rpropio epositorio de GitHub. La rama `master` es mayormente usada como una copia limpia de los
  documentos más actualizados en caso de que necesites hacer algunos cambios no relacionados. Para
  empujar una rama, si tu rama se llama "corregir-typo-en-diapositivas", usa
  `git push origin corregir-typo-en-diapositivas`.


## Enviando un Pull Request

- Lee el artículo ["Using Pull Requests"](https://help.github.com/articles/using-pull-requests)
  en GitHub

- Cuando envíes un pull request (PR), asegúrate de que tu rama esté seleccionada del lado derecho de la
  Página de Vista Previa de Pull Request, como ésta:

  ![choosing pull request branch](https://github-images.s3.amazonaws.com/help/change-branches.png)

- Recuerda, los pull request son enviados *desde* tu repo, pero mostrados en el repo más avanzado.

## Discusión y espere de un Merge

- Todos los pull request recibirán una respuesta de algún miembro del equipo.
- No todos los pull request serán mergeados tal cual fueron enviados.
- No todos los pull request serán mergeados.
- Si un pull request está muy por detrás de master, podríamos pedirte que lo cierres, actualices tu rama con
  los cambios de master, y envíes un nuevo pull request.
- Siéntete con la libertar de "notificar" al equipo con un comentario corto en tu pull request si ha pasado
  más de una semana y no has obtenido respuesta alguna.


## Después de que tu merge haya sido aceptado

- Regresa a tu fork y manténlo actualizado, por ejemplo:

        git checkout master
        git pull upstream master
        git push origin master


- También puedes borrar la rama si gustas

        git branch -dr corregir-typo-en-diapositivas

# Es mi primera ves en GitHub, ¿Qué hago?

Calma, estás en el lugar adecuado. Para contribuir necesitarás familiarizarte con
algunos conceptos de Git y GitHub. Va a ser mucha información, pero tú eres
:sparkles:increíble:sparkles:! así que estará bien.

Antes que nada, necesitarás una cuenta de Github, que es totalmente gratuita. Puedes
registrarte [aquí](https://github.com/signup/free).

Después, navega por el [sitio de ayuda de GitHub](https://help.github.com).

Quizá quieras leer sobre [forking](https://help.github.com/articles/fork-a-repo) y
posteriorment hacer tu propio fork de [codificadas/docs](https://github.com/codificadas/docs). 
Ya que lo hayas hecho, puedes clonarlo y empezar por leer [cuando envíes un pull request](#when-submitting-a-pull-request), también lee sobre [pull requests](https://help.github.com/articles/using-pull-requests)
por sí mismos.

Si crees que es demasiado, o te gustaría una mano que te ayude, 
[@codificadas](https://github.com/codificadas) han decidido ser voluntarias para ayudar a cualquiera que
guste contribuir. Su email está debajo de su perfil en el enlace.

# Conclusión

Si no te has dado el tiempo de tomar el Laboratorio de Inmersión a Git, hazlo.

Vale la pena sin importar qué tanto git-fu tengas.
http://gitimmersion.com

También, [Pro Git](http://git-scm.com/book) es un libro grandioso (¡y gratuito!) acerca de Git.

¡Nos disculpamos por el tamaño de este documento! Esperamos que que ayude con la mayoría de tus
dudas sobre git, contribuciones, y GiHub. Siéntete libre de preguntarnos más. También estamos abiertos a cualquier suferencia sobre mejoras, incluyendo este documento.