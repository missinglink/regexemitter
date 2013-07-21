/*global module, window, define */
'use strict';

function EventEmitter() {
  this.domain = null;
  this._events = [];
  this._maxListeners = 10;
}

EventEmitter.listeners = function (emitter, listener) {
  if (!emitter || !Array.isArray( emitter._events )) { return -1; }
  if (!listener) { return emitter._events.length; }
  return emitter._events.filter(function (event) {
    return (String(event.regex) === String(listener));
  }).length;
};

EventEmitter.prototype.on = function (name, listener) {
  if (this._events.length >= this._maxListeners) {
    return this.emit('error', 'max event listeners');
  }
  if (!( name instanceof RegExp || 'string' === typeof name )) {
    throw new Error( 'on only takes regex or string event names' );
  }
  if ( 'function' !== typeof listener ) {
    throw new Error( 'on only takes instances of Function' );
  }
  this._events.push({
    regex: name,
    cb: listener
  });
};

EventEmitter.prototype.once = function (name, listener) {
  if (this._events.length >= this._maxListeners) {
    return this.emit('error', 'max event listeners');
  }
  if (!( name instanceof RegExp || 'string' === typeof name )) {
    throw new Error( 'once only takes regex or string event names' );
  }
  if ( 'function' !== typeof listener ) {
    throw new Error( 'once only takes instances of Function' );
  }
  this._events.push({
    regex: name,
    cb: listener,
    once: true
  });
};

EventEmitter.prototype.removeListener = function (regex) {
  if (!( regex instanceof RegExp || 'string' === typeof regex )) {
    return this.emit('error', 'invalid event name');
  }
  this._events = this._events.filter(function (event) {
    return (String(event.regex) !== String(regex));
  });
};

EventEmitter.prototype.removeAllListeners = function (regex) {
  if (arguments.length && !( regex instanceof RegExp || 'string' === typeof regex )) {
    return this.emit('error', 'invalid event name');
  }
  this._events = this._events.filter(function (event) {
    if (!regex) { return false; }
    if (String(event.regex) === String(regex)) { return false; }
    return true;
  });
};

EventEmitter.prototype.setMaxListeners = function (max) {
  if ('number' !== typeof max) {
    return this.emit('error', 'invalid max value');
  }
  this._maxListeners = max;
};

EventEmitter.prototype.listeners = function (name) {
  return this._events.filter(function (event) {
    return (!name || String(event.regex) === String(name));
  });
};

EventEmitter.prototype.match = function (match) {
  var i = 0, len;
  if ('string' !== typeof match) { throw new Error('invalid string'); }
  for (len = this._events.length; i < len; i++) {
    if (match.match(this._events[i].regex)) {
      return true;
    }
  }
  return false;
};

EventEmitter.prototype.emit = function () {
  var args = Array.prototype.slice.call(arguments, 0);
  var key = args.shift(); // shift key off args
  if ('string' !== typeof key) { throw new Error('invalid string'); }
  var _self = this, i = 0, len;
  for (len = this._events.length; i < len; i++) {
    var event = _self._events[i];
    if (event && key.match(event.regex)) {
      if ('function' === typeof event.cb) {
        event.cb.apply({ event: key }, args);
        if (event.once) { delete _self._events[i]; }
      }
    }
  }
};

// Export for nodejs
if (module !== undefined && module.exports !== undefined) {
  module.exports = EventEmitter;
} else {
  // Export for AMD
  if (typeof define === 'function' && define.amd) {
    define([], function () { return EventEmitter; });
  // Export to browser
  } else {
    window.EventEmitter = EventEmitter;
  }
}