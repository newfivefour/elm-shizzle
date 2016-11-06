module Views.CompanyAdd exposing (renderCompanyAdd)

import Html exposing (Html, div, text, button, input)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (placeholder)
import Model exposing (Model, LoginInputModel)
import Messages exposing (Msg(CompanyAdd), CompanyInputData(..))

renderCompanyAdd: Html Msg
renderCompanyAdd =
  div [] [
      div []
          [
            input [ onInput (Name >> CompanyAdd), placeholder "Name"] []
          ]
      , div []
          [
            input [ onInput (Lat >> CompanyAdd), placeholder "lat"] []
          ]
      , div []
          [
            input [ onInput (Lon >> CompanyAdd), placeholder "lon"] []
          ]
      , div []
          [
            input [ onInput (Postcode >> CompanyAdd), placeholder "postcode" ] []
         ]
      , button [ onClick (CompanyAddPress |> CompanyAdd) ] [ text "Add company" ]
      ]