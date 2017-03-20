module MyTests where

import Auto

accepts emptyA ""
False
accepts epsA ""
True
accepts epsA "a"
False
accepts (symA 'a') ""
False
accepts (symA 'a') "a"
True
accepts (symA 'a') "b"
False
accepts (thenA (symA 'a') (symA 'b')) "b"
False
accepts (thenA (symA 'a') (symA 'b')) "ab"
True
accepts (thenA (symA 'a') (symA 'b')) "a"
False
accepts (thenA (symA 'a') (symA 'b')) "abc"
False
accepts (thenA epsA (symA 'b')) "a"
False
accepts (thenA epsA (symA 'b')) "b"
True
accepts (thenA emptyA (symA 'b')) "b"
False
accepts (thenA (symA 'a') epsA) "a"
True
accepts (thenA (symA 'a') epsA) "b"
False
