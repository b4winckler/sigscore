{-# LANGUAGE BangPatterns #-}
module Main where

import Control.Applicative ((<$>))
import Control.Monad (forM_, when)
import Data.List (nub, sort)
import Data.Maybe (catMaybes)
import System.Environment (getArgs)
import System.Exit (exitSuccess)
import System.Random.MWC (withSystemRandom)

import Parsers (parseDoubles)
import Utility (logStr, logStrLn, exitBecause, bin, pad)

import qualified Data.ByteString.Lazy.Char8 as B
import qualified Data.UpDownSignature as Sig


main = withSystemRandom $ \gen -> do
  as <- getArgs
  ls <- B.lines <$> if null as then B.getContents else B.readFile (head as)

  when (null ls) exitSuccess   -- Nothing to do!

  -- The first line is a list of integers representing categories
  let cats  = map truncate $ catMaybes $ parseDoubles $ head ls
      ncats = length cats

  -- Sanity check and log info about categories
  logStrLn $ foundCategories cats
  when (ncats < 3) $ exitBecause tooFewCategories
  when (length (nub cats) > 20) $ logStrLn tooManyCategories

  -- Each line is a list of doubles, with as many elements as there were in the
  -- categories line.  Missing values and NAs are allowed.  Go through each and
  -- compute the signature score.
  forM_ (zip [1..] $ tail ls) $ \(lnum,line) -> do
    let elems  = parseDoubles line
        nelems = length elems
    if ncats == nelems
      then do
        let bins = map catMaybes $ bin cats elems
        s <- Sig.approxScore gen numPaths $ bins
        -- let s = Sig.score $ trimBins binSize $ map catMaybes $ bin cats elems
        putStrLn $ show s
        when (lnum `mod` 100 == 0)  $ logStr $ "  " ++ pad 4 (show lnum)
        when (lnum `mod` 1000 == 0) $ logStrLn ""
      else
        logStrLn $ skippingLine lnum nelems ncats


numPaths = 10000
binSize  = 4

tooManyCategories = "\
\WARNING: More than 20 categories.  Break up the data into fewer categories\n\
\         to cut down on processing times."

tooFewCategories = "\
\ERROR: First line must be a list of at least three integer categories."

foundCategories xs = "Found " ++ show n ++ " "
  ++ if n == 1 then "category" else "categories" ++ ": " ++ show (sort cs)
  where
    cs = nub xs
    n  = length cs

skippingLine lnum actual expected =
  "WARNING: Skipping line " ++ show lnum ++
  " (expected " ++ show expected ++ " elements, got " ++ show actual ++ ")"
