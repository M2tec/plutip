module Main (main) where

import BotInterface.Wallet qualified as BW
import Control.Monad (forever, replicateM_)
import Data.Text (Text)
import Data.Text.Encoding (encodeUtf8)
import LocalCluster.Cluster (runUsingCluster)
import LocalCluster.Wallet
import System.Environment (setEnv)
import Tools.CardanoApi qualified as LCAPI
import Tools.DebugCli qualified as CLI
import Utils (ada, waitSeconds)

import Address as Addr
import BotInterface.Types
import BotInterface.Wallet (BpiWallet)
import LocalCluster.Types (supportDir)

main :: IO ()
main = do
  -- todo: maybe some better configuring procedure should be introduced
  setEnv "SHELLEY_TEST_DATA" "cluster-data/cardano-node-shelley"
  setEnv "NO_POOLS" "1"
  setEnv "CARDANO_NODE_TRACING_MIN_SEVERITY" "Debug"

  runUsingCluster $ \cEnv -> do
    LCAPI.currentBlock cEnv >>= print
    ws <- -- ? maybe it will be more ergonomic to get rid of `Ether` and just fail hard
      BW.usingEnv cEnv . fmap sequence . sequence $
        [ BW.addSomeWallet (ada 101)
        , BW.addSomeWallet (ada 202)
        , BW.addSomeWallet (ada 303)
        ]
    putStrLn "\nDebug check:"
    putStrLn $ "Cluster dir: " <> show (supportDir cEnv)
    waitSeconds 2
    case ws of
      Left e -> error $ "Err: " <> show e
      Right ws' -> mapM_ (CLI.utxoAtAddress cEnv . BW.mkMainnetAddress) ws'
    putStrLn "Done. Debug awaiting - interrupt to exit" >> forever (waitSeconds 60)

testMnemonic :: [Text]
testMnemonic =
  [ "radar"
  , "scare"
  , "sense"
  , "winner"
  , "little"
  , "jeans"
  , "blue"
  , "spell"
  , "mystery"
  , "sketch"
  , "omit"
  , "time"
  , "tiger"
  , "leave"
  , "load"
  ]
