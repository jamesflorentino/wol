@GEWol = {}

@GEWol.StatNames =
  HEALTH       : 'health' # basic constitution
  ENERGY       : 'energy' # energy used for special skills
  ACTIONS      : 'actions' # points to expend for moving/attacking
  CHARGE       : 'chargeMeter' # when reached maxValue, it's the unit's turn
  MOVE_RADIUS  : 'moveRadius' # radius of tiles the unit could move.
  CHARGE_SPEED : 'chargeSpeed' # how fast the charge meter fills up

  ARMOR        : 'armor' # reduces physical damage 
  BARRIER      : 'barrier' # reduces energy-based weapon damage
  WALK_SPEED   : 'walkSpeed' # how fast the unit walks per tile


@GEWol.Settings =
  assets: [
    { 'name' : 'background'      , 'url' : '/images/background.png'      }
    { 'name' : 'terrain'         , 'url' : '/images/terrain.png'         }
    { 'name' : 'hex'             , 'url' : '/images/hex.png'             }
    { 'name' : 'marine'          , 'url' : '/images/marine.png'          }
    { 'name' : 'unitaction_move' , 'url' : '/images/unitaction_move.png' }
    { 'name' : 'unitaction_act'  , 'url' : '/images/unitaction_act.png'  }
    { 'name' : 'unitaction_skip' , 'url' : '/images/unitaction_skip.png' }
  ]
  settings:
    terrainX    : 0
    terrainY    : 170
    tileWidth   : 126
    tileHeight  : 86
    tileOffsetX : 63
    tileOffsetY : 22
    gridX       : 8
    gridY       : 8
    tiles       : []
    ###
    tiles: [
      { x:2 , y:1 , status:"empty" }
      { x:3 , y:1 , status:"empty" }
      { x:4 , y:1 , status:"empty" }
      { x:2 , y:0 , status:"empty" }
      { x:3 , y:0 , status:"empty" }
      { x:4 , y:0 , status:"empty" }
      { x:5 , y:0 , status:"empty" }
    ]
    ###

@GEWol.Settings.settings.units =
  marine:
    stats:
      hp          : 100
      energy      : 30
      actions     : 4
      moveRadius  : 4
      chargeSpeed : 20
      armor       : 20
      barrier     : 0
      walkSpeed   : 1230
    frameData:
      animations:
        onDieStart    : [ 61, 88 ]
        onMoveStart   : [ 1, 3 ]
        onMove        : [ 4, 16 ]
        onMoveEnd     : [ 17, 23 ]
        onDefendStart : [ 52, 54 ]
        onAttackStart : [ 24, 51 ]
        all           : [ 0, 0 ]
        onDefendEnd   : [ 58, 60 ]
        onDefend      : [ 55, 57 ]
      frames:
        regX   : 33
        width  : 112
        regY   : 75
        height : 97
        count  : 103
