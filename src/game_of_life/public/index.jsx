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

  async doRender() {
    const pre = document.getElementById("game-of-life-canvas");
    const renderLoop = () => {
      pre.textContent = game_of_life.render();
      universe.tick();

      requestAnimationFrame(renderLoop);
    };
  }


  componentDidMount() {
    const canvas = this.refs.canvas
    const ctx = canvas.getContext("2d")
    ctx.fillStyle = "#FF0000"
    ctx.fillRect(0, 0, 80, 80)
  }

  render() {
    return (
      <body style={
        { "position": "absolute" },
        { "top": "0" },
        { "left": "0" },
        { "width": "100 %" },
        { "height": "100 %" },
        { "display": "flex" },
        { "flex-direction": "column" },
        { "align-items": "center" },
        { "justify-content": "center" }}>
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
        <div >
          <canvas ref="canvas" width={640} height={425} />
        </div>
        <pre> id="game-of-life-canvas"</pre>
      </body>
    );
  }
}

render(<MyHello />, document.getElementById('app'));
