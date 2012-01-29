### Start-up data

```javascript
{
  c : 'settings',
  assets: [
    { name: 'background', url : '/images/background.png' }
  ],
  config: {
    terrainX    : 0,
    terrainY    : 0,
    gridColumns : 8,
    gridRows    : 8
  }
}
```

### Spawning Units

```javascript
{
  c     : 'spawnUnit',
  id    : 'unitId123', // alphanumeric id
  type  : 'marine', //'e.g. marine'
  stats : {
    health      : 100, // basic constitution
    energy      : 25, // energy used for special skills
    actions     : 5, // points to expend for moving/attacking
    charge      : 100, // when reached maxValue, the unit takes turn
    moveRadius  : 3, // the tile radius of the unit's movable area
    chargeSpeed : 10.4, // speed of how the unit's turn gauge fills up
    armor       : 20, // protection from physical damage
    barrier     : 5 // protection from energy-based weapons

  },
  message: 'e.g. Lemurian Marine called successful'
}
```

### Removing Units

```javascript
{
  c       : 'removeUnit',
  id      : 'unitId123',
  message : 'James' marine has <fallen|vanished>'
}
```
