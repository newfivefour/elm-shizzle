module View exposing (..)

import Html.App
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json

import Utils exposing (..)
import Messages exposing (..)
import Model exposing (..)
import Views.Login exposing (..)

view model loginInput companyInput companySelect =
  let
    mainContent = div []
      [ div [ id "mapid", floatLeft ] []
        , companyInfoBox companySelect.id model.techAddInput model.companies
      ]
  in
    div []
        [
        mainContent
        , if loginInput.loginShow then
          div [] [ Utils.popup True (renderLogin model.session loginInput) (LoginShow False |> Login) ]
        else if companyInput.companyAddShow then
          div [] [ span [] [], Utils.popup True (renderCompanyAdd model) (CompanyAddShow False |> CompanyAdd) ]
        else
          span [] []
        ]

companyInfoBox selectedId techAddInput companies =
  let
    company     = List.filter (\c -> c.id == selectedId) companies |> List.head
    delCompany id = span [ style [("cursor", "pointer")], onClick (id |> CompanyDel) ] [ text " ×" ]
  in
    case company of
      Just c ->
        div [ floatLeft ]
            [ button [ onClick (CompanyNext |> CompanyList) ] [ text "next" ]
              , button [ onClick (CompanyAddShow True |> CompanyAdd) ] [ text "add" ]
              , h5 [] [ text (c.name), delCompany c.id ]
              , div [] [ renderTech techAddInput c.technologies c.id ]
            ]
      Nothing ->
        div [ floatLeft ] [text "Try selecting a company"]


renderCompanyAdd : Model -> Html Msg
renderCompanyAdd model =
  div [] [
      h5 [] [text "Add company"]
      , div [id "addCompany"] [
        div []
            [
              input [ name "companyName",  onInput (Name >> CompanyAdd), type' "text", placeholder "name"] []
            ]
        , div []
            [
              input [ name "companyLat", onInput (Lat >> CompanyAdd), type' "text", placeholder "lat" ] []
           ]
        , div []
            [
              input [ onInput (Lon >> CompanyAdd), type' "text", placeholder "lon" ] []
           ]
        , button [ onClick (CompanyAddPress |> CompanyAdd), type' "text" ] [ text "Add company" ]
       ]
      ]

renderTech : TechAddInputModel -> Maybe (List Technology) -> String -> Html Msg
renderTech techAddModel ts companyId =
  let
    codeToMsg        = Json.map (\k -> TechEnter k companyId |> TechAdd) keyCode
    del companyId    = span [ style [("cursor", "pointer")], onClick (companyId |> TechDel) ] [ text " ×" ]
    showTechAdd      = if companyId == techAddModel.techAddBox then ("display","none") else ("display","block")
    showInput        = if companyId == techAddModel.techAddBox then ("display","block") else ("display","none")
    techInput techId =
      div [] [
           input [
             name "techAdd"
             , style [showInput]
             , placeholder "tech"
             , type' "text"
             , onInput (TechName >> TechAdd)
             , on "keyup" codeToMsg
           ] [ ]
           , span [
               style [showTechAdd, ("padding", "4px"), ("padding", "4px"), ("font-weight", "bold")]
               , onClick (techId |> TechAddToggle >> TechAdd)
           ]
           [ text " +" ]
      ]
    technologies = case ts of
      Just t  -> List.map (\t -> span [] [code [] [text t.name], del t.id]) t
      Nothing -> [div [] []]
  in
    div [style [("margin-left", "10px")] ] (List.append technologies [techInput companyId])
