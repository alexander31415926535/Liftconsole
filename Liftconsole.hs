#!/usr/bin/runghc
-- * Imp
{-# LANGUAGE FlexibleInstances, MultiWayIf, LambdaCase, DuplicateRecordFields #-}
module Liftconsole (liftCons, liftCons2, liftCons3, (@@), (//), Function(..), Function2(..), Function3(..) ) where

import  System.Environment (getArgs); import  Text.Read (readMaybe)

data Function  a b     = Func  {description :: String, fab   :: a -> b          }
data Function2 a b c   = Func2 {description :: String, fabc  :: a -> b -> c     }
data Function3 a b c d = Func3 {description :: String, fabcd :: a -> b -> c -> d}

-- * Generalization
-- DESCR: liftCons takes function and action which will be done with the result of function acting on command line arguments
-- Check out applicative functor usage.
[me1,me2,me3]= map (\x -> "Unclear, could not read "    ++ x ++ ".\n") ["one argument","two arguments"," three arguments"]
[er1,er2,er3]= map (\x -> "Not enough arguments, need " ++ x ++ ".\n") ["one argument","two arguments"," three arguments"]
say x d = putStrLn (x ++ d)

liftCons (Func descr fun) action
  = map readMaybe <$> getArgs >>= \case (x:_)     -> case fun <$> x             of Just s  -> action s ; Nothing -> say me1 descr
                                        _         -> say er1 descr
liftCons2 (Func2 descr fun) action
  = map readMaybe <$> getArgs >>= \case (x:y:_)   -> case fun <$> x <*> y       of Just s  -> action s ; Nothing -> say me2 descr
                                        _         -> say er2 descr
liftCons3 (Func3 descr fun) action
  = map readMaybe <$> getArgs >>= \case (x:y:z:_) -> case fun <$> x <*> y <*> z of Just s  -> action s ; Nothing -> say me3 descr
                                        _         -> say er3 descr

a @@ b = Func2 b a
a // b = liftCons2 a b
infix 2 @@
infix 1 //

-- Example ::  
-- -- * Main
-- main = liftCons2 (Func2 "Helps to multiply two natural numbers closer than 20." f) putStrLn
