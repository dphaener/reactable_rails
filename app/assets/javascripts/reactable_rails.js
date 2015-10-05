/* globals React */

var classify = function(str) {
  var splits = str.split("_");
  var len = splits.length >>> 0;
  var classified = [];

  for(var i = 0; i < len; i++) {
    var word = splits[i];
    word = word.charAt(0).toUpperCase() + word.substring(1);
    classified.push(word);
  }

  return classified.join("");
}

// Unobtrusive scripting adapter for React
;(function(document, window) {
  // jQuery is optional. Use it to support legacy browsers.
  var $ = (typeof window.jQuery !== 'undefined') && window.jQuery;

  // create the  namespace
  window.ReactRailsUJS = {
    CLASS_NAME_ATTR: 'data-react-class',
    PROPS_ATTR: 'data-react-props',
    BUNDLE_ATTR: 'data-react-bundle',
    // helper method for the mount and unmount methods to find the
    // `data-react-class` DOM elements
    findDOMNodes: function(searchSelector) {
      // we will use fully qualified paths as we do not bind the callbacks
      var selector;
      if (typeof searchSelector === 'undefined') {
        var selector = '[' + window.ReactRailsUJS.CLASS_NAME_ATTR + ']';
      } else {
        var selector = searchSelector + ' [' + window.ReactRailsUJS.CLASS_NAME_ATTR + ']';
      }

      if ($) {
        return $(selector);
      } else {
        return document.querySelectorAll(selector);
      }
    },

    mountComponents: function(searchSelector) {
      var nodes = window.ReactRailsUJS.findDOMNodes(searchSelector);

      for (var i = 0; i < nodes.length; ++i) {
        var node = nodes[i];
        var className = node.getAttribute(window.ReactRailsUJS.CLASS_NAME_ATTR);
        var bundleName = node.getAttribute(window.ReactRailsUJS.BUNDLE_ATTR)
        bundleName = classify(bundleName);

        // Assume className is simple and can be found at top-level (window).
        // Fallback to eval to handle cases like 'My.React.ComponentName'.
        var constructor = window[bundleName][className] || eval.call(window, className);
        var propsJson = node.getAttribute(window.ReactRailsUJS.PROPS_ATTR);
        var props = propsJson && JSON.parse(propsJson);

        React.render(React.createElement(constructor, props), node);
      }
    },

    unmountComponents: function(searchSelector) {
      var nodes = window.ReactRailsUJS.findDOMNodes(searchSelector);

      for (var i = 0; i < nodes.length; ++i) {
        var node = nodes[i];

        React.unmountComponentAtNode(node);
      }
    }
  };

  function handleNativeEvents() {
    if ($) {
      $(function() {window.ReactRailsUJS.mountComponents()});
      $(window).unload(function() {window.ReactRailsUJS.unmountComponents()});
    } else {
      document.addEventListener('DOMContentLoaded', function() {window.ReactRailsUJS.mountComponents()});
      window.addEventListener('unload', function() {window.ReactRailsUJS.unmountComponents()});
    }
  }

  handleNativeEvents();
})(document, window);
