This is a command line tool that can compute the up-down signature
probabilities.  For more information on up-down signatures see the
[up-down-signature](https://github.com/b4winckler/up-down-signature) library.

The tool reads lines of space or comma separated numbers from `stdin`.  The
first line represents the categorical variable which is intepreted as a list
of integers.  Subsequent lines are intepreted as lists of doubles.  Each line
must have the same number of entries as the first line.  The up-down signature
(cumulative) probability is calculated for each line and printed on `stdout`.

See the `sigscore()` function in the [bapp](https://github.com/b4winckler/bapp)
library on how to call this tool from within R.
