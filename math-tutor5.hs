#!/usr/bin/runghc 

-- DESCR: Factorial representation of a number

import Liftconsole

fact 1 = 1
fact n = n * fact (n-1)

-- maxfact 0 = 1
maxfact 1 = 1
maxfact 2 = 2
maxfact n = head [i | i <- [n,(n-1) .. 1], ( n - fact i) >= 0]

f 0 = "0"
f 1 = "1*1!"
f 2 = "1*2!"
f n = foldr1 (++) [show (div n ((fact . maxfact) n)) ,
                  "*",
                  show (maxfact n) ,
                  "!" ,
                  "+" ,
                  f (mod n ((fact . maxfact) n))]

function  = Func "Factorial representation of a number" f 
function1 = Func "Factorial representation of a number" maxfact

main = liftCons function print

