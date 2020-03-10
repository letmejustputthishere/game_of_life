import game_of_life from 'ic:canisters/game_of_life';
import * as React from 'react';
import { render } from 'react-dom';

class MyHello extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
    };
  }

  async doPopulate() {
    let width = document.getElementById("newEntryWidth").value;
    let height = document.getElementById("newEntryHeight").value;

    game_of_life.populate(parseInt(width, 10), parseInt(height, 10));
  }

  async doStart() {
    game_of_life.start();
  }


  // componentDidMount() {
  //   const canvas = this.refs.canvas
  //   const ctx = canvas.getContext("2d")
  //   ctx.fillStyle = "#FF0000"
  //   ctx.fillRect(0, 0, 80, 80)
  // }

  render() {
    return (
      // <body style={
      //   { "position": "absolute" },
      //   { "top": "0" },
      //   { "left": "0" },
      //   { "width": "100 %" },
      //   { "height": "100 %" },
      //   { "display": "flex" },
      //   { "flex-direction": "column" },
      //   { "align-items": "center" },
      //   { "justify-content": "center" }}>
      //   <canvas id="game-of-life-canvas"></canvas>
      //   <div style={{ "font-size": "30px" }}>
      //     <div style={{ "background-color": "yellow" }}>
      //       <p>Greetings, from DFINITY!</p>
      //       <p> Type your message in the Name input field, then click <b> Get Greeting</b> to display the result.</p>
      //     </div>
      //     <div style={{ "margin": "30px" }}>
      //       <input id="name" value={this.state.name} onChange={ev => this.onNameChange(ev)}></input>
      //       <button onClick={() => this.doGreet()}>Get Greeting!</button>
      //     </div>
      //     <div>Greeting is: "<span style={{ "color": "blue" }}>{this.state.message}</span>"</div>
      //   </div>
      // </body>
      <div>
        <h1>Game of Life</h1>
        <div>
          Populate the universe:
          <table>
            <tr><td>Width:</td><td><input id="newEntryWidth"></input></td></tr>
            <tr><td>Height:</td><td><input id="newEntryHeight"></input></td></tr>
          </table>
          <button onClick={() => this.doPopulate()}>Populate</button>
        </div>
        <div>
          Start the game:<button onClick={
            () => this.doStart()
          }>Start</button>
        </div>
      </div>
      // <div>
      // <canvas ref="canvas" width={640} height={425} />
      // </div> 
    );
  }
}

render(<MyHello />, document.getElementById('app'));
