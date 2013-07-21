
EventEmitter = require '../index'
should = require 'should'
events = require 'events'

func = (arg) -> return arg

describe 'compatibility with nodejs native EventEmitter', ->

  emitter = regex: new EventEmitter(), nodejs: new events.EventEmitter()

  it 'should have the same prototype methods', ->

    for method in Object.keys( events.EventEmitter.prototype )
      EventEmitter.prototype.should.have.property(method).and.be.instanceof Function

  it.skip 'should expect the same amount of arguments for prototype methods', ->

    for method in Object.keys( events.EventEmitter.prototype )
      EventEmitter.prototype[method].length.should.eql events.EventEmitter.prototype[method].length

  it.skip 'should have the same properties & default values', ->

    for prop in Object.keys( emitter.nodejs )
      emitter.regex.should.have.property(prop).and.eql emitter.nodejs[prop]

  describe.skip 'should store events in a compatible way', ->

    if process.version.match /0\.10\./

      it 'should default _events to {} for newer versions of node', ->

        emitter = new EventEmitter()
        emitter.should.have.property('_events').and.eql {}

    else

      it 'should default _events to null for older versions of node', ->

        emitter = new EventEmitter()
        emitter.should.have.property('_events').and.eql null

     it.skip 'should set _events to object on first insert', ->

      emitter = new EventEmitter()
      emitter.should.have.property('_events').and.eql null
      emitter.on( 'test', func )
      emitter.should.have.property('_events').and.eql { test: func }

     it.skip 'should set _events key to array on second insert', ->

      emitter = new EventEmitter()
      emitter.should.have.property('_events').and.eql null
      emitter.on( 'test', func )
      emitter.on( 'test', func )
      emitter.should.have.property('_events').and.eql { test: [ ( func ), ( func ) ] }

    it.skip 'should store once events in the same way (once wrapper)', ->

      should.exist null