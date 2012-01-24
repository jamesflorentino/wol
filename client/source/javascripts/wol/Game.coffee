#= require wol/GameModel
#= require wol/GameView

@Wol


class Wol.Game
  constructor: (elName) ->
    model = new Wol.Models.GameModel()
    view  = new Wol.Views.GameView
      model      : model
      elName     : "##{elName}"

Wol.begin = (el) ->
  Wol.game = new Wol.Game el
