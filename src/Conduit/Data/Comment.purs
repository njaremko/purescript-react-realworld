module Conduit.Data.Comment where

import Prelude
import Apiary.Url as Url
import Conduit.Data.PreciseDateTime (PreciseDateTime)
import Conduit.Data.Profile (Profile)
import Data.Newtype (class Newtype, unwrap, wrap)
import Simple.JSON (class ReadForeign, class WriteForeign, readImpl, writeImpl)

type Comment
  = { id :: CommentId
    , createdAt :: PreciseDateTime
    , updatedAt :: PreciseDateTime
    , body :: String
    , author :: Profile
    }

newtype CommentId
  = CommentId Int

derive instance newtypeCommentId :: Newtype CommentId _

derive newtype instance eqCommentId :: Eq CommentId

instance readForeignCommentId :: ReadForeign CommentId where
  readImpl = readImpl >>> map wrap

instance writeForeignCommentId :: WriteForeign CommentId where
  writeImpl = writeImpl <<< unwrap

instance encodeParamCommentId :: Url.EncodeParam CommentId where
  encodeParam = Url.encodeParam <<< unwrap
