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

var elmDiv = document.getElementById('elm-main')
var elmApp = Elm.Main.embed(elmDiv);

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

  cast_vote: function(election_id, candidate_ids, success, failure) {
    var entries = $.map(candidate_ids, function(c_id, i) {
      return { candidate_id: c_id, rank: i };
    });

    $.ajax({
      type: "POST",
      url: "/api/elections/" + election_id + "/votes",
      contentType: "application/json; charset=utf-8",
      data: JSON.stringify({vote: {vote_entries: entries}}),
      dataType: "json",
      success: success,
      error: failure
    })
  },

  close_election: function(election_close_url, success, failure) {
    $.ajax({
      type: "GET",
      url: "/api/close_poll/" + election_close_url,
      contentType: "application/json; charset=utf-8",
      success: success,
      error: failure
    });
  },

  get_elections: function(success, failure) {
    $.ajax({
      type: "GET",
      url: "/api/elections",
      contentType: "application/json; charset=utf-8",
      success: success,
      error: failure
    });
  }
}
