#!/usr/bin/runghc 
{-# LANGUAGE LambdaCase        #-}
{-# LANGUAGE OverloadedStrings #-}
module Interactive  ( interactive  )  where

import Control.Concurrent;import Control.Monad (forever);import System.Console.ANSI;
import System.IO         ;import Turtle hiding (stdout) ;import Control.Exception ; type E = IO (Either AsyncException ())

outputf func value = do
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
   
interactive appdescr function = do -- Narrowed to INT parser, NOT general!!!
  n  <- options appdescr parser
  dl <- newMVar n
  putStrLn hlp
  forkIO $ forever ( readMVar dl >>= outputf function)
  catchexceptions  ( forever (adjvar dl) )
 where
  catchexceptions p = (try p :: E) >>= \case Left _  -> showCursor >> putStrLn "  \nBye!" ; Right a -> return a
  parser            = optInt aname sname descr :: Parser Int -- XXX: -- this line is not general !!!!!
  descr             = "Generates numbers based on function and supplied arguments."
  sname             = 'n'
  aname             = "number"
  hlp               = "Stop me with Ctr-C.\n w increase,s decrease."
