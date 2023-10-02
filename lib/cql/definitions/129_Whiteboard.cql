
/*
This example illustrates the use of an "empty source query" to support ad-hoc calculation
within CQL
*/

/*
Sometimes within measures or decision support rules, calculations need to be performed
that don't need a specific starting source. In these cases, an "empty source query" can be
used. This allows authors to introduce intermediate calculated values, and perform the final
computation with the return clause:
*/

  ({ : }) Whiteboard 
    let Foo: 2, Bar: 3 
    return Foo + Bar

/*
Note that we used an empty tuple `{ : }`, not an empty list. This is because if we
used an empty list:
*/
