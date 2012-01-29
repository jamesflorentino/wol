var GameUnit, GameUnits, Hex, HexGrid, Model, Room, Rooms, Settings, Stats, User, Users, __implement, __randomID,
  __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

Stats = require('./UnitStats.js');

__randomID = function(len) {
  var index, randomStr, strings;
  if (len == null) len = 10;
  strings = 'abcdefghijklmopqrstuvwxyz0123456789';
  randomStr = '';
  while (len-- > -1) {
    index = Math.random() * strings.length;
    randomStr += strings.substr(index, 1);
  }
  return randomStr;
};

__implement = function(obj, prop) {
  var key;
  for (key in prop) {
    obj[key] = prop[key];
  }
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

Model = (function() {

  function Model(prop) {
    this.attributes || (this.attributes = {});
    if (prop instanceof Object) __implement(this.attributes, prop);
    this.set({
      id: __randomID()
    });
    this.initialize(prop);
  }

  Model.prototype.initialize = function(prop) {
    return this;
  };

  Model.prototype.set = function(prop) {
    __implement(this.attributes, prop);
  };

  Model.prototype.get = function(name) {
    return this.attributes[name];
  };

  return Model;

})();

User = (function(_super) {

  __extends(User, _super);

  function User() {
    User.__super__.constructor.apply(this, arguments);
  }

  User.prototype.initialize = function() {
    this.set({
      id: __randomID()
    });
  };

  User.prototype.set = function(prop) {
    this.attributes || (this.attributes = {});
    return __implement(this.attributes, prop);
  };

  User.prototype.get = function(name) {
    this.attributes || (this.attributes = {});
    return this.attributes[name];
  };

  return User;

})(Model);

Hex = (function(_super) {

  __extends(Hex, _super);

  function Hex() {
    Hex.__super__.constructor.apply(this, arguments);
  }

  Hex.prototype.initialize = function() {
    var tileX, tileY;
    tileX = this.get('tileX');
    tileY = this.get('tileY');
    return this.tileId = "" + tileX + "_" + tileY;
  };

  return Hex;

})(Model);

HexGrid = (function() {

  function HexGrid() {}

  HexGrid.prototype.setMap = function(map) {
    switch (map) {
      case 'mp_lemuria':
        this.setGrid(8, 8);
        break;
      default:
        this.setGrid(5, 5);
    }
  };

  HexGrid.prototype.setGrid = function(columns, rows) {
    var columnCount, hex, rowCount;
    this.__dict = {};
    rowCount = 0;
    while (rowCount < rows) {
      columnCount = 0;
      while (columnCount < columns) {
        hex = new Hex({
          tileX: columnCount,
          tileY: rowCount
        });
        this.__dict[hex.tileId] = hex;
        columnCount++;
      }
      rowCount++;
    }
  };

  HexGrid.prototype.getTile = function(x, y) {
    return this.__dict["" + x + "_" + y];
  };

  return HexGrid;

})();

Room = (function(_super) {

  __extends(Room, _super);

  function Room() {
    Room.__super__.constructor.apply(this, arguments);
  }

  Room.prototype.initialize = function() {
    this.set({
      id: __randomID()
    });
    this.users = [];
  };

  Room.prototype.addUser = function(user) {
    if (!user) return;
    this.users.push(user);
  };

  Room.prototype.removeUser = function(user) {
    var index;
    index = this.users.indexOf(user);
    return this.users.splice(index, 1);
  };

  Room.prototype.find = function(userId) {
    var result;
    result = this.users.filter(function(player) {
      var playerId;
      playerId = player.get('id');
      if (playerId === userId) return true;
      return false;
    });
    return result[0];
  };

  return Room;

})(Model);

Users = (function() {

  function Users() {
    return;
  }

  Users.prototype.add = function(user) {
    this.users || (this.users = []);
    this.users[user.id] = user;
    return this.trigger('add', user.id);
  };

  Users.prototype.remove = function(user) {
    var userId;
    userId = user.id;
    delete this.users[user.id];
    return this.trigger('remove', userId);
  };

  return Users;

})();

Rooms = (function() {

  function Rooms() {
    this;
  }

  Rooms.prototype.joinRoom = function(userName, roomId) {
    var room;
    if (!this.list) return;
    if (!this.list[roomId]) return;
    room = this.list[roomId];
    room.addUser(userName, roomId);
    this.trigger('joinRoom', roomId);
  };

  Rooms.prototype.createRoom = function(roomName) {
    var room, roomId;
    this.list || (this.list = []);
    room = new Room({
      name: roomName
    });
    roomId = room.get('id');
    this.list[roomId] = room;
    return room;
  };

  Rooms.prototype.getRoomByName = function(name) {
    var room, roomId, roomName;
    for (roomId in this.list) {
      room = this.list[roomId];
      roomName = room.name;
      if (roomName === name) break;
    }
    return room;
  };

  Rooms.prototype.getRoomList = function() {
    var list, room, roomId;
    list = [];
    for (roomId in this.list) {
      room = this.list[roomId];
      list.push(room);
    }
    return list;
  };

  Rooms.prototype.deleteRoom = function(roomId) {
    return delete this.list[roomId];
  };

  return Rooms;

})();

GameUnit = (function(_super) {

  __extends(GameUnit, _super);

  function GameUnit() {
    GameUnit.__super__.constructor.apply(this, arguments);
  }

  GameUnit.prototype.initialize = function(params) {
    return this;
  };

  GameUnit.prototype.move = function(tileX, tileY) {
    this.set({
      tileX: tileX,
      tileY: tileY
    });
  };

  return GameUnit;

})(Model);

GameUnits = (function() {

  function GameUnits() {
    this;
  }

  GameUnits.prototype.add = function(unit) {
    this.units || (this.units = []);
    return this.units.push(unit);
  };

  GameUnits.prototype.createUnit = function(name, i) {
    var stat, unit, unitName;
    stat = Stats.getStats(name);
    unit = new GameUnit(stat);
    unitName = unit.get('name');
    return unit;
  };

  GameUnits.prototype.getDefaultUnitName = function(race) {
    var name;
    name = '';
    switch (race) {
      case 'lemurian':
        name = 'marine';
    }
    return name;
  };

  return GameUnits;

})();

exports.Settings = Settings;

exports.Users = Users;

exports.Rooms = Rooms;

exports.User = User;

exports.GameUnits = GameUnits;

exports.HexGrid = HexGrid;
