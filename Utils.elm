module Utils exposing (..)

import Http
import Html.Attributes exposing (style)
import Html exposing (..)
import Html.Events exposing (..)

httpResponse : Http.Response -> (() -> (model, Cmd msg)) -> (() -> (model, Cmd msg)) -> (model, Cmd msg)
httpResponse r success failure =
    if r.status < 300 && r.status >= 200 then
      success ()
    else
      failure ()

httpResponse2 : Http.Response -> (() -> Cmd msg) -> (() -> Cmd msg) -> Cmd msg
httpResponse2 r success failure =
    if r.status < 300 && r.status >= 200 then
      success ()
    else
      failure ()

httpResponse1 : Http.Response -> (() -> a) -> (() -> a) -> a
httpResponse1 r success failure =
    if r.status < 300 && r.status >= 200 then
      success ()
    else
      failure ()

popup shouldShow htmlElement msg =
  if shouldShow then
    div [ style (("background-color", "rgba(0, 0, 0, 0.48)")::("z-index", "1000")::centerFlex) ]
    [
      div [ style [("padding", "20px"),("background", "white")]] [
        div [ floatRight, onClick msg ] [ text "x" ]
        , htmlElement
      ]
    ]
  else
    span [] []

type RawHttp =
  RawError Http.RawError
  | RawResponse Http.Response

type ResponseHttp a =
  Error Http.Error
  | ValueResponse a


pointy      = style [pointerTuple]
pointerTuple  = ("cursor", "pointer")
floatLeft   = style [("float", "left"), ("margin-right", "10px")]
floatRight   = style [("float", "right")]
centerFlex  = [("display", "flex"), ("flex-direction", "column"), ("justify-content", "center"), ("align-items", "center"), ("height", "100%"), ("width", "100%"), ("position","absolute")]
