var Stats, getStats;

Stats = {
  defaults: {
    name: 'basic',
    type: 'basic',
    health: 100,
    energy: 0,
    actions: 0,
    moveRadius: 1,
    chargeSpeed: 0,
    armor: 0,
    barrier: 5,
    charge: 100
  },
  marine: {
    name: 'Lemurian Marine',
    type: 'marine',
    health: 100,
    energy: 100,
    actions: 5,
    moveRadius: 3,
    chargeSpeed: 10.4,
    armor: 20,
    barrier: 5,
    charge: 100
  }
};

getStats = function(name) {
  var stat;
  stat = Stats[name];
  if (!stat) stat = Stats["default"];
  return stat;
};

exports.getStats = getStats;
