This is a command line tool that can compute up-down signature
probabilities.  For more information on up-down signatures see the
[up-down-signature](https://github.com/b4winckler/up-down-signature) library.

The tool reads lines of space or comma separated numbers from `stdin`.  The
first line represents the categorical variable which is intepreted as a list
of integers.  Subsequent lines are intepreted as lists of doubles.  Each line
must have the same number of entries as the first line.  The up-down signature
(cumulative) probability is calculated for each line and printed on `stdout`.


## Usage in R

See the `sigscore()` function in the [bapp](https://github.com/b4winckler/bapp)
library on how to call this tool from within R.  Also see the
[examples](https://github.com/b4winckler/sigscore/tree/master/examples)
directory.


## Installation

[Download](https://github.com/b4winckler/sigscore/downloads) a binary version
and put it somewhere in your path.

Alternatively, clone this repository and build it with `cabal`:

    $ git clone https://github.com/b4winckler/sigscore.git
    $ cd sigscore
    $ cabal install

Note that this requires that you have installed a Haskell compiler and `cabal`,
both of which are included in the
[Haskell platform](http://hackage.haskell.org/platform/).
