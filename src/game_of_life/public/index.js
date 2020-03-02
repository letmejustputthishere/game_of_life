import game_of_life from 'ic:canisters/game_of_life';

game_of_life.greet(window.prompt("Enter your name:")).then(greeting => {
  window.alert(greeting);
});
