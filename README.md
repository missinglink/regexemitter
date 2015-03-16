
# regex event emitter

An event emitter which takes regular expressions & strings for event names.

Well tested and available in vanilla javascript for the browser or server.

### install

```bash
npm install regexemitter --save
```

[![NPM](https://nodei.co/npm/regexemitter.png?downloads=true&stars=true)](https://nodei.co/npm/regexemitter/)

### example

```javascript
/**
  regexeventemitter behaves just like nodejs native emitter except it
  allows regular expressions as event names.
**/

var EventEmitter = require('regexemitter');
var events = new EventEmitter();

// register a new event
events.on( /send this message to (john|dave)/, function ( arg1, arg2 ){

  console.log( 'event:', this.event );
  console.log( 'message:', arg1, arg2 );

});

events.emit( 'send this message to john', 'hello', 'john' );
events.emit( 'send this message to andy', 'hi', 'andy' );
events.emit( 'send this message to dave', 'ahoy', 'dave' );
```

### output

```bash
event: send this message to john
message: hello john

event: send this message to dave
message: ahoy dave
```

## for the browser

Copy `index.js` to your web server and rename it `regexemitter.js`.

### example

```html
<script type="text/javascript" src="regexemitter.js"></script>
<script type="text/javascript">

  /**
    regexeventemitter behaves just like nodejs native emitter except it
    allows regular expressions as event names.
  **/

  var events = new EventEmitter();

  // register a new event
  events.on( /send this message to (john|dave)/, function ( arg1, arg2 ){

    console.log( 'event:', this.event );
    console.log( 'message:', arg1, arg2 );

  });

  events.emit( 'send this message to john', 'hello', 'john' );
  events.emit( 'send this message to andy', 'hi', 'andy' );
  events.emit( 'send this message to dave', 'ahoy', 'dave' );

</script>
```

### output

```bash
event: send this message to john
message: hello john

event: send this message to dave
message: ahoy dave
```

## build status

```bash
npm test
```

[![Build Status](https://travis-ci.org/missinglink/regexemitter.png?branch=master)](https://travis-ci.org/missinglink/regexemitter)

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/missinglink/regexemitter/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

## license

The MIT License (MIT)

Copyright (c) Peter Johnson <@insertcoffee>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.