
`heb412_gen`  cuenta con un mecanismo de permisos para carpetas de la nube
basado en grupos que es similara las salas VIP por ejemplo de las aerolineas 
en los aeropuertos.

* Los administradores y directivos pueden leer y escribir en todas partes.
* Los demás roles sólo pueden ver directorios y entrar así como descargar
  archivos en carpetas que no se exclusivas, o bien si la carpeta es
  exclusiva para uno de los grupos a los que pertenezca el usuario.
* La carpeta raíz no es exclusiva.
* Cuando una carpeta (no raíz) se marca como exclusiva para uno o más
  grupos, todos sus archivos y subcarpetas recursivamente son exclusivas
  para esos grupos.
* Cuando se define la exclusividad de una carpeta para uno o más grupos, 
  sólo puede ser entre los grupos permitidos para la carpeta mamá.
