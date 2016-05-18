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
  get_election: function(election) {
    $.ajax({
      type: "GET",
      url: "/api/elections/" + election,
      contentType: "application/json; charset=utf-8",
      success: function(data) {
        $.each(data.data.candidates, function(i, candidate) {
          console.log(candidate);
          $('#candidates').append("<li id=candidate_'" + candidate.id + "' class='list-group-item'>" + candidate.name + "</li>");
        });
        console.log(data);
      }
    })
  },
}
