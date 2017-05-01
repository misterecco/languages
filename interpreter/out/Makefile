all:
	happy -gca ParProlog.y
	alex -g LexProlog.x
	ghc --make TestProlog.hs -o TestProlog

clean:
	-rm -f *.log *.aux *.hi *.o *.dvi

distclean: clean
	-rm -f DocProlog.* LexProlog.* ParProlog.* LayoutProlog.* SkelProlog.* PrintProlog.* TestProlog.* AbsProlog.* TestProlog ErrM.* SharedString.* ComposOp.* prolog.dtd XMLProlog.* Makefile*
	

