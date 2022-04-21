-- Copyright (c) 2022 Digital Asset (Switzerland) GmbH and/or its affiliates. All rights reserved.
-- SPDX-License-Identifier: Apache-2.0

module Main (main) where

import qualified CheckReleases
import qualified Docs

import qualified Control.Monad as Control
import qualified Options.Applicative as Opt
import qualified System.IO.Extra as IO

data CliArgs = Docs
             | Check { bash_lib :: String,
                       gcp_credentials :: Maybe String,
                       max_releases :: Maybe Int }

parser :: Opt.ParserInfo CliArgs
parser = info "This program is meant to be run by CI cron. You probably don't have sufficient access rights to run it locally."
              (Opt.hsubparser (Opt.command "docs" docs
                            <> Opt.command "check" check))
  where info t p = Opt.info (p Opt.<**> Opt.helper) (Opt.progDesc t)
        docs = info "Build & push latest docs, if needed."
                    (pure Docs)
        check = info "Check existing releases."
                     (Check <$> Opt.strOption (Opt.long "bash-lib"
                                         <> Opt.metavar "PATH"
                                         <> Opt.help "Path to Bash library file.")
                            <*> (Opt.optional $
                                  Opt.strOption (Opt.long "gcp-creds"
                                         <> Opt.metavar "CRED_STRING"
                                         <> Opt.help "GCP credentials as a string."))
                            <*> (Opt.optional $
                                  Opt.option Opt.auto (Opt.long "max-releases"
                                         <> Opt.metavar "INT"
                                         <> Opt.help "Max number of releases to check.")))

main :: IO ()
main = do
    Control.forM_ [IO.stdout, IO.stderr] $
        \h -> IO.hSetBuffering h IO.LineBuffering
    opts <- Opt.execParser parser
    case opts of
      Docs -> do
          Docs.docs Docs.sdkDocOpts
          Docs.docs Docs.damlOnSqlDocOpts
      Check { bash_lib, gcp_credentials, max_releases } ->
          CheckReleases.check_releases gcp_credentials bash_lib max_releases
