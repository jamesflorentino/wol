var Settings, randomID, settings;

randomID = function(len) {
  var index, randomStr, strings;
  if (len == null) len = 10;
  strings = 'abcdefghijklmopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUV0123456789';
  randomStr = '';
  while (len-- > -1) {
    index = Math.random() * strings.length;
    randomStr += strings.substr(index, 1);
  }
  return randomStr;
};

Settings = (function() {

  function Settings() {
    this.assets = [];
    this.config = {};
    return;
  }

  Settings.prototype.addConfig = function(key, value) {
    this.config[key] = value;
  };

  Settings.prototype.addAsset = function(name, url) {
    this.assets.push({
      name: name,
      url: url
    });
  };

  return Settings;

})();

settings = new Settings();

settings.addAsset('background', '/images/background.png');

settings.addAsset('terrain', '/images/terrain.png');

settings.addAsset('hex', '/images/hex.png');

settings.addAsset('marine', '/images/marine.png');

settings.addConfig('terrainX', -40);

settings.addConfig('terrainY', 100);

settings.addConfig('gridColumns', 8);

settings.addConfig('gridRows', 8);

settings.addConfig('hexWidth', 126);

settings.addConfig('hexHeight', 86);

settings.addConfig('hexOffsetX', 63);

settings.addConfig('hexOffsetY', 22);

exports.assets = settings.assets;

exports.config = settings.config;
