Books = new Meteor.Collection('books');

Meteor.methods({
  echo: function(message) {
    return message.message;
  },

  ping: function(message) {   
    return 'pong';
  }
});