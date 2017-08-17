#!/usr/bin/runghc 

{-# LANGUAGE OverloadedStrings #-}

import Interactive

info = "Math trainer n4 : square roots of n"

main = interactive info (\x -> sqrt (fromIntegral x))
