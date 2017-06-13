1000 factorial

Smalltalk allClasses size

CompiledMethod allInstances size

Object allSubinstances size

x := 111111.0. Float allInstances
x := 'Ala ma kota'
Float allInstances

t := SmalltalkWorkspaceDocument show
t caption: 'To mój edytor tekstu'
t view extent: 600 @ 200
t view position: t view position + (10 @ 10)
t workspace displayIt
t yourAddress
t exit
t := View active

r := Random new

t presenter workspace view backcolor: (Color fromInteger: (2 ** 24 * r next) truncated)

x := Osoba imie: 'Jan' nazwisko: 'Kowalski'
x imie , ' ' , x nazwisko
x

'Hello ' * 5
'Bye ' * 3

10 factorial

'ala ma kota' size

k := Object.
1 to: 10 do:
	[:i |
	k := k
		subclass: 'A' , i printString
		instanceVariableNames: ''
		classVariableNames: ''
		poolDictionaries: '']

A1 compile: 'm ^1'
A2 withAllSubclassesDo: [:c | c compile: 'm ^2 * super m']
A10 new m

Wyrozumiala new prooba

Wyrozumiala new proba