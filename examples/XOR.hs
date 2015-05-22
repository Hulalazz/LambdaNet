{-# LANGUAGE FlexibleContexts #-}

import           AI.Layer
import           AI.Neuron

import           AI.Network
import           AI.Network.FeedForwardNetwork

import           AI.Trainer
import           AI.Trainer.BackpropTrainer

--import Network.Visualizations
import           Numeric.LinearAlgebra
import           System.IO
import           System.Random

main :: IO ()
main = do

  g <- newStdGen
  let l = LayerDefinition sigmoidNeuron 2 connectFully randomizeFully
  let l' = LayerDefinition sigmoidNeuron 2 connectFully randomizeFully
  let l'' = LayerDefinition sigmoidNeuron 1 connectFully randomizeFully

  let n = createNetwork normals g [l, l', l'']

  let t = BackpropTrainer (3 :: Double) quadraticCost quadraticCost'
  let dat = [(fromList [0, 1], fromList [1]), (fromList [1, 1], fromList [0]), (fromList [1, 0], fromList [1]), (fromList [0, 0], fromList [0])]

  let n' = trainNTimes g n t online dat 1000

  putStrLn "==> XOR predictions: "
  print $ predict (fromList [0, 0]) n'
  print $ predict (fromList [1, 0]) n'
  print $ predict (fromList [0, 1]) n'
  print $ predict (fromList [1, 1]) n'

  saveFeedForwardNetwork "xor.ann" n'

  putStrLn $ "==> Network saved and reloaded: "
  n'' <- loadFeedForwardNetwork "xor.ann" [l, l', l'']

  print $ predict (fromList [0, 0]) n''
  print $ predict (fromList [1, 0]) n''
  print $ predict (fromList [0, 1]) n''
  print $ predict (fromList [1, 1]) n''

  --networkHistogram "weights.png" weightList n''
  --networkHistogram "biases.png" biasList n''
