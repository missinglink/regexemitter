
EventEmitter = require '../index'
should = require 'should'
events = require 'events'

iterate =
  few: 50
  moderate: 500
  heavy: 100000
  extreme: 1000000

describe 'performance benchmarks', ->

  output = ''
  log = ( title, iterations, results ) ->
    stats = {}
    for k, val of results
      stats[k] = ( parseInt( val, 10 ) / iterations ) + '       '

    perc = Math.round( (stats['regexemitter']||0.1) / (stats['nodejs']||0.1) * 100 )

    if( Infinity is perc ) then text = 'Infinity'
    else if( perc <= 100 ) then text = '-' + ( 100-perc ) + '%'
    else text = '+' + ( perc-100 ) + '%'
    
    stats['diff'] = text
    line = '    ' + title + ' x' + iterations + ' '
    line += ' ' while line.length < 58
    line += JSON.stringify( stats )
      .replace(/:"?([^"}]+)/g,': $1\t')
      .replace(/[,{}"]/g, '')
      .replace(/diff: (-\w+%)/g, '\x1b[1;32m✓\x1b[0;32m $1\x1b[0m' )
      .replace(/diff: (\+\w+%)/g, '\x1b[1;31m✘\x1b[1;31m $1\x1b[0m' )
      .replace(/diff: (Infinity)/g, '\x1b[1;34m∞\x1b[1;34m $1\x1b[0m' );

    output += line + '\n'

  after ->
    console.log()
    console.log( '  benchmark results' )
    console.log( output )

  func = (arg) -> return arg

  benchmark = ( func, n, setup ) ->
    start = new Date().getTime()
    for i in [n...0] by -1
      sstart = new Date()
      if setup then setup()
      start += new Date().getTime() - sstart.getTime()
      func()
    return new Date().getTime() - start

  countValidEvents = ( emitter ) ->
    total = 0
    for k of emitter._events
      if emitter._events[k]? then total++
    return total

  it 'should compare instantiation', ->

    iterations = iterate.extreme

    test = ( Class ) -> return new Class()

    regexemitter = benchmark( ( -> test EventEmitter ), iterations )
    nodejs = benchmark( ( -> test events.EventEmitter ), iterations )

    log 'instantiation', iterations, regexemitter: regexemitter, nodejs: nodejs
    regexemitter.should.be.within (nodejs||1)*-10, (nodejs||1)*10

  it 'should compare listenerCount - no listeners bound', ->

    iterations = iterate.heavy

    test = ( Class, emitter ) -> Class.listenerCount( emitter ).should.eql 0

    regexemitter = benchmark( ( -> test EventEmitter, new EventEmitter() ), iterations )
    nodejs = benchmark( ( -> test events.EventEmitter, new events.EventEmitter() ), iterations )

    log 'listenerCount - no listeners bound', iterations, regexemitter: regexemitter, nodejs: nodejs
    regexemitter.should.be.within (nodejs||1)*-10, (nodejs||1)*10

  it 'should compare listenerCount - many listeners bound', ->

    iterations = iterate.few * 2

    test = ( Class, emitter ) -> Class.listenerCount( emitter, 'event-1-' ).should.eql 1
    setup = ( emitter ) ->
      emitter.removeAllListeners()
      emitter.setMaxListeners iterations
      countValidEvents( emitter ).should.eql 0
      emitter.on( 'event-'+i+'-', func ) for i in [iterations...0] by -1
      countValidEvents( emitter ).should.eql iterations

    emitter = new EventEmitter()
    regexemitter = benchmark( ( -> test( EventEmitter, emitter ) ), iterations, ( -> setup emitter ) )

    emitter = new events.EventEmitter()
    nodejs = benchmark( ( -> test( events.EventEmitter, emitter ) ), iterations, ( -> setup emitter ) )

    log 'listenerCount - many listeners bound', iterations, regexemitter: regexemitter, nodejs: nodejs
    regexemitter.should.be.within (nodejs||1)*-10, (nodejs||1)*10

  it 'should compare setMaxListeners', ->

    iterations = iterate.heavy

    test = ( emitter ) -> return emitter.setMaxListeners iterations

    regexemitter = benchmark( ( -> test new EventEmitter() ), iterations )
    nodejs = benchmark( ( -> test new events.EventEmitter() ), iterations )

    log 'setMaxListeners', iterations, regexemitter: regexemitter, nodejs: nodejs
    regexemitter.should.be.within (nodejs||1)*-10, (nodejs||1)*10

  it 'should compare add new listener', ->

    iterations = iterate.moderate

    test = ( emitter ) -> emitter.on( 'foo', func )

    emitter = new EventEmitter()
    emitter.setMaxListeners iterations
    regexemitter = benchmark( ( -> test emitter ), iterations )

    emitter = new events.EventEmitter()
    emitter.setMaxListeners iterations
    nodejs = benchmark( ( -> test emitter ), iterations )

    log 'add new listener', iterations, regexemitter: regexemitter, nodejs: nodejs
    regexemitter.should.be.within (nodejs||1)*-75, (nodejs||1)*75

  it 'should compare emitting events with no listeners bound', ->

    iterations = iterate.heavy

    test = ( emitter ) -> emitter.emit( 'test', 'test' )

    emitter = new EventEmitter()
    regexemitter = benchmark( ( -> test emitter ), iterations )

    emitter = new events.EventEmitter()
    nodejs = benchmark( ( -> test emitter ), iterations )

    log 'emit string events - no listeners bound', iterations, regexemitter: regexemitter, nodejs: nodejs
    regexemitter.should.be.within (nodejs||1)*-75, (nodejs||1)*75

  it 'should compare emitting events with one matching listener bound', ->

    iterations = iterate.heavy

    test = ( emitter ) -> emitter.emit( 'test', 'test' )

    emitter = new EventEmitter()
    emitter.on( 'foo', func )
    regexemitter = benchmark( ( -> test emitter ), iterations )

    emitter = new events.EventEmitter()
    emitter.on( 'foo', func )
    nodejs = benchmark( ( -> test emitter ), iterations )

    log 'emit string events - one listener bound', iterations, regexemitter: regexemitter, nodejs: nodejs
    regexemitter.should.be.within (nodejs||1)*-75, (nodejs||1)*75

  it 'should compare matching string events with many listeners bound', (done) ->

    iterations = iterate.moderate
    results = {}

    complete = 0
    success = () -> if ++complete >= ( iterations * 2 ) then done()

    test = ( emitter ) ->
      for i in [iterations...0] by -1
        emitter.emit( 'event-'+i+'-', 'test' )

    setup = ( emitter ) ->
      emitter.removeAllListeners()
      emitter.setMaxListeners iterations
      countValidEvents( emitter ).should.eql 0
      emitter.on( 'event-'+i+'-', success ) for i in [iterations...0] by -1
      countValidEvents( emitter ).should.eql iterations

    emitter = new EventEmitter()
    results['regexemitter'] = benchmark( ( -> test emitter ), 1, -> setup emitter )

    emitter = new events.EventEmitter()
    results['nodejs'] = benchmark( ( -> test emitter ), 1, -> setup emitter )

    log 'emit string events - many listeners bound', iterations, results
    results.regexemitter.should.be.within (results.nodejs||1)*-300, (results.nodejs||1)*300

  it 'should compare matching string events for an average load application', (done) ->

    iterations = iterate.few
    results = {}

    complete = 0
    success = () -> if ++complete >= ( iterations * iterations * 2 ) then done()

    test = ( emitter ) ->
      for i in [iterations...0] by -1
        emitter.emit( 'event-'+i+'-', 'test' )

    setup = ( emitter ) ->
      emitter.removeAllListeners()
      emitter.setMaxListeners iterations
      countValidEvents( emitter ).should.eql 0
      emitter.on( 'event-'+i+'-', success ) for i in [iterations...0] by -1
      countValidEvents( emitter ).should.eql iterations

    emitter = new EventEmitter()
    results['regexemitter'] = benchmark( ( -> test emitter ), iterations, -> setup emitter )

    emitter = new events.EventEmitter()
    results['nodejs'] = benchmark( ( -> test emitter ), iterations, -> setup emitter )

    log 'emit string events - few listeners bound', iterations, results
    results.regexemitter.should.be.within (results.nodejs||1)*-300, (results.nodejs||1)*300

  it 'should compare removing all listeners', ->

    iterations = iterate.moderate
    results = {}

    test = ( emitter ) -> emitter.removeAllListeners()
    setup = ( emitter ) ->
      emitter.removeAllListeners()
      emitter.setMaxListeners iterations
      countValidEvents( emitter ).should.eql 0
      emitter.on( 'event-'+i+'-', func ) for i in [iterations...0] by -1
      countValidEvents( emitter ).should.eql iterations

    emitter = new EventEmitter()
    results['regexemitter'] = benchmark( ( -> test emitter ), 1, -> setup emitter )

    emitter = new events.EventEmitter()
    results['nodejs'] = benchmark( ( -> test emitter ), 3, -> setup emitter )

    log 'remove all listeners', iterations, results
    results.regexemitter.should.be.within (results.nodejs||1)*-300, (results.nodejs||1)*300

  it 'should compare removing listeners one-by-one', ->

    iterations = iterate.moderate
    results = {}

    test = ( emitter ) ->
      for i in [iterations...0] by -1
        emitter.removeListener( 'event-'+i+'-', func )

    setup = ( emitter ) ->
      emitter.removeAllListeners()
      emitter.setMaxListeners iterations
      countValidEvents( emitter ).should.eql 0
      emitter.on( 'event-'+i+'-', func ) for i in [iterations...0] by -1
      countValidEvents( emitter ).should.eql iterations

    emitter = new EventEmitter()
    results['regexemitter'] = benchmark( ( -> test emitter ), 1, -> setup emitter )

    emitter = new events.EventEmitter()
    results['nodejs'] = benchmark( ( -> test emitter ), 3, -> setup emitter )

    log 'remove listeners one-by-one', iterations, results
    results.regexemitter.should.be.within (results.nodejs||1)*-300, (results.nodejs||1)*300

  # it 'should compare firing and receiving string events one-by-one', ->

  #   iterations = iterate.moderate
  #   results = {}

  #   test = ( emitter ) ->
  #     for i in [iterations...0] by -1
  #       emitter.removeListener( 'event-'+i+'-', func )

  #   setup = ( emitter ) ->
  #     emitter.setMaxListeners iterations
  #     countValidEvents( emitter ).should.eql 0
  #     emitter.on( 'event-'+i+'-', func ) for i in [iterations...0] by -1
  #     countValidEvents( emitter ).should.eql iterations

  #   for name, emitter of { regexemitter: new EventEmitter(), nodejs: new events.EventEmitter() }
  #     results[name] = benchmark( ( -> test emitter ), iterations, -> setup emitter )

  #   log 'remove listener', iterations, results
  #   results.regexemitter.should.be.within (results.nodejs||1)*-75, (results.nodejs||1)*75