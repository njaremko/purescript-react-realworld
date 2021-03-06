module Conduit.Component.App where

import Prelude
import Conduit.AppM (AppM, runAppM)
import Conduit.Env (Env)
import Control.Monad.Reader (ReaderT, ask)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import React.Basic.Hooks as React
import React.Store (Instance, Store, UseStore, useStore)

type Component props
  = ReaderT Env Effect (props -> React.JSX)

component ::
  forall props state action hooks.
  String ->
  { init :: state
  , update :: Instance props state (AppM Aff) -> action -> AppM Aff Unit
  } ->
  (Env -> Store state action -> props -> React.Render (UseStore props state action (AppM Aff) Unit) hooks React.JSX) ->
  Component props
component name { init, update } renderFn = do
  env <- ask
  liftEffect
    $ React.component name \props -> React.do
        store <- useStore { init, props, update, launch: runAppM env }
        renderFn env store props

component' ::
  forall props hooks.
  String ->
  (Env -> props -> React.Render Unit hooks React.JSX) ->
  Component props
component' name renderFn = do
  env <- ask
  liftEffect
    $ React.component name \props -> React.do
        renderFn env props
