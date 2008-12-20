Liquid.readTemplateFile = function(path) {
  var elem = $(path);
  if(elem) {
    return elem.innerHTML;
  } else {
    return path +" can't be found."; 
    // Or throw and error, or whatever you want...
  }
}
var src = "{% include 'myOtherTemplate' with current_user %}";

var tmpl = Liquid.parse( src );

alert( tmpl.render({ current_user:'M@' }));