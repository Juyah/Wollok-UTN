# Corrección Parcial - Paradigma Orientado a Objetos 2020

Link a la solución usada para la corrección: https://github.com/pdep-mit/parcial-objetos-2020-JYarbuh/blob/47387ab6594a5520b759ad557ff63996fd4210e2/src/parcial.wlk

## Feedback

### Punto 1

Bien

Podía directamente parametrizarse la experiencia base de la receta a la calidad de la comida, siendo que siempre se esperaba que fuera calculado a partir de ese valor.

### Punto 2

Bien

### Punto 3

Bien-

Preparar una comida no debería fallar si luego de prepararla todavía no supera su nivel actual, esto forma parte del flujo normal de ejecución.

Teniendo nivel experimentado también debería poder preparar recetas que no sean difíciles.

Si bien no se repite lógica, haciendo que chef delegue en el objeto experimentado, se pierde la relación que existe entre ambos niveles. Son naturalmente similares, con lo cual no sería extraño que a futuro se quiera reutilizar más lógica del nivel experimentado en el nivel de chef. Hubiera sido razonable usar herencia para esto y aprovechar el method lookup.

La cantidad de experiencia para perfeccionar una receta es algo que podría delegarse a la receta, en vez de ser el cocinero quien lo calcule en `perfeccionoReceta`.

> Efectivamente estaría bien que la receta tenga un set para los ingredientes, de esa forma la igualdad entre ambos conjuntos sirve para saber si es similar a otra.

### Punto 4

Bien

### Punto 5

Bien

## Corrección final

Nota: 9

La solución es muy prolija y aplica muy bien todos los conceptos principales del paradigma. Muy buen trabajo :+1:
