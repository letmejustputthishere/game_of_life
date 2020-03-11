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
    const renderLoop = async () => {
      pre.textContent = await game_of_life.render();
      game_of_life.tick();

      requestAnimationFrame(renderLoop);
    };
    requestAnimationFrame(renderLoop);
  }



  render() {
    return (
      <body >
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
        <div style={
          { "position": "absolute" },
          { "top": "0" },
          { "left": "0" },
          { "width": "100 %" },
          { "height": "100 %" },
          { "display": "flex" },
          { "flex-direction": "column" },
          { "align-items": "center" },
          { "justify-content": "center" }}>
          <pre id="game-of-life-canvas"></pre>
        </div>
        <div>
          Draw Matrix:<button onClick={
            () => this.doRender()
          }>Render</button>
        </div>
      </body>
    );
  }
}

render(<MyHello />, document.getElementById('app'));
