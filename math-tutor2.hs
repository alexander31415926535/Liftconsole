#!/usr/bin/runghc 
{-# LANGUAGE LambdaCase        #-}
{-# LANGUAGE OverloadedStrings #-}
module Mt2 where

import Control.Concurrent     ;import Control.Monad (forever)
import System.Console.ANSI    ;import System.IO
import Turtle hiding (stdout) ;import Control.Exception

type E = IO (Either AsyncException ())

run func value = do
     let tmpf = putStrF ("                      n is: " ++ show value)
     hideCursor >> setCursorColumn 40  >> clearLine >> (putStrF . show) (func value)  >> tmpf >> delay 1
                                                  where putStrF s = putStr s  >> hFlush stdout  
                                                        delay   d = threadDelay (d *500000)

adjvar dl = initbuffer >> getChar >>= \case 'w' -> takeMVar dl >>= (putMVar dl . (\x -> x + 1))
                                            's' -> takeMVar dl >>= (putMVar dl . (\x -> x - 1))
                                            _   -> pure ()
      where initbuffer = hSetBuffering stdiin NoBuffering >>
                         hSetEcho      stdiin False 
             where                     stdiin = System.IO.stdin
   
interactive argdescr hlp function = do
  n  <- options argdescr parser
  dl <- newMVar n
  putStrLn hlp
  forkIO $ forever ( readMVar dl >>= run function)
  catchexceptions ( forever (adjvar dl) )
 where
  catchexceptions p = (try p :: E) >>= \case Left _  -> showCursor >> putStrLn "  \nBye!" ; Right a -> return a
  parser = optInt  "maxnumber" 'n' "Generates numbers from 0 to n" :: Parser Int -- this line is not general

helptext1 = "Math trainer n2 : squares"
helptext2 = "Stop me with Ctr-C.\n w next,s previous."

main = interactive helptext1 helptext2 (\n -> n*n)
