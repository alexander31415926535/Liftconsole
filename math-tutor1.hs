#!/usr/bin/runghc
{-# LANGUAGE LambdaCase        #-}
{-# LANGUAGE OverloadedStrings #-}
module Mt1 where

-- DESCR: Prints numbers to be devided by 2, or perform other operation, interval can be controlled with w or s keys
-- TODO: Maybe add support to increase/decrease range with keyboard

import System.Random (randomRIO);import Control.Concurrent (threadDelay);import Control.Monad (forever)
import System.Console.ANSI;import System.IO;import Turtle hiding (stdout);import Control.Exception;import Control.Concurrent

type E = IO (Either AsyncException ())

stdiin            = System.IO.stdin
delay           d = threadDelay (d *1000000)
parser            = optInt  "maxnumber" 'n' "Generates numbers from 0 to n" :: Parser Int
putStrF x         = putStr x  >> hFlush stdout  
catchexceptions x = (try x :: E) >>= \case Left _  -> showCursor >> putStrLn "  \nBye!" ; Right a -> return a

main = do
  dl <- newMVar 5
  n  <- options "Math trainer n1 : divide by 2" parser
  putStrLn "Stop me with Ctr-C.\n w faster,s slower."
  forkIO $ forever (mechanism n dl)
  catchexceptions (forever (adjtime dl))
  where
   mechanism n d = do
     time <- readMVar d
     let tmpf = putStrF ("                     Mvar is: " ++ show time)
     hideCursor >> setCursorColumn 40  >> clearLine >> randomRIO (0,n) >>= putStrF . show  >> tmpf >> delay time >> showCursor
   adjtime dl   = do
     hSetBuffering stdiin NoBuffering
     hSetEcho stdiin False
     getChar >>= \case 'w' -> takeMVar dl >>= (putMVar dl . (\x -> x + 1))
                       's' -> takeMVar dl >>= (putMVar dl . (\x -> x - 1))
                       _   -> pure ()
