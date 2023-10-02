
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
