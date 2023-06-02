# nameless-PROC: LET with Procedures

The PROC/LET Language implemented with *Lexical Addressing*.

```plantuml
hide footbox


skinparam BoxPadding 100
skinparam ParticipantPadding 20
skinparam Padding 5


actor Programmer
box "nameless-PROC" #LightGray
	participant FE as "**Front End**\n//language.rkt//"
	participant Translator as "**Translator**\n//translator.rkt//"
	participant Interpreter as "**Interpreter**\n//interpreter.rkt//"
end box

participant Terminal as "**Terminal**\n//output//"

activate Programmer
activate Terminal

Programmer     -> FE                    : PROC Program Text

activate FE
FE             -> Translator            : PROC AST
deactivate FE

activate Translator
Translator     -> Interpreter           : nameless PROC AST
deactivate Translator

activate Interpreter
Interpreter    -> Terminal              : Answer\n(//value//)
deactivate Interpreter

deactivate Programmer
deactivate Terminal
```

[*Adapted from:* Friedman D. P. & Wand M. (2008).Essentials of Programming Languages (3rd Edition). Cambridge MA: The MIT Press.]

## Running

nameless-PROC can be run using an interactive REPL (**R**ead **E**valuate **P**rint **L**oop):
```bash
  $> ./nameless-PROC.rkt
````

nameless-PROC can also interpret pre-defined nameless-PROC programs:
```bash
  $> ./nameless-PROC.rkt SampleProgram.txt
````


## Extending nameless-PROC

<!-- A brief summary of each component (racket file) of the nameless-PROC programming language is provided -->
### languge.rkt

This file contains the grammar and lexical specifications for the nameless-PROC language. These specifications are passed into *SLLGEN* to produce the parsers required for the nameless-PROC translator.

Modify this file to *add* new components to the language.

### translator.rkt

This file defines the translator responsible for translating the PROC AST into a lexical address (nameless) PROC AST produced by the nameless-PROC parser.

Modify this file to *add* new components to the translator.


### interpreter.rkt

This file defines the interpreter responsible for evaluating nameless-PROC AST produced by the nameless-PROC translator.

Modify this file to *implement* the components added to the language.


### datatypes.rkt

This file defines the expressed values possible in nameless-PROC.

Modify this file to *add* new values the language.


### environment.rkt

This file defines the environment used in nameless-PROC.

Modify this file to *change* the default environment in the language.


### tests.rkt

This file contains *tests* to help identify if a fault has been introduced into the language.

You can and *should* add tests to this file to *test* your language extensions.

***Note:*** the tests are executed every time nameless-PROC is evaluated! You do not need to manually run the tests. 

### nameless-PROC.rkt

This file contains the code necessary to run nameless-PROC.

***DO NOT MODIFY THIS FILE***

### readline-repl.rkt

This file contains the support code needed to use the *readline* library for an arbitrary interactive REPL interpreter.

***DO NOT MODIFY THIS FILE***