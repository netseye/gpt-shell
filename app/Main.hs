{-# LANGUAGE LambdaCase #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified Data.Text as T
import Network.HTTP.Client
import Network.HTTP.Client.TLS
import OpenAI.Client
import System.Environment (getArgs, getEnv)

makeClient :: IO OpenAIClient
makeClient =
  do
    manager <- newManager tlsManagerSettings
    apiKey <- T.pack <$> getEnv "OPENAI_API_KEY"
    pure (makeOpenAIClient apiKey manager 2)

forceSuccess :: (MonadFail m, Show a) => m (Either a b) -> m b
forceSuccess req = req >>= \case Left err -> fail (show err); Right ok -> pure ok

makeChatCompletionRequest :: String -> ChatCompletionRequest
makeChatCompletionRequest msg =
  defaultChatCompletionRequest
    (ModelId "gpt-3.5-turbo-16k")
    [ ChatMessage
        { chmRole = "user",
          chmContent = Just (T.pack msg),
          chmFunctionCall = Nothing,
          chmName = Nothing
        }
    ]

chat :: IO OpenAIClient -> String -> IO String
chat client msg = do
  cli <- client
  let completion = makeChatCompletionRequest msg
  res <- forceSuccess $ completeChat cli completion
  case content res of
    Nothing -> pure "No response"
    Just response -> pure response
  where
    content res = T.unpack <$> chmContent (chchMessage $ head (chrChoices res))

main :: IO ()
main = do
  args <- getArgs
  case args of
    ["--help"] -> putStrLn "Usage: ask <prompt>"
    [] -> putStrLn "Usage: ask <prompt>"
    _ -> do
      chat makeClient (unwords args) >>= putStrLn
