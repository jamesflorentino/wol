Stats =
  defaults:
    name        : 'basic'
    type        : 'basic'
    health      : 100   # hit points
    energy      : 0     # used for energy based skills like shields, etc.
    actions     : 0     # points expended when moving to tiles and performing actions.
    moveRadius  : 1     # the number of tiles the unit can travel to
    chargeSpeed : 0     # determines how fast the charge meter fills up
    armor       : 0     # depletable amount of physical protection
    barrier     : 5     # depletable amount of protection from energy-based attacks
    charge      : 100   # amount that needs to be filled up before the unit takes a current turn


  marine:
    name        : 'Lemurian Marine'
    type        : 'marine'
    health      : 100
    energy      : 100
    actions     : 5
    moveRadius  : 3
    chargeSpeed : 10.4
    armor       : 20
    barrier     : 5
    charge      : 100



getStats = (name) ->
  stat = Stats[name]
  stat = Stats.default if !stat
  stat

exports.getStats = getStats
