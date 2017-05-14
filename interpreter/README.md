# Simple prolog

## Features

Facts and rules are defined in the same way as in real prolog, e.g.
```
nat(0).
nat(s(X)) :- nat(X).
```

Numbers and lowercase identifiers are treated as constants. Uppercase identifiers
are variables.

Queries are also made in the same way as in normal prolog. One important
difference is that _simple prolog_ is not interactive, therefore all possible
answers are calculated at once. In consequence query `?- nat(X).` results in
an infinite loop.

Predicates are defined by their name and arity.

Lists are built into the language. Syntactic sugar is the same as in real prolog.
Strings are defined as lists of one character lists (like in _python_), e.g.
term `"prolog"` can be unified with term `["p", "r", "o", "l", "o", "g"]`

_Simple prolog_ makes use of _SLD resolution_ algorithm (no occurs check)

Open data structures are supported.

## Non-declarative extensions

_Simple prolog_ supports negation. The following predicates are built in:
`\+`, `=`, `\=`, `==`, `\==`

Queries containing negation are resolved using _SLD-NF resolution_ algorithm.
Like in real prolog, it is possible to negate only ground terms, otherwise
the calculations will _flounder_

_Simple prolog_ also supports integer arithmetics. Arithetics expressions are
allowed only as right hand operand of operator `is` or as operands of any
comparison operator (the following are supported: `=:=`, `=\=`, `<`, `>`, `=<`, `>=`).
The use of arithmetic expressions in other contexts results in an error
(it is different than in real prolog where `+` is just an infix term which can
occur anywhere)

The following arithmetic operations are supported: `+`, `-` (also as prefix operator),
`*`, `/` (integer division), `mod`.

## Comments

One line comments start with `%`, multiline comments are enclosed by `/*` and `*/`

## Full grammar

The grammar is defined in `prolog.cf` file

## Usage

To build - run `make` in the main directory
To run - run `./interpreter`

Interpreter reads the program from stdin. All queries are printed out with
their solutions. Nothing is printed when clause is added.
