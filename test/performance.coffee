
EventEmitter = require '../index'
should = require 'should'
events = require 'events'

iterate =
  few: 500
  moderate: 100000
  extreme: 100000000

describe 'performance benchmarks', ->

  output = ''
  log = ( title, results ) ->
    line = ' ' + title + ' '
    line += ' ' while line.length < 58
    line += JSON.stringify( results )
      .replace(',','')
      .replace(/:(\d+)/g,': $1ms\t')
      .replace(/[{}"]/g, '') + '\n'
    output += line

  after ->
    console.log()
    console.log( ' ==== benchmark results ====' )
    console.log( output )

  func = (arg) -> return arg

  benchmark = ( func, n, setup ) ->
    start = new Date().getTime()
    for i in [n...0] by -1
      if setup
        sstart = new Date()
        setup()
        stotal = new Date().getTime() - sstart.getTime()
        start += stotal
      func()
    return new Date().getTime() - start

  countValidEvents = ( emitter ) ->
    total = 0
    for k of emitter._events
      if emitter._events[k] then total++
    return total

  it 'should compare instantiation', ->

    iterations = iterate.moderate

    test = ( Class ) -> return new Class()

    regexemitter = benchmark( ( -> test EventEmitter ), iterations )
    nodejs = benchmark( ( -> test events.EventEmitter ), iterations )

    log 'instantiation x'+iterations, regexemitter: regexemitter, nodejs: nodejs
    regexemitter.should.be.within nodejs*-2, nodejs*2

  it 'should compare setMaxListeners', ->

    iterations = iterate.moderate

    test = ( emitter ) -> return emitter.setMaxListeners iterations

    regexemitter = benchmark( ( -> test new EventEmitter() ), iterations )
    nodejs = benchmark( ( -> test new events.EventEmitter() ), iterations )

    log 'setMaxListeners x'+iterations, regexemitter: regexemitter, nodejs: nodejs
    regexemitter.should.be.within (nodejs||1)*-10, (nodejs||1)*10

  it 'should compare add new listener', ->

    iterations = iterate.few

    test = ( emitter ) -> emitter.on( 'foo', func )

    emitter = new EventEmitter()
    emitter.setMaxListeners iterations
    regexemitter = benchmark( ( -> test emitter ), iterations )

    emitter = new events.EventEmitter()
    emitter.setMaxListeners iterations
    nodejs = benchmark( ( -> test emitter ), iterations )

    log 'add new listener x'+iterations, regexemitter: regexemitter, nodejs: nodejs
    regexemitter.should.be.within (nodejs||1)*-75, (nodejs||1)*75

  it 'should compare emitting events with no listeners bound', ->

    iterations = iterate.moderate

    test = ( emitter ) -> emitter.emit( 'foo', func )

    emitter = new EventEmitter()
    regexemitter = benchmark( ( -> test emitter ), iterations )

    emitter = new events.EventEmitter()
    nodejs = benchmark( ( -> test emitter ), iterations )

    log 'emitting string events - no listeners bound x'+iterations, regexemitter: regexemitter, nodejs: nodejs
    regexemitter.should.be.within (nodejs||1)*-75, (nodejs||1)*75

  it 'should compare emitting events with one matching listener bound', ->

    iterations = iterate.moderate

    test = ( emitter ) -> emitter.emit( 'foo', func )

    emitter = new EventEmitter()
    emitter.on( 'foo', func )
    regexemitter = benchmark( ( -> test emitter ), iterations )

    emitter = new events.EventEmitter()
    emitter.on( 'foo', func )
    nodejs = benchmark( ( -> test emitter ), iterations )

    log 'emitting string events - one listener bound x'+iterations, regexemitter: regexemitter, nodejs: nodejs
    regexemitter.should.be.within (nodejs||1)*-75, (nodejs||1)*75

  it 'should compare matching string events with many listeners bound', (done) ->

    iterations = iterate.few
    results = {}

    complete = 0
    success = () -> if ++complete is iterations then done()

    test = ( emitter ) ->
      for i in [iterations...0] by -1
        emitter.emit( 'event-'+i+'-', success )

    setup = ( emitter ) ->
      emitter.setMaxListeners iterations
      countValidEvents( emitter ).should.eql 0
      emitter.on( 'event-'+i+'-', success ) for i in [iterations...0] by -1
      countValidEvents( emitter ).should.eql iterations

    emitter = new EventEmitter()
    results['regexemitter'] = benchmark( ( -> test emitter ), 1, -> setup emitter )

    emitter = new events.EventEmitter()
    results['nodejs'] = benchmark( ( -> test emitter ), 1, -> setup emitter )

    log 'emitting string events - many listeners bound x'+iterations, results
    results.regexemitter.should.be.within (results.nodejs||1)*-300, (results.nodejs||1)*300

  it 'should compare removing all listeners', ->

    iterations = iterate.few
    results = {}

    test = ( emitter ) -> emitter.removeAllListeners()
    setup = ( emitter ) ->
      emitter.setMaxListeners iterations
      countValidEvents( emitter ).should.eql 0
      emitter.on( 'event-'+i+'-', func ) for i in [iterations...0] by -1
      countValidEvents( emitter ).should.eql iterations

    emitter = new EventEmitter()
    results['regexemitter'] = benchmark( ( -> test emitter ), 1, -> setup emitter )

    emitter = new events.EventEmitter()
    results['nodejs'] = benchmark( ( -> test emitter ), 3, -> setup emitter )

    log 'remove all listeners x'+iterations, results
    results.regexemitter.should.be.within (results.nodejs||1)*-300, (results.nodejs||1)*300

  it 'should compare removing listeners one-by-one', ->

    iterations = iterate.few
    results = {}

    test = ( emitter ) ->
      for i in [iterations...0] by -1
        emitter.removeListener( 'event-'+i+'-', func )

    setup = ( emitter ) ->
      emitter.setMaxListeners iterations
      countValidEvents( emitter ).should.eql 0
      emitter.on( 'event-'+i+'-', func ) for i in [iterations...0] by -1
      countValidEvents( emitter ).should.eql iterations

    emitter = new EventEmitter()
    results['regexemitter'] = benchmark( ( -> test emitter ), 1, -> setup emitter )

    emitter = new events.EventEmitter()
    results['nodejs'] = benchmark( ( -> test emitter ), 3, -> setup emitter )

    log 'remove listeners one-by-one x'+iterations, results
    results.regexemitter.should.be.within (results.nodejs||1)*-300, (results.nodejs||1)*300

  # it 'should compare firing and receiving string events one-by-one', ->

  #   iterations = iterate.few
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

  #   log 'remove listener x'+iterations, results
  #   results.regexemitter.should.be.within (results.nodejs||1)*-75, (results.nodejs||1)*75