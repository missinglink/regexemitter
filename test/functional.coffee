
EventEmitter = require '../index'
should = require 'should'

describe 'functional tests', ->

  it 'functional #1', (done) ->

    emitter = new EventEmitter()
    called = 0

    testvalues = ( arg, arg2 ) ->

      called++
      arg.should.eql 'bingo'
      arg2.should.eql 'bongo'

      EventEmitter.listenerCount( emitter ).should.eql 1
      EventEmitter.listenerCount( emitter, /hello (world|universe)/ ).should.eql 1
      EventEmitter.listenerCount( emitter, /bango/ ).should.eql 0

      if called > 2 then throw new Error 'event called too many times'
      if called == 2
        setTimeout ->
          emitter.removeListener( /hello (world|universe)/ )
          EventEmitter.listenerCount( emitter ).should.eql 0
          EventEmitter.listenerCount( emitter, /hello (world|universe)/ ).should.eql 0
          EventEmitter.listenerCount( emitter, /bango/ ).should.eql 0
          done()
        , 10

    emitter.on /hello (world|universe)/, testvalues
    emitter.emit 'hello testcase', 'bingo', 'bongo'
    emitter.emit 'hello world', 'bingo', 'bongo'
    emitter.emit 'hello universe', 'bingo', 'bongo'

  it 'functional #2', (done) ->

    emitter = new EventEmitter()
    called = 0

    testvalues = ( arg, arg2 ) ->

      called++
      arg.should.eql 'bingo'
      arg2.should.eql 'bongo'

      EventEmitter.listenerCount( emitter ).should.eql 1
      EventEmitter.listenerCount( emitter, /hello (world|universe)/ ).should.eql 1
      EventEmitter.listenerCount( emitter, /bango/ ).should.eql 0

      if called > 1 then throw new Error 'event called too many times'
      if called == 1
        setTimeout ->
          emitter.removeListener( /hello (world|universe)/ )
          EventEmitter.listenerCount( emitter ).should.eql 0
          EventEmitter.listenerCount( emitter, /hello (world|universe)/ ).should.eql 0
          EventEmitter.listenerCount( emitter, /bango/ ).should.eql 0
          done()
        , 10

    emitter.once /hello (world|universe)/, testvalues
    emitter.emit 'hello testcase', 'bingo', 'bongo'
    emitter.emit 'hello world', 'bingo', 'bongo'
    emitter.emit 'hello universe', 'bingo', 'bongo'

