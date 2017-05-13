compile:
	ghc -i./out:./src Interpreter.hs -o interpreter

run:
	rlwrap runhaskell -i./out:./src Interpreter.hs

grammar:
	bnfc --haskell --outputdir=out --makefile prolog.cf

clean:
	rm -f interpreter Interpreter.o Interpreter.hi out/*.hi out/*.o src/*.hi src/*.o
