-- Copyright (c) 2019 Digital Asset (Switzerland) GmbH and/or its affiliates. All rights reserved.
-- SPDX-License-Identifier: Apache-2.0

{-# LANGUAGE OverloadedStrings #-}

module DAML.Project.Types
    ( module DAML.Project.Types
    ) where

import qualified Data.Yaml as Y
import qualified Data.Text as T
import Data.Text (Text)
import Data.Maybe
import System.FilePath
import Control.Monad
import Control.Exception.Safe

data ConfigError
    = ConfigFileInvalid Text Y.ParseException
    | ConfigFieldInvalid Text [Text] String
    | ConfigFieldMissing Text [Text]
    deriving (Show)

instance Exception ConfigError where
    displayException (ConfigFileInvalid name err) =
        concat ["Invalid ", T.unpack name, " config file:", displayException err]
    displayException (ConfigFieldInvalid name path msg) =
        concat ["Invalid ", T.unpack (T.intercalate "." path)
            , " field in ", T.unpack name, " config: ", msg]
    displayException (ConfigFieldMissing name path) =
        concat ["Missing required ", T.unpack (T.intercalate "." path)
            , " field in ", T.unpack name, " config."]

newtype DamlConfig = DamlConfig
    { unwrapDamlConfig :: Y.Value
    } deriving (Eq, Show, Y.FromJSON)

newtype SdkConfig = SdkConfig
    { unwrapSdkConfig :: Y.Value
    } deriving (Eq, Show, Y.FromJSON)

newtype ProjectConfig = ProjectConfig
    { unwrapProjectConfig :: Y.Value
    } deriving (Eq, Show, Y.FromJSON)

newtype SdkVersion = SdkVersion
    { unwrapSdkVersion :: Text
    } deriving (Eq, Show, Y.FromJSON)

newtype SdkChannel = SdkChannel
    { unwrapSdkChannel :: Text
    } deriving (Eq, Show, Y.FromJSON)

newtype SdkSubVersion = SdkSubVersion
    { unwrapSdkSubVersion :: Text
    } deriving (Eq, Show, Y.FromJSON)

splitVersion :: SdkVersion -> (SdkChannel, SdkSubVersion)
splitVersion (SdkVersion v) =
    case T.splitOn "-" v of
        [] -> error "Logic error: empty version name."
        (ch : rest) -> (SdkChannel ch, SdkSubVersion (T.intercalate "-" rest))

joinVersion :: (SdkChannel, SdkSubVersion) -> SdkVersion
joinVersion (SdkChannel a, SdkSubVersion "") = SdkVersion a
joinVersion (SdkChannel a, SdkSubVersion b) = SdkVersion (a <> "-" <> b)


-- | File path of daml installation root (by default ~/.daml on unix, %APPDATA%/daml on windows).
newtype DamlPath = DamlPath
    { unwrapDamlPath :: FilePath
    } deriving (Eq, Show)

-- | File path of project root.
newtype ProjectPath = ProjectPath
    { unwrapProjectPath :: FilePath
    } deriving (Eq, Show)

-- | File path of sdk root.
newtype SdkPath = SdkPath
    { unwrapSdkPath :: FilePath
    } deriving (Eq, Show)

-- | Default way of constructing sdk paths.
defaultSdkPath :: DamlPath -> SdkVersion -> SdkPath
defaultSdkPath (DamlPath root) (SdkVersion version) =
    SdkPath (root </> "sdk" </> T.unpack version)

-- | File path of sdk command binary, relative to sdk root.
newtype SdkCommandPath = SdkCommandPath
    { unwrapSdkCommandPath :: FilePath
    } deriving (Eq, Show)

instance Y.FromJSON SdkCommandPath where
    parseJSON value = do
        path <- Y.parseJSON value
        unless (isRelative path) $
            fail "SDK command path must be relative."
        pure $ SdkCommandPath path

newtype SdkCommandName = SdkCommandName
    { unwrapSdkCommandName :: Text
    } deriving (Eq, Show, Y.FromJSON)

newtype SdkCommandArgs = SdkCommandArgs
    { unwrapSdkCommandArgs :: [String]
    } deriving (Eq, Show, Y.FromJSON)

data SdkCommandInfo = SdkCommandInfo
    { sdkCommandName :: SdkCommandName  -- ^ name of command
    , sdkCommandPath :: SdkCommandPath -- ^ file path of binary relative to sdk directory
    , sdkCommandArgs :: SdkCommandArgs -- ^ extra args to pass before user-supplied args (defaults to [])
    , sdkCommandDesc :: Maybe Text     -- ^ description of sdk command (optional)
    } deriving (Eq, Show)

instance Y.FromJSON SdkCommandInfo where
    parseJSON = Y.withObject "SdkCommandInfo" $ \p ->
        SdkCommandInfo
            <$> (p Y..: "name")
            <*> (p Y..: "path")
            <*> fmap (fromMaybe (SdkCommandArgs [])) (p Y..:? "args")
            <*> (p Y..:? "desc")
