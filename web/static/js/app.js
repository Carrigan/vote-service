import "phoenix_html"
import Vue from 'vue'
import VueResource from 'vue-resource'
Vue.use(VueResource);

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
