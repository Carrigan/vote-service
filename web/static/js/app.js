// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

export var VoteApp = {
  get_election: function(election, success, failure) {
    $.ajax({
      type: "GET",
      url: "/api/elections/" + election,
      contentType: "application/json; charset=utf-8",
      success: success,
      error: failure
    })
  },

  make_election: function(candidates, name, seats, success, failure) {
    var candidate_objects = $.map(candidates, function(candidate) { return {name: candidate}; })
    $.ajax({
      type: "POST",
      url: "/api/elections/",
      contentType: "application/json; charset=utf-8",
      data: JSON.stringify({election: {candidates: candidate_objects, name: name, seats: seats}}),
      dataType: "json",
      success: success,
      error: failure
    })
  },
}
