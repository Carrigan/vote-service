import "phoenix_html"
import Vue from 'vue'
import VueResource from 'vue-resource'
import VueCookie from 'vue-cookie'

Vue.use(VueResource);
Vue.use(VueCookie);

let election = document.getElementById("election");

if (document.getElementById("election-index")) {
  var electionIndex = new Vue({
    el: '#election-index',
    data: {
      elections: []
    },
    methods: {
      renderElectionUrl: function(id) {
        return '/vote/' + id;
      },
      loadElections: function() {
        this.$http.get('/api/elections').then((response) => {
          this.elections =response.data.data;
        });
      }
    }
  });

  electionIndex.loadElections();
}

if (document.getElementById("ballot")) {
  var ballotApp = new Vue({
    el: '#ballot',
    data: {
      id: election.getAttribute("data-id"),
      election: [],
      currentRank: 0
    },
    methods: {
      initialize: function() {
        if (this.$cookie.get('election-' + this.id) == 'voted') {
          window.location.href = "/results/" + this.id + "?fraud=true";
        }

        this.$http.get('/api/elections/' + this.id).then((response) => {
          let election = response.data.data;
          election.candidates.forEach(candidate => candidate.rank = null);
          this.election = election;
        });
      },

      selectCandidate: function(selected) {
        if (selected.rank !== null) {
          let selectedRank = selected.rank;

          this.election.candidates.forEach(candidate => {
            if (candidate.rank > selectedRank) {
              candidate.rank -= 1;
            }

            if (candidate.id === selected.id) {
              candidate.rank = null;
            }
          });

          this.currentRank -= 1;
        } else {
          selected.rank = this.currentRank;
          this.currentRank += 1;
        }
      },

      renderRank: function(rank) {
        if (rank === null) return null;
        return rank + 1;
      },

      submitVote: function() {
        let entries = [];
        this.election.candidates.forEach(candidate => {
          if (candidate.rank !== null) {
            entries.push({ candidate_id: candidate.id, rank: candidate.rank });
          }
        });

        let body = { vote: { vote_entries: entries } }
        this.$http.post('/api/elections/' + this.id + '/votes', body).then((response) => {
          this.$cookie.set('election-' + this.id, 'voted');
          window.location.href = "/results/" + this.id + "?voted=true";
        });
      }
    }
  });

  ballotApp.initialize();
}
