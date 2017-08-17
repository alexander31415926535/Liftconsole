#!/usr/local/bin/runghc 

{-# LANGUAGE OverloadedStrings #-}

import Interactive

info = "Math trainer n3 : cubes of n"

main = interactive info (\x -> x*x*x)
