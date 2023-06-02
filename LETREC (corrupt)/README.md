# LETREC: A Language with Recursive Procedures

The LET/LETREC Language with *recursive procedures*

```plantuml
hide footbox


skinparam BoxPadding 100
skinparam ParticipantPadding 20
skinparam Padding 5


actor Programmer
box "LETREC" #LightGray
	participant FE as "**Front End**\n//language.rkt//"
	participant Interpreter as "**Interpreter**\n//interpreter.rkt//"
end box

participant Terminal as "**Terminal**\n//output//"

activate Programmer
activate Terminal

Programmer     -> FE                    : LETREC Program Text

activate FE
FE             -> Interpreter            : LETREC AST
deactivate FE

activate Interpreter
Interpreter    -> Terminal              : Answer\n(//value//)
deactivate Interpreter

deactivate Programmer
deactivate Terminal
```

[*Adapted from:* Friedman D. P. & Wand M. (2008).Essentials of Programming Languages (3rd Edition). Cambridge MA: The MIT Press.]

## Running

LETREC can be run using an interactive REPL (**R**ead **E**valuate **P**rint **L**oop):
```bash
  $> ./LETREC.rkt
````

LETREC can also interpret pre-defined LETREC programs:
```bash
  $> ./LETREC.rkt SampleProgram.txt
````


## Extending LETREC

<!-- A brief summary of each component (racket file) of the LETREC programming language is provided -->
### languge.rkt

This file contains the grammar and lexical specifications for the LETREC language. These specifications are passed into *SLLGEN* to produce the parsers required for the LETREC interpreter.

Modify this file to *add* new components to the language.


### interpreter.rkt

This file defines the interpreter responsible for evaluating LETREC AST produced by the LETREC parser.

Modify this file to *implement* the components added to the language.


### datatypes.rkt

This file defines the expressed values possible in LETREC.

Modify this file to *add* new values the language.


### environment.rkt

This file defines the environment used in LETREC.

Modify this file to *change* the default environment in the language.


### tests.rkt

This file contains *tests* to help identify if a fault has been introduced into the language.

You can and *should* add tests to this file to *test* your language extensions.

***Note:*** the tests are executed every time LETREC is evaluated! You do not need to manually run the tests. 

### LETREC.rkt

This file contains the code necessary to run LETREC.

***DO NOT MODIFY THIS FILE***

### readline-repl.rkt

This file contains the support code needed to use the *readline* library for an arbitrary interactive REPL interpreter.

***DO NOT MODIFY THIS FILE***