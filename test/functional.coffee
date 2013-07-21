
EventEmitter = require '../index'
should = require 'should'

describe 'functional tests', ->

  it 'should work as per the readme example', (done) ->

    called = 0
    events = new EventEmitter()
    events.on /send this message to (john|dave)/, ( arg1, arg2 ) ->

      [ 'send this message to john', 'send this message to dave' ]
        .should.include this.event

      [ 'hello john', 'ahoy dave' ]
        .should.include arg1 + ' ' + arg2

      if ++called > 1 then done()

    events.emit( 'send this message to john', 'hello', 'john' );
    events.emit( 'send this message to andy', 'hi', 'andy' );
    events.emit( 'send this message to dave', 'ahoy', 'dave' );

  it 'should only fire once when the listener is removed during the first callback', (done) ->

    called = 0
    emitter = new EventEmitter()

    test = ->

      # remove listener after first invocation
      if ++called is 1
        EventEmitter.listenerCount( emitter ).should.eql 1 # listener still registered
        emitter.removeListener( /hello (world|universe)/ )
        EventEmitter.listenerCount( emitter ).should.eql 0 # listener removed successfully
      
      # mocha will complain if done is called more than once
      done()

    emitter.once /hello (world|universe)/, test
    emitter.emit 'hello testcase', 'bingo', 'bongo'
    emitter.emit 'hello world', 'bingo', 'bongo'
    emitter.emit 'hello universe', 'bingo', 'bongo'

