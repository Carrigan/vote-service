import "phoenix_html"

//////////////
// Elm Apps //
//////////////
let votingNode = document.getElementById('vote-box');
let election = document.getElementById("election");

function initializeVoteApp() {
  let electionId = election.getAttribute("data-id");
  if($.cookie('election_' + electionId)) {
    window.location.href = "/results/" + electionId + "?fraud=true";
    return;
  }

  var app = Elm.Vote.embed(votingNode, electionId);

  app.ports.voteComplete.subscribe(function() {
    $.cookie('election_' + electionId, true);
    window.location.href = "/results/" + electionId + "?voted=true";
  });
}

if (votingNode) initializeVoteApp();

///////////////////
// JQUERY API    //
///////////////////

const app = {
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

////////////////
// New Screen //
////////////////

let newScreen = document.getElementById('create-new-election');

if (newScreen) {
  var close_link;
  var election_id;

  var close_success = function() {
    window.location.href = "/results/" + election_id;
  }

  var close_failure = function() {
    console.log("Add an error handler here please!");
  }

  $('#close-button').click(function() {
    app.close_election(close_link, close_success, close_failure);
  });

  var success_handler = function(data) {
    $('#loading').addClass('hidden');
    $('#election_created').removeClass('hidden');

    election_id = data.data.id;
    close_link = data.data.close_url;
    var election_link = '/vote/' + data.data.id;

    $('#election-link').attr('href', election_link);
    $('#election-link').text(election_link);
  }

  var failure_handler = function(data) {
    $('#loading').addClass('hidden');
    $('#create_new').removeClass('hidden');
  }

  var create_new_candidate = function() {
    var container = $('#inputs_div');
    container.append("<input type='text' class='form-control space-bottom'>");
  }

  create_new_candidate();

  $('#more_candidates').click(function() {
    create_new_candidate();
  });

  $('#new_button').click(function() {
    $('#create_new').addClass('hidden');
    $('#election_created').addClass('hidden');
    $('#loading').removeClass('hidden');

    var name = $('#election_name').val();
    var seats = $('#seat_count').val();
    var candidates = $.map($('#inputs_div :input'), function(input) { return $(input).val() });
    app.make_election(candidates, name, seats, success_handler, failure_handler);
  });
}

////////////////////
// Results Screen //
////////////////////

election = document.getElementById("election-results");

if (election) {
  var electionId = election.getAttribute("data-id");

  var query_string = function () {
    // This function is anonymous, is executed immediately and
    // the return value is assigned to QueryString!
    var query_string = {};
    var query = window.location.search.substring(1);
    var vars = query.split("&");
    for (var i=0;i<vars.length;i++) {
      var pair = vars[i].split("=");
          // If first entry with this name
      if (typeof query_string[pair[0]] === "undefined") {
        query_string[pair[0]] = decodeURIComponent(pair[1]);
          // If second entry with this name
      } else if (typeof query_string[pair[0]] === "string") {
        var arr = [ query_string[pair[0]],decodeURIComponent(pair[1]) ];
        query_string[pair[0]] = arr;
          // If third or later entry with this name
      } else {
        query_string[pair[0]].push(decodeURIComponent(pair[1]));
      }
    }
    return query_string;
  }();

  if(query_string.voted) {
    $('#thanks-for-voting').removeClass('hidden');
  }

  if(query_string.fraud) {
    $('#voter-fraud').removeClass('hidden');
  }

  var request_results = function() {
    app.get_election(electionId, success_handler, failure_handler);
  }

  var success_handler = function(data) {
    if(data.data.status == "open") {
      $('#vote_count').text(data.data.vote_count)
      setTimeout(request_results, 5000);
      return;
    }

    $('#results-box').removeClass('hidden');
    $('#still-going').addClass('hidden');

    $.each(data.data.candidates, function(i, candidate) {
      if(candidate.winner) {
        $('#winners').append("<li class='list-group-item'>" + candidate.name + "</li>");
      }
    });
  }

  var failure_handler = function(data) {
    console.log("Replace this with a 404 please!");
  }

  request_results();
}

///////////
// Index //
///////////

election = document.getElementById("election-index");

if (election) {
  var success_handler = function(data) {
    if(data.data.length > 0) {
      $('#election-box').removeClass('hidden');
      $.each(data.data, function(i, entry) {
        $('#current-elections').append("<tr><td><a href='/vote/" + entry.id +"'>" + entry.name +
          "</a></td><td>" + entry.seat_count+ "</td><td>" + entry.created_at + "</td></tr>");
      });
    }
  }

  var failure_handler = function(data) {
    console.log("Handle this.");
  }

  app.get_elections(success_handler, failure_handler);
}
