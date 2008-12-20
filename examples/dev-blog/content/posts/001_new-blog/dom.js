/*
  Not all functions will work in IE
*/

function DomElement(e) {
  this.element = e;
}

DomElement.prototype = {
  hasClass: function(className) {
    return (this.element.className.indexOf(className) >= 0);
  },

  addClass: function(className, force) {
    if(force ||  !this.hasClass(className) ) {
      var klasses = this.element.className.split(' ')
      klasses.push(className);
      this.element.className = klasses.join(' ');
    }
    return this;
  },

  removeClass: function(className, force) {
    if(force || this.hasClass(className)) {
      var klasses = this.element.className.split(' ');
      var newKlasses = [];
      for (var i=0; i < klasses.length; i++) {
        if(klasses[i] != className)
          newKlasses.push(klasses[i]);
      }
      this.element.className = newKlasses.join(' ');
    }
    return this;
  },

  toggleClass: function(className) {
    if( this.hasClass(className) ) {
      this.removeClass( className, true );
    } else {
      this.addClass( className, true );
    }
    return this;
  }
}

function dom(id) {
  var elem = (typeof(id) == 'string') ? document.getElementById(id) : id;
  return new DomElement( elem );
}


/*

dom('home_button').hasClass('disabled');

onclick="dom(this).toggleClass('selected')"

onclick="dom(document.body).addClass('selected')"

*/


function StatefulElement(e) {
  this.element = e;
}

StatefulElement.prototype = {
  is: function(state) {
    return (this.element.className.indexOf(state) >= 0);
  },
  has: function(state) {
    return this.is(state);
  },

  set: function(state) {
    if(! this.has(state) ) {
      var klasses = this.element.className.split(' ')
      klasses.push(state);
      this.element.className = klasses.join(' ');
    }
    return this;
  },

  clear: function(state) {
    if(this.has(state)) {
      klasses = this.element.className.split(' ');
      newKlasses = [];
      for (var i=0; i < klasses.length; i++) {
        if(klasses[i] != state && state != '*')
          newKlasses.push(klasses[i]);
      }
      this.element.className = newKlasses.join(' ');
    }
    return this;
  },
  unset: function(state) {
    return this.clear(state);
  },

  toggle: function(state) {
    if(this.has(state)) this.clear( state );
    else this.set( state );
    return this;
  }
}

function stateFor(id) {
  var elem = (typeof(id) == 'string') ? document.getElementById(id) : id;
  return new StatefulElement(elem);
}


/*

stateFor(document.body).is('selected')

stateFor(this).set('selected')

stateFor(this).cleard('selected')

stateFor(this).clear('*')

*/